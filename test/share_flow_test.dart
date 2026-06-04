import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ssi/ssi.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

import 'package:tdk_reference_app/application/services/iota/iota_share_flow_service.dart';
import 'package:tdk_reference_app/l10n/app_localizations.dart';
import 'package:tdk_reference_app/main.dart' as app;

import '../integration_test/test_utils.dart';
import 'fixtures/share_flow_fixtures.dart';

// ---------------------------------------------------------------------------
// Mocks / Fakes
// ---------------------------------------------------------------------------

class _MockShareFlowService extends Mock implements ShareFlowServiceInterface {}

class _MockShareResponseService extends Mock
    implements IotaShareResponseServiceInterface {}

class _FakeShareRequirementsMatcher extends Fake
    implements ShareRequirementsMatcher {
  _FakeShareRequirementsMatcher(this._result);

  final ClaimedCredentialsResult _result;

  @override
  Future<ClaimedCredentialsResult> match(
    PDRequirements requirements,
    List<VerifiableCredential> allVCs,
  ) async =>
      _result;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildApp({
  required _MockShareFlowService shareFlowService,
  required ClaimedCredentialsResult matchResult,
  required _MockShareResponseService responseServiceMock,
}) =>
    ProviderScope(
      overrides: [
        iotaShareFlowServiceProvider.overrideWithValue(shareFlowService),
        iotaShareRequirementsMatcherProvider.overrideWithValue(
          _FakeShareRequirementsMatcher(matchResult),
        ),
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
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.addVault));
  await tester.pumpAndSettle();

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

  // Navigate back from vault details page to VaultsPage.
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
  await tester.pumpAndSettle();
}

/// Opens the vault (navigates to VaultProfilesPage) and creates a profile.
///
/// A profile is required so that [ShareCredentialPageController.verifyPassphrase]
/// can load a non-empty profiles list and proceed to credential matching.
Future<void> _openVaultAndCreateProfile(
  WidgetTester tester, {
  required AppLocalizations localizations,
}) async {
  await tester.tap(find.text(shareFlowVaultName));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.bySemanticsLabel(localizations.enterPassphrase),
    shareFlowPassphrase,
  );
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.accessVaultActionLabel));
  await tester.pumpAndSettle();

  // Create one profile so the share credential controller can load it.
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.createProfile));
  await tester.pumpAndSettle();

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
  await tester.tap(find.text(localizations.createProfileActionText));
  await tester.pumpAndSettle();

  // Back to VaultsPage from VaultProfilesPage.
  await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
  await tester.pumpAndSettle();
}

Future<void> _openShareDialog(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  await tester.pumpAndSettle();
  await tester.tap(find.text(localizations.shareVc));
  await tester.pumpAndSettle();
}

Future<void> _submitShareUrl(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  // The bottom sheet presents a multiline TextField for the URL.
  await tester.enterText(find.byType(TextField), shareFlowUrl);
  await tester.tap(find.text(localizations.continueActionText));
  await tester.pumpAndSettle();
}

Future<void> _enterPassphraseOnSharePage(
  WidgetTester tester,
  AppLocalizations localizations,
) async {
  // Wait for the share credential page's passphrase TextField to appear.
  // Before passphrase is verified, the LabelTextField for the passphrase is
  // the only visible TextField on the page.
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, shareFlowPassphrase);
  // Trigger [onSubmitted] via keyboard done action.
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() {
    registerFallbackValue(
      <({
        PDDescriptor descriptor,
        ParsedVerifiableCredential<dynamic> credential
      })>[],
    );
  });

  group('Share credential flow', () {
    late _MockShareFlowService mockShareFlowService;
    late _MockShareResponseService mockShareResponseService;
    late ClaimedCredentialsResult matchResult;

    setUp(() async {
      await initializeDateFormatting('en');
      await TestUtils.clearAll();

      mockShareFlowService = _MockShareFlowService();
      mockShareResponseService = _MockShareResponseService();
      matchResult = buildMatchResult(buildFixtureVc());

      when(
        () => mockShareFlowService.validateOid4vpRequest(
          any(),
          walletDid: any(named: 'walletDid'),
        ),
      ).thenAnswer((_) async => buildCannedShareRequest());

      when(
        () => mockShareResponseService.submitShareResponse(
          state: any(named: 'state'),
          nonce: any(named: 'nonce'),
          clientId: any(named: 'clientId'),
          definitionId: any(named: 'definitionId'),
          selectedCredentials: any(named: 'selectedCredentials'),
        ),
      ).thenAnswer((_) async => null);

      when(
        () => mockShareResponseService.rejectShareResponse(
          state: any(named: 'state'),
        ),
      ).thenAnswer((_) async => null);
    });

    Future<void> launchAndSetup(WidgetTester tester) async {
      final localizations =
          await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(_buildApp(
        shareFlowService: mockShareFlowService,
        matchResult: matchResult,
        responseServiceMock: mockShareResponseService,
      ));
      await tester.pumpAndSettle();

      await _createVaultHelper(tester, localizations: localizations);
      await _openVaultAndCreateProfile(tester, localizations: localizations);
    }

    testWidgets(
      'submit: credentials are shared and app returns to vaults page',
      (tester) async {
        final localizations =
            await AppLocalizations.delegate.load(const Locale('en'));

        await launchAndSetup(tester);
        await _openShareDialog(tester, localizations);
        await _submitShareUrl(tester, localizations);
        await _enterPassphraseOnSharePage(tester, localizations);

        // Wait for credential matching to complete and Share button to appear.
        await tester.pumpAndSettle();
        await tester.tap(find.text(localizations.shareSubmit));
        await tester.pumpAndSettle();

        expect(find.text(shareFlowVaultName), findsOneWidget);
        verify(
          () => mockShareResponseService.submitShareResponse(
            state: any(named: 'state'),
            nonce: any(named: 'nonce'),
            clientId: any(named: 'clientId'),
            definitionId: any(named: 'definitionId'),
            selectedCredentials: any(named: 'selectedCredentials'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'reject: share request is rejected and app returns to vaults page',
      (tester) async {
        final localizations =
            await AppLocalizations.delegate.load(const Locale('en'));

        await launchAndSetup(tester);
        await _openShareDialog(tester, localizations);
        await _submitShareUrl(tester, localizations);
        await _enterPassphraseOnSharePage(tester, localizations);

        // Wait for matching to settle so [rejectShareRequest] has a resolved
        // profile and account index available.
        await tester.pumpAndSettle();
        await tester.tap(find.text(localizations.shareReject));
        await tester.pumpAndSettle();

        expect(find.text(shareFlowVaultName), findsOneWidget);
        verify(
          () => mockShareResponseService.rejectShareResponse(
            state: any(named: 'state'),
          ),
        ).called(1);
      },
    );
  });
}
