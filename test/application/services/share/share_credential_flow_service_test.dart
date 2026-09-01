import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tdk_reference_app/application/services/share/consent_service.dart';
import 'package:tdk_reference_app/application/services/share/credential_matching_service.dart';
import 'package:tdk_reference_app/application/services/share/share_credential_flow_service.dart';
import 'package:tdk_reference_app/application/services/share/share_request_validation_service.dart';
import 'package:tdk_reference_app/application/services/share/share_submission_service.dart';
import 'package:tdk_reference_app/application/services/vault/vault_service.dart';
import 'package:tdk_reference_app/application/services/vault/vault_service_state.dart';
import 'package:tdk_reference_app/infrastructure/exceptions/app_exception.dart';
import 'package:tdk_reference_app/infrastructure/external_link/external_redirect_service.dart';

import '../../../helpers/share_flow_fixtures.dart';

class _MockVaultService extends Mock implements VaultService {}

class _MockShareRequestValidationService extends Mock
    implements ShareRequestValidationService {}

class _MockCredentialMatchingService extends Mock
    implements CredentialMatchingService {}

class _MockConsentService extends Mock implements ConsentService {}

class _MockShareSubmissionService extends Mock
    implements ShareSubmissionService {}

class _MockExternalRedirectService extends Mock
    implements ExternalRedirectService {}

class _MockCredentialStorage extends Mock implements CredentialStorage {}

const _vaultId = 'vault-1';
const _profileId = 'profile-1';

Profile _buildProfile({bool withCredentialStorage = true}) => Profile(
      id: _profileId,
      accountIndex: 0,
      name: 'Test profile',
      did: 'did:key:testholder',
      profileRepositoryId: 'repo-1',
      fileStorages: const {},
      sharedStorages: const {},
      credentialStorages: withCredentialStorage
          ? {'default': _MockCredentialStorage()}
          : const {},
    );

