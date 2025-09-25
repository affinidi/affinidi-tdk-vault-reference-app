import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../vault/vault_service.dart';
import 'credential_service_state.dart';

part 'credential_service.g.dart';

/// A service that manages claimed digital credentials (e.g. fetch, save, delete)
/// for a specific profile stored inside a Vault.
@riverpod
class CredentialService extends _$CredentialService {
  CredentialService() : super();

  CredentialStorage? _credentialsRepository;

  /// Initializes the service state for a given profile ID.
  /// This is called once per provider instance per profile.
  @override
  CredentialServiceState build({required String profileId}) {
    return CredentialServiceState();
  }

  /// Lazily initializes and returns the [CredentialStorage] repository
  /// for the current profile by reading from the [_vaultCredentialServiceProvider].
  Future<CredentialStorage> _getCredentialsRepository() async {
    _credentialsRepository ??=
        await ref.read(_vaultCredentialServiceProvider(profileId).future);
    return _credentialsRepository!;
  }

  Future<SharedStorage> _getSharedCredentialsRepository() async {
    final vaultServiceState = ref.read(vaultServiceProvider);
    final vault = vaultServiceState.currentVault;

    if (vault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.other,
      );
    }

    await vault.ensureInitialized();
    final profiles = await vault.listProfiles();

    for (final profile in profiles) {
      try {
        final sharedStorage =
            profile.sharedStorages.firstWhere((s) => s.id == profileId);
        return sharedStorage;
      } catch (e) {
        // Continue to next profile if shared storage not found
        continue;
      }
    }

    throw AppException(
      message: 'Shared storage not found',
      type: AppExceptionType.other,
    );
  }

  /// Fetches a paginated list of claimed credentials and updates the service state.
  ///
  /// [pageIndex] controls which page to fetch.
  /// [cancelToken] optionally cancels the operation.
  Future<void> getClaimedCredentials({
    VaultCancelToken? cancelToken,
    int pageIndex = 0,
    bool isSharedProfile = false,
    int limit = 3,
  }) async {
    final credentialRepository = isSharedProfile
        ? await _getSharedCredentialsRepository()
        : await _getCredentialsRepository();

    // Determine the starting point for the requested page
    final validIndex =
        pageIndex > 0 && pageIndex - 1 < state.lastEvaluatedItemIdStack.length;
    final startItemId =
        validIndex ? state.lastEvaluatedItemIdStack[pageIndex - 1] : null;

    final result = await credentialRepository.listCredentials(
      limit: limit,
      cancelToken: cancelToken,
      exclusiveStartItemId: startItemId,
    );

    // Manage pagination token stack
    final updatedStack = List<String?>.from(state.lastEvaluatedItemIdStack);

    if (pageIndex >= updatedStack.length) {
      // Append new page token
      updatedStack.add(result.lastEvaluatedItemId);
    } else if (updatedStack[pageIndex] != result.lastEvaluatedItemId) {
      // Replace and truncate stack beyond this point
      updatedStack[pageIndex] = result.lastEvaluatedItemId;
      updatedStack.removeRange(pageIndex + 1, updatedStack.length);
    }

    // Update state with new data and pagination index
    state = state.copyWith(
      claimedCredentials: result.items,
      lastEvaluatedItemIdStack: updatedStack,
      currentPageIndex: pageIndex,
    );
  }

  /// Saves a new [VerifiableCredential] and refreshes the list of credentials.
  ///
  /// [verifiableCredential] the crential to be saved
  Future<void> saveCredential(
      {required VerifiableCredential verifiableCredential}) async {
    final credentialRepository = await _getCredentialsRepository();
    await credentialRepository.saveCredential(
        verifiableCredential: verifiableCredential);
    await Future.delayed(const Duration(seconds: 2)); // Allow backend to sync
    await getClaimedCredentials();
  }

  /// Deletes a [DigitalCredential] and refreshes the list.
  /// Handles edge cases like removing the last item on the last page.
  Future<void> deleteCredential({
    required DigitalCredential credential,
    VaultCancelToken? cancelToken,
  }) async {
    final credentialRepository = await _getCredentialsRepository();
    final digitalCredentialId = credential.id;

    await credentialRepository.deleteCredential(
      digitalCredentialId: digitalCredentialId,
      cancelToken: cancelToken,
    );

    final currentPageItems = state.claimedCredentials ?? [];
    final isOnlyItemOnPage = currentPageItems.length == 1;
    final isFirstPage = state.currentPageIndex == 0;

    if (isOnlyItemOnPage && !isFirstPage) {
      // If it's the only item on a non-first page, go back one page
      final updatedStack = List<String?>.from(state.lastEvaluatedItemIdStack)
        ..removeAt(state.currentPageIndex);

      final previousPage = state.currentPageIndex - 1;

      state = state.copyWith(
        lastEvaluatedItemIdStack: updatedStack,
        currentPageIndex: previousPage,
      );

      await getClaimedCredentials(pageIndex: previousPage);
    } else {
      await getClaimedCredentials(pageIndex: state.currentPageIndex);
    }
  }
}

/// Provides the [CredentialStorage] instance for a given [profileId]
/// by resolving the correct Vault profile.
final _vaultCredentialServiceProvider =
    FutureProvider.family<CredentialStorage, String>((
  ref,
  profileId,
) async {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    throw AppException(
        message: 'You must open a Vault to retrieve profiles',
        type: AppExceptionType.other);
  }

  final profiles = await vault.listProfiles();
  final defaultProfile =
      profiles.firstWhereOrNull((profile) => profile.id == profileId);
  return defaultProfile!.defaultCredentialStorage!;
}, name: 'vaultCredentialServiceProvider');

/// Placeholder class for future implementation.
class OID4VCIClaimVerifiableCredentialService {}
