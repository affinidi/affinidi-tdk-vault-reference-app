import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ssi/ssi.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

import 'package:tdk_reference_app/application/services/iota/iota_share_flow_service.dart';
import 'package:tdk_reference_app/domain/models/profile/profile_type.dart';
import 'package:tdk_reference_app/infrastructure/utils/constants.dart';
import 'package:tdk_reference_app/l10n/app_localizations.dart';
import 'package:tdk_reference_app/main.dart' as app;

import 'fixtures/share_flow_fixtures.dart';
import 'test_utils.dart';

// ---------------------------------------------------------------------------
// Mocks / Fakes
// ---------------------------------------------------------------------------

class _MockShareFlowService extends Mock implements ShareFlowServiceInterface {}

class _MockShareResponseService extends Mock
    implements IotaShareResponseServiceInterface {}

/// A matcher fake whose [result] can be swapped between scenarios so a single
/// long-running app session can exercise several matching outcomes.
class _MutableCredentialMatcher extends Fake
    implements CredentialMatcherServiceInterface {
  late MatchedCredentialsResult result;

  @override
  Future<MatchedCredentialsResult> match(
    Oid4vpShareRequest shareRequest,
    List<VerifiableCredential> allVCs,
  ) async =>
      result;
}

extension _WidgetTesterExt on WidgetTester {
  /// Pumps in small increments until [finder] matches or [timeout] elapses.
  ///
  /// Unlike `pumpAndSettle`, this tolerates in-flight async work (e.g. vault
  /// seed generation or vault unlock) that completes between frames rather
  /// than via a running animation.
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      // `this.` disambiguates from mocktail's top-level `any` matcher.
      if (this.any(finder)) return;
    }
    throw Exception('Widget not found within $timeout: $finder');
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp({
  required _MockShareFlowService shareFlowService,
  required _MutableCredentialMatcher matcher,
  required _MockShareResponseService responseServiceMock,
}) =>
    ProviderScope(
      overrides: [
        iotaShareFlowServiceProvider.overrideWithValue(shareFlowService),
        iotaCredentialMatcherServiceProvider.overrideWithValue(matcher),
        // Override the factory so ALL instances of the response service
        // family return the same mock, regardless of vaultId / accountIndex.
        iotaShareResponseServiceFactoryProvider.overrideWithValue(
          ({required String vaultId, required int accountIndex}) =>
              responseServiceMock,
        ),
      ],
      child: const app.MyApp(),
    );

Future<void> _createVaultHelper(
  WidgetTester tester, {
  required AppLocalizations localizations,
}) async {
  await tester.pumpUntilFound(find.text(localizations.addVault));
  await tester.tap(find.text(localizations.addVault));
  // Wait for the create-vault form's action button, then fill the fields.
  await tester.pumpUntilFound(find.text(localizations.createVault));

  await tester.enterText(
    find.bySemanticsLabel(localizations.giveYourVaultAName),
    shareFlowVaultName,
  );
  await tester.enterText(
    find.bySemanticsLabel(localizations.chooseAPassphrase),
    shareFlowPassphrase,
  );
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();

  await tester.tap(find.text(localizations.createVault));
  await tester.pumpAndSettle();

  // Vault creation is async; wait for the vault details page to appear.
  await tester.pumpUntilFound(
    find.text(shareFlowVaultName),
    timeout: const Duration(seconds: 15),
  );
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
  await tester.pumpAndSettle();
}

/// Opens the vault (navigates to VaultProfilesPage) and creates a profile.
///
/// A profile is required so that the share credential controller can load a
/// non-empty profiles list and proceed to credential matching.
Future<void> _openVaultAndCreateProfile(
  WidgetTester tester, {
  required AppLocalizations localizations,
}) async {
  await tester.tap(find.text(shareFlowVaultName));
  await tester.pumpUntilFound(
    find.bySemanticsLabel(localizations.enterPassphrase),
  );
  await tester.enterText(
    find.bySemanticsLabel(localizations.enterPassphrase),
    shareFlowPassphrase,
  );
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.accessVaultActionLabel));

  // Create one profile so the share credential controller can load it.
  await tester.pumpUntilFound(
    find.text(localizations.createProfile),
    timeout: const Duration(seconds: 15),
  );
  await tester.tap(find.text(localizations.createProfile));
  await tester.pumpUntilFound(
    find.bySemanticsLabel(localizations.profileNamePlaceholder),
  );

  await tester.enterText(
    find.bySemanticsLabel(localizations.profileNamePlaceholder),
    'Share Test Profile',
  );
  await tester.enterText(
    find.bySemanticsLabel(localizations.profileDescriptionPlaceholder),
    'Profile for share flow tests',
  );
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();

  // Create a local (edge/drift) profile so creation stays fully on-device —
  // no cloud repository, network, or auth — keeping the test deterministic.
  await tester.tap(
    find.byKey(Key('${KeyConstants.keyRadio}_${ProfileType.edge.name}')),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text(localizations.createProfileActionText));
  await tester.pumpUntilFound(
    find.text('Share Test Profile'),
    timeout: const Duration(seconds: 15),
  );

  // Back to VaultsPage from VaultProfilesPage.
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
  await tester.pumpAndSettle();
}