void main() {
  late _MockVaultService vaultService;
  late _MockShareRequestValidationService validationService;
  late _MockCredentialMatchingService matchingService;
  late _MockConsentService consentService;
  late _MockShareSubmissionService submissionService;
  late _MockExternalRedirectService redirectService;
  late VaultServiceState vaultState;
  late List<Profile> profiles;
  late ShareCredentialFlowService shareFlowService;

  setUpAll(() {
    registerFallbackValue(const VerifierClientMetadata());
    registerFallbackValue(const ClaimedCredentialsResult(vcsGroups: {}));
    registerFallbackValue(Uri.parse('https://verifier.test/callback'));
    registerFallbackValue(_MockCredentialStorage());
  });

  setUp(() {
    vaultService = _MockVaultService();
    validationService = _MockShareRequestValidationService();
    matchingService = _MockCredentialMatchingService();
    consentService = _MockConsentService();
    submissionService = _MockShareSubmissionService();
    redirectService = _MockExternalRedirectService();
    vaultState = VaultServiceState();
    profiles = [];

    shareFlowService = ShareCredentialFlowService(
      vaultService: vaultService,
      vaultState: () => vaultState,
      loadProfiles: () async => profiles,
      currentProfiles: () => profiles,
      validationService: validationService,
      matchingService: matchingService,
      consentService: consentService,
      submissionService: submissionService,
      redirectService: redirectService,
    );
  });

  group('isVaultOpen', () {
    test('is true when the currently open vault matches', () {
      vaultState = vaultState.copyWith(currentVaultId: _vaultId);
      expect(shareFlowService.isVaultOpen(_vaultId), isTrue);
    });

    test('is false when no vault or a different vault is open', () {
      expect(shareFlowService.isVaultOpen(_vaultId), isFalse);
      vaultState = vaultState.copyWith(currentVaultId: 'other-vault');
      expect(shareFlowService.isVaultOpen(_vaultId), isFalse);
    });
  });

  group('unlockVault', () {
    test('delegates to VaultService.open', () async {
      when(() => vaultService.open(vaultId: _vaultId, password: 'pw'))
          .thenAnswer((_) async {});

      await shareFlowService.unlockVault(vaultId: _vaultId, password: 'pw');

      verify(() => vaultService.open(vaultId: _vaultId, password: 'pw'))
          .called(1);
    });
  });

  group('loadProfilesForOpenVault', () {
    test('returns an empty list when no vault is open', () async {
      final result = await shareFlowService.loadProfilesForOpenVault();
      expect(result, isEmpty);
    });

    test('delegates to ProfileService when a vault is open', () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      profiles = [_buildProfile()];

      final result = await shareFlowService.loadProfilesForOpenVault();

      expect(result, profiles);
    });
  });

  group('validateRequest', () {
    test('delegates to ShareRequestValidationService', () async {
      final shareRequest = await buildCannedShareRequest();
      final validated = ValidatedShareRequest(request: shareRequest);
      when(() => validationService.validate('jwt'))
          .thenAnswer((_) async => validated);

      final result = await shareFlowService.validateRequest('jwt');

      expect(result, same(validated));
    });
  });

  group('matchCredentials', () {
    test('throws when the vault is not open', () async {
      final shareRequest = await buildCannedShareRequest();

      expect(
        () => shareFlowService.matchCredentials(
          vaultId: _vaultId,
          profileId: _profileId,
          shareRequest: shareRequest,
          verifierMetadata: const VerifierClientMetadata(),
        ),
        throwsA(isA<AppException>().having(
          (e) => e.type,
          'type',
          AppExceptionType.vaultNotInitialized,
        )),
      );
    });

    test('throws when the profile is not loaded', () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      final shareRequest = await buildCannedShareRequest();

      expect(
        () => shareFlowService.matchCredentials(
          vaultId: _vaultId,
          profileId: _profileId,
          shareRequest: shareRequest,
          verifierMetadata: const VerifierClientMetadata(),
        ),
        throwsA(isA<AppException>().having(
          (e) => e.type,
          'type',
          AppExceptionType.missingProfile,
        )),
      );
    });

    test(
        'returns an empty ready-to-share result when there is no credential storage',
        () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      profiles = [_buildProfile(withCredentialStorage: false)];
      final shareRequest = await buildCannedShareRequest();

      final outcome = await shareFlowService.matchCredentials(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
        verifierMetadata: const VerifierClientMetadata(),
      );

      expect(outcome, isA<MatchReadyToShare>());
      expect(
        (outcome as MatchReadyToShare).matchResult.groups,
        isEmpty,
      );
    });

    test('returns MatchReadyToShare when auto-consent declines', () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      const matchResult = ClaimedCredentialsResult(vcsGroups: {});
      when(() => matchingService.match(
            shareRequest: shareRequest,
            storage: any(named: 'storage'),
          )).thenAnswer((_) async => matchResult);
      when(() => consentService.tryAutomaticConsent(
            vaultId: _vaultId,
            accountIndex: profile.accountIndex,
            shareRequest: shareRequest,
            matchResult: matchResult,
            verifierMetadata: const VerifierClientMetadata(),
          )).thenAnswer((_) async => const AutoConsentDeclined());

      final outcome = await shareFlowService.matchCredentials(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
        verifierMetadata: const VerifierClientMetadata(),
      );

      expect(outcome, isA<MatchReadyToShare>());
    });

    test(
        'returns MatchAutoConsented and shows a toast when there is no redirect',
        () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      const matchResult = ClaimedCredentialsResult(vcsGroups: {});
      when(() => matchingService.match(
            shareRequest: shareRequest,
            storage: any(named: 'storage'),
          )).thenAnswer((_) async => matchResult);
      when(() => consentService.tryAutomaticConsent(
                vaultId: _vaultId,
                accountIndex: profile.accountIndex,
                shareRequest: shareRequest,
                matchResult: matchResult,
                verifierMetadata: const VerifierClientMetadata(),
              ))
          .thenAnswer(
              (_) async => const AutoConsentApproved(redirectUri: null));

      final outcome = await shareFlowService.matchCredentials(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
        verifierMetadata: const VerifierClientMetadata(),
      );

      expect(outcome, isA<MatchAutoConsented>());
      final dismissal = (outcome as MatchAutoConsented).dismissal;
      expect(dismissal.redirectUri, isNull);
      expect(dismissal.showShareSuccessToast, isTrue);
    });

    test(
        'returns MatchAutoConsented without a toast when the redirect launches',
        () async {
      vaultState = vaultState.copyWith(currentVault: _FakeVault());
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      const matchResult = ClaimedCredentialsResult(vcsGroups: {});
      final redirectUri = Uri.parse('https://verifier.test/callback');
      when(() => matchingService.match(
            shareRequest: shareRequest,
            storage: any(named: 'storage'),
          )).thenAnswer((_) async => matchResult);
      when(() => consentService.tryAutomaticConsent(
                vaultId: _vaultId,
                accountIndex: profile.accountIndex,
                shareRequest: shareRequest,
                matchResult: matchResult,
                verifierMetadata: const VerifierClientMetadata(),
              ))
          .thenAnswer(
              (_) async => AutoConsentApproved(redirectUri: redirectUri));
      when(() => redirectService.open(redirectUri))
          .thenAnswer((_) async => true);

      final outcome = await shareFlowService.matchCredentials(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
        verifierMetadata: const VerifierClientMetadata(),
      );

      final dismissal = (outcome as MatchAutoConsented).dismissal;
      expect(dismissal.redirectUri, redirectUri);
      expect(dismissal.showShareSuccessToast, isFalse);
    });
  });

  group('submit', () {
    test('throws when the group selection is insufficient', () async {
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      const matchResult = ClaimedCredentialsResult(vcsGroups: {});
      when(() => submissionService.selectCredentials(
            matchResult: matchResult,
            selectedIds: <String>{},
          )).thenReturn(const InsufficientCredentials());

      expect(
        () => shareFlowService.submit(
          vaultId: _vaultId,
          profileId: _profileId,
          shareRequest: shareRequest,
          matchResult: matchResult,
          selectedCredentialIds: const {},
          verifierMetadata: const VerifierClientMetadata(),
          autoAllowConsent: false,
          isConsentManagementEnabled: false,
        ),
        throwsA(isA<AppException>().having(
          (e) => e.type,
          'type',
          AppExceptionType.missingVerifiableCredentials,
        )),
      );
    });

    test('submits and shows a toast when there is no redirect', () async {
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      const matchResult = ClaimedCredentialsResult(vcsGroups: {});
      when(() => submissionService.selectCredentials(
            matchResult: matchResult,
            selectedIds: <String>{'vc-1'},
          )).thenReturn(const CredentialsSelected([]));
      when(() => submissionService.submit(
            vaultId: _vaultId,
            profile: profile,
            shareRequest: shareRequest,
            credentials: const [],
            verifierMetadata: const VerifierClientMetadata(),
            isAutoShareEnabled: true,
            isConsentManagementEnabled: false,
          )).thenAnswer((_) async => null);

      final outcome = await shareFlowService.submit(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
        matchResult: matchResult,
        selectedCredentialIds: const {'vc-1'},
        verifierMetadata: const VerifierClientMetadata(),
        autoAllowConsent: true,
        isConsentManagementEnabled: false,
      );

      expect(outcome.redirectUri, isNull);
      expect(outcome.showShareSuccessToast, isTrue);
    });
  });

  group('reject', () {
    test('dismisses without a toast when there is no redirect', () async {
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      when(() => submissionService.reject(
            vaultId: _vaultId,
            profile: profile,
            shareRequest: shareRequest,
          )).thenAnswer((_) async => null);

      final outcome = await shareFlowService.reject(
        vaultId: _vaultId,
        profileId: _profileId,
        shareRequest: shareRequest,
      );

      expect(outcome.redirectUri, isNull);
      expect(outcome.showShareSuccessToast, isFalse);
    });

    test('throws when the redirect fails to launch', () async {
      final profile = _buildProfile();
      profiles = [profile];
      final shareRequest = await buildCannedShareRequest();
      final redirectUri = Uri.parse('https://verifier.test/callback');
      when(() => submissionService.reject(
            vaultId: _vaultId,
            profile: profile,
            shareRequest: shareRequest,
          )).thenAnswer((_) async => redirectUri);
      when(() => redirectService.open(redirectUri))
          .thenAnswer((_) async => false);

      expect(
        () => shareFlowService.reject(
          vaultId: _vaultId,
          profileId: _profileId,
          shareRequest: shareRequest,
        ),
        throwsA(isA<AppException>().having(
          (e) => e.type,
          'type',
          AppExceptionType.redirectLaunchFailed,
        )),
      );
    });
  });
}

class _FakeVault extends Fake implements Vault {}