Future<void> _openShareDialog(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  await tester.pumpUntilFound(find.text(localizations.shareVc));
  await tester.tap(find.text(localizations.shareVc));
  await tester.pumpAndSettle();
}

Future<void> _submitShareUrl(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  // The bottom sheet presents a multiline TextField for the URL.
  await tester.pumpUntilFound(find.byType(TextField));
  await tester.enterText(find.byType(TextField), shareFlowUrl);
  await tester.tap(find.text(localizations.continueActionText));
  await tester.pumpAndSettle();
}

Future<void> _enterPassphraseOnSharePageAndAwaitReady(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  await tester.pumpAndSettle();
  // When the vault is already open (unlocked during setup), the share page
  // loads profiles automatically and shows no passphrase field; only enter a
  // passphrase when the field is actually prompted.
  final field = find.byType(TextField);
  if (field.evaluate().isNotEmpty) {
    await tester.enterText(field.first, shareFlowPassphrase);
    // Trigger [onSubmitted] via keyboard done action.
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }
  // Vault unlock + credential matching are async; wait for the ready state.
  await tester.pumpUntilFound(
    find.text(localizations.shareSubmit),
    timeout: const Duration(seconds: 20),
  );
}

/// Returns to the vaults page by tapping back until it is visible.
Future<void> _returnToVaultsPage(WidgetTester tester) async {
  for (var i = 0;
      i < 5 && find.text(shareFlowVaultName).evaluate().isEmpty;
      i++) {
    final back = find.byIcon(Icons.arrow_back_ios_new_rounded);
    if (back.evaluate().isEmpty) break;
    await tester.tap(back.first);
    await tester.pumpAndSettle();
  }
}

/// Opens the vault's profiles page, logging in only if a locked vault prompts
/// for the passphrase (it stays unlocked across scenarios in the same session).
Future<void> _openVaultToProfiles(
  WidgetTester tester,
  AppLocalizations localizations, {
  required String expectedProfile,
}) async {
  await tester.tap(find.text(shareFlowVaultName));
  await tester.pumpAndSettle();

  final passphraseField = find.bySemanticsLabel(localizations.enterPassphrase);
  if (passphraseField.evaluate().isNotEmpty) {
    await tester.enterText(passphraseField, shareFlowPassphrase);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text(localizations.accessVaultActionLabel));
  }

  await tester.pumpUntilFound(
    find.text(expectedProfile),
    timeout: const Duration(seconds: 15),
  );
}

List<ParsedVerifiableCredential<dynamic>> _capturedSubmittedCredentials(
  _MockShareResponseService mock,
) {
  final captured = verify(
    () => mock.submitShareResponse(
      shareRequest: any(named: 'shareRequest'),
      selectedCredentials: captureAny(named: 'selectedCredentials'),
      acceptResponseUri: any(named: 'acceptResponseUri'),
    ),
  ).captured;
  return captured.single as List<ParsedVerifiableCredential<dynamic>>;
}

// ---------------------------------------------------------------------------
// Test
// ---------------------------------------------------------------------------
//
// All scenarios run inside a SINGLE testWidgets so they share one app process,
// one vault, and one profile. Isolating them into separate testWidgets is not
// viable: app-level static singletons (AppDatabase, VaultService edge caches)
// survive between tests, so a fresh test sees the previous test's vault. Running
// sequentially against a stable, unlocked vault sidesteps that entirely; state
// that must not leak between scenarios (the response mock's call count) is reset
// with `clearInteractions`.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('share credential flow scenarios', (tester) async {
    registerFallbackValue(<ParsedVerifiableCredential<dynamic>>[]);
    registerFallbackValue(await buildCannedShareRequest());
    registerFallbackValue(Uri());
    await initializeDateFormatting('en');
    await TestUtils.clearAll();

    final localizations =
        await AppLocalizations.delegate.load(const Locale('en'));

    final mockShareFlowService = _MockShareFlowService();
    final mockShareResponseService = _MockShareResponseService();
    final matcher = _MutableCredentialMatcher();

    when(() => mockShareFlowService.validateOid4vpRequest(any()))
        .thenAnswer((_) => buildCannedShareRequest());
    when(
      () => mockShareResponseService.submitShareResponse(
        shareRequest: any(named: 'shareRequest'),
        selectedCredentials: any(named: 'selectedCredentials'),
        acceptResponseUri: any(named: 'acceptResponseUri'),
      ),
    ).thenAnswer((_) async => null);
    when(
      () => mockShareResponseService.rejectShareResponse(
        shareRequest: any(named: 'shareRequest'),
        rejectResponseUri: any(named: 'rejectResponseUri'),
      ),
    ).thenAnswer((_) async => null);

    await tester.pumpWidget(_buildApp(
      shareFlowService: mockShareFlowService,
      matcher: matcher,
      responseServiceMock: mockShareResponseService,
    ));
    await tester.pumpAndSettle();

    await _createVaultHelper(tester, localizations: localizations);
    await _openVaultAndCreateProfile(tester, localizations: localizations);

    // Reject runs first: a successful submit shows a bottom snackbar that would
    // otherwise obscure the "Cancel" button on the next share page.
    // --- Scenario: reject rejects the request and returns to vaults page -----
    matcher.result = buildMatchResult(buildFixtureVc());
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.text(localizations.shareReject));
    await tester.pumpAndSettle();

    expect(find.text(shareFlowVaultName), findsOneWidget);
    verify(
      () => mockShareResponseService.rejectShareResponse(
        shareRequest: any(named: 'shareRequest'),
        rejectResponseUri: any(named: 'rejectResponseUri'),
      ),
    ).called(1);
    clearInteractions(mockShareResponseService);

    // --- Scenario: submit shares credentials and returns to vaults page ------
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.text(localizations.shareSubmit));
    await tester.pumpAndSettle();

    expect(find.text(shareFlowVaultName), findsOneWidget);
    verify(
      () => mockShareResponseService.submitShareResponse(
        shareRequest: any(named: 'shareRequest'),
        selectedCredentials: any(named: 'selectedCredentials'),
        acceptResponseUri: any(named: 'acceptResponseUri'),
      ),
    ).called(1);
    clearInteractions(mockShareResponseService);

    // --- Scenario: multiple credential groups are all submitted --------------
    matcher.result = buildMultiGroupMatchResult(
      firstVc: buildFixtureVc(
        id: 'urn:test:vc:email:1',
        type: 'EmailCredential',
      ),
      secondVc: buildFixtureVc(
        id: 'urn:test:vc:phone:1',
        type: 'PhoneCredential',
        subjectKey: 'phone',
        subjectValue: '+15551234567',
      ),
    );
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.text(localizations.shareSubmit));
    await tester.pumpAndSettle();

    expect(find.text(shareFlowVaultName), findsOneWidget);
    // One credential from each of the two groups.
    expect(
      _capturedSubmittedCredentials(mockShareResponseService),
      hasLength(2),
    );
    clearInteractions(mockShareResponseService);

    // --- Scenario: minimumVCsCountToShare > 1 submits the required count -----
    matcher.result = buildMinCountMatchResult(
      vcs: [
        buildFixtureVc(id: 'urn:test:vc:email:1'),
        buildFixtureVc(
          id: 'urn:test:vc:email:2',
          subjectValue: 'second@example.com',
        ),
      ],
      minimum: 2,
    );
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.text(localizations.shareSubmit));
    await tester.pumpAndSettle();

    expect(find.text(shareFlowVaultName), findsOneWidget);
    // The group requires two credentials, so both are submitted.
    expect(
      _capturedSubmittedCredentials(mockShareResponseService),
      hasLength(2),
    );
    clearInteractions(mockShareResponseService);

    // --- Scenario: share still works after the profile is renamed ------------
    matcher.result = buildMatchResult(buildFixtureVc());
    await _openVaultToProfiles(
      tester,
      localizations,
      expectedProfile: 'Share Test Profile',
    );

    await tester.tap(find.text('Share Test Profile'));
    await tester.pumpUntilFound(
      find.byKey(Key(KeyConstants.keySettingsButton)),
    );
    // Settle the page-in transition so the button is on-screen before tapping.
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(KeyConstants.keySettingsButton)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(localizations.editProfile));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Renamed Profile');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.tap(find.text(localizations.saveActionText));
    await tester.pumpAndSettle();

    await _returnToVaultsPage(tester);
    expect(find.text(shareFlowVaultName), findsOneWidget);

    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.text(localizations.shareSubmit));
    await tester.pumpAndSettle();

    expect(find.text(shareFlowVaultName), findsOneWidget);
    verify(
      () => mockShareResponseService.submitShareResponse(
        shareRequest: any(named: 'shareRequest'),
        selectedCredentials: any(named: 'selectedCredentials'),
        acceptResponseUri: any(named: 'acceptResponseUri'),
      ),
    ).called(1);
    clearInteractions(mockShareResponseService);

    // --- Scenario: auto-consent reuse (runs LAST) ----------------------------
    // Enabling auto-share persists a reusable consent record for this
    // request+vault; a second identical request must then submit without any
    // user interaction. This must be the final scenario so the persisted
    // auto-share record cannot short-circuit earlier manual scenarios.
    matcher.result = buildMatchResult(buildFixtureVc());
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await _enterPassphraseOnSharePageAndAwaitReady(tester, localizations);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text(localizations.shareSubmit));
    await tester.pumpAndSettle();
    expect(find.text(shareFlowVaultName), findsOneWidget);

    // Second identical share: a matching auto-share record exists, so it
    // submits without the user entering a passphrase or tapping Share.
    await _openShareDialog(tester, localizations);
    await _submitShareUrl(tester, localizations);
    await tester.pumpUntilFound(
      find.text(shareFlowVaultName),
      timeout: const Duration(seconds: 20),
    );

    verify(
      () => mockShareResponseService.submitShareResponse(
        shareRequest: any(named: 'shareRequest'),
        selectedCredentials: any(named: 'selectedCredentials'),
        acceptResponseUri: any(named: 'acceptResponseUri'),
      ),
    ).called(2);
  });
}
