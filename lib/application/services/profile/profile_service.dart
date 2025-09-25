import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_edge_provider/affinidi_tdk_vault_edge_provider.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../domain/models/profile/profile_type.dart';
import '../vault/vault_service.dart';
import 'profile_service_state.dart';

part 'profile_service.g.dart';

/// Service responsible for managing profiles within a vault.
///
/// This service provides functionality to:
/// - Retrieve profiles from the vault
/// - Create new profiles with different storage types (VFS/Edge)
/// - Delete profiles and their associated data
/// - Update profile information
///
/// The service supports both cloud-based (VFS) and local (Edge) profile storage.
/// Each profile type has its own repository and storage mechanism.
@riverpod
class ProfileService extends _$ProfileService {
  ProfileService() : super();

  @override
  ProfileServiceState build() {
    log('ProfileService build() called', name: 'ProfileService');
    return ProfileServiceState();
  }

  /// Retrieves all profiles from the current vault.
  ///
  /// Throws [AppException] if no vault is currently open.
  Future<void> getProfiles() async {
    final vault = _getCurrentVault();
    final profiles = await vault.listProfiles();
    state = state.copyWith(profiles: profiles);
  }

  /// Creates a new profile in the vault.
  ///
  /// [name] - The name of the profile (must be unique)
  /// [description] - A description of the profile
  /// [profileType] - The type of profile to create (defaults to cloud-based)
  ///
  /// Throws [AppException] if:
  /// - No vault is currently open
  /// - A profile with the same name already exists
  /// - The repository for the specified profile type is not found
  /// - The maximum number of profiles has been reached
  Future<void> createProfile({
    required String name,
    required String description,
    ProfileType profileType = ProfileType.affinidiCloud,
  }) async {
    try {
      final vault = _getCurrentVault();
      log('Vault retrieved successfully', name: 'ProfileService');

      final vaultId = _getCurrentVaultId();
      log('Vault ID: $vaultId', name: 'ProfileService');

      await _validateProfileCreation(vault, name, profileType);

      final repositoryId =
          '${_getCurrentVaultId()}_${profileType.value}_repository';
      final profileRepository = await _getProfileRepository(
          vault, repositoryId, profileType,
          profileName: name);

      try {
        await profileRepository.createProfile(
          name: name,
          description: description,
        );
      } catch (e) {
        rethrow;
      }
      log('Profile created successfully in repository', name: 'ProfileService');

      await getProfiles();
    } on TdkException catch (e) {
      log('TDK Exception during profile creation: ${e.message}',
          name: 'ProfileService');
      log('TDK Exception code: ${e.code}', name: 'ProfileService');
      _handleTdkException(e);
    } catch (e, stackTrace) {
      log('Unexpected error during profile creation: $e',
          name: 'ProfileService');
      log('Stack trace: $stackTrace', name: 'ProfileService');
      throw AppException(
        message: 'Failed to create profile: ${e.toString()}',
        type: AppExceptionType.other,
      );
    }
  }

  /// Deletes a profile if it is empty.
  ///
  /// This operation will only delete the profile if it contains no files, folders, or credentials.
  /// If the profile contains data, an exception will be thrown.
  ///
  /// [profile] - The profile to delete
  ///
  /// Throws [AppException] if:
  /// - The profile contains data and cannot be deleted
  /// - The profile cannot be deleted for other reasons
  Future<void> deleteProfile(Profile profile) async {
    final vault = _getCurrentVault();

    log('Checking if profile is empty before deletion: ${profile.name}',
        name: 'ProfileService');

    try {
      await _validateProfileIsEmpty(profile);
      await _deleteProfileFromRepository(vault, profile);
      await getProfiles();

      log('Profile deletion completed successfully', name: 'ProfileService');
    } catch (e, stackTrace) {
      log('Error deleting profile: $e', name: 'ProfileService');
      log('Stack trace: $stackTrace', name: 'ProfileService');
      throw AppException(
        message: 'Failed to delete profile: ${e.toString()}',
        type: AppExceptionType.other,
      );
    }
  }

  /// Checks if a profile is empty (contains no files, folders, or credentials).
  ///
  /// [profile] - The profile to check
  ///
  /// Updates the state with the empty status of the profile.
  Future<void> checkProfileEmptyStatus(Profile profile) async {
    try {
      // Check for files and folders
      final folderItems = await _getFolderItems(profile, profile.id);
      if (folderItems.isNotEmpty) {
        _updateProfileEmptyStatus(profile.id, false);
        return;
      }

      // Check for credentials
      final credentials = await _getCredentials(profile);
      final isEmpty = credentials.isEmpty;
      _updateProfileEmptyStatus(profile.id, isEmpty);
    } catch (e) {
      log('Error checking if profile is empty: $e', name: 'ProfileService');
      // Assume not empty if we can't check
      _updateProfileEmptyStatus(profile.id, false);
    }
  }

  /// Gets the empty status of a profile from state.
  ///
  /// [profileId] - The ID of the profile to check
  ///
  /// Returns true if the profile is empty, false otherwise.
  /// Returns null if the status hasn't been checked yet.
  bool? getProfileEmptyStatus(String profileId) {
    return state.profileEmptyStatus[profileId];
  }

  /// Updates a profile's name and description.
  ///
  /// [profile] - The profile to update (must not be null)
  /// [name] - The new name for the profile
  /// [description] - The new description for the profile
  /// [cancelToken] - Optional cancellation token for the operation
  ///
  /// Throws [AppException] if the profile cannot be updated.
  Future<void> updateProfile({
    required Profile? profile,
    required String name,
    required String description,
    VaultCancelToken? cancelToken,
  }) async {
    final vault = _getCurrentVault();

    if (profile == null) {
      throw AppException(
        message: 'Profile does not exist or was deleted',
        type: AppExceptionType.missingProfile,
      );
    }

    log('Starting profile update for: ${profile.name}', name: 'ProfileService');

    try {
      final profileRepository = vault.profileRepositories.entries
          .firstWhere(
            (repository) => repository.value.id == profile.profileRepositoryId,
          )
          .value;
      profile.name = name;
      profile.description = description;

      await profileRepository.updateProfile(
        profile,
        cancelToken: cancelToken,
      );

      log('Profile update completed successfully', name: 'ProfileService');
    } catch (e, stackTrace) {
      log('Error updating profile: $e', name: 'ProfileService');
      log('Stack trace: $stackTrace', name: 'ProfileService');
      throw AppException(
        message: 'Failed to update profile: ${e.toString()}',
        type: AppExceptionType.updateProfileFailure,
      );
    }
  }

  // Private helper methods

  /// Gets the current vault, throwing an exception if none is open.
  Vault _getCurrentVault() {
    log('Getting current vault...', name: 'ProfileService');
    final vaultServiceState = ref.read(vaultServiceProvider);
    log('Vault service state retrieved', name: 'ProfileService');
    final vault = vaultServiceState.currentVault;

    if (vault == null) {
      log('No vault found, throwing exception', name: 'ProfileService');
      throw AppException(
        message: 'You must open a Vault to perform this operation',
        type: AppExceptionType.other,
      );
    }

    log('Vault retrieved successfully', name: 'ProfileService');
    return vault;
  }

  /// Gets the current vault ID, throwing an exception if none is open.
  String _getCurrentVaultId() {
    log('Getting current vault ID...', name: 'ProfileService');
    final vaultServiceState = ref.read(vaultServiceProvider);
    log('Vault service state retrieved for ID', name: 'ProfileService');
    final vaultId = vaultServiceState.currentVaultId;

    if (vaultId == null) {
      log('No vault ID found, throwing exception', name: 'ProfileService');
      throw AppException(
        message: 'No vault ID found',
        type: AppExceptionType.other,
      );
    }

    log('Vault ID retrieved: $vaultId', name: 'ProfileService');
    return vaultId;
  }

  /// Validates that a profile can be created with the given parameters.
  Future<void> _validateProfileCreation(
      Vault vault, String name, ProfileType profileType) async {
    await vault.ensureInitialized();

    // Check if profile with same name already exists
    final existingProfiles = await vault.listProfiles();
    final existingProfile =
        existingProfiles.where((p) => p.name == name).toList();

    if (existingProfile.isNotEmpty) {
      throw AppException(
        message: 'Profile with name "$name" already exists',
        type: AppExceptionType.other,
      );
    }
  }

  /// Gets the profile repository for the specified repository ID and profile type.
  Future<ProfileRepository> _getProfileRepository(
      Vault vault, String repositoryId, ProfileType profileType,
      {String? profileName}) async {
    await vault.ensureInitialized();

    final profileRepository = vault.profileRepositories[repositoryId];

    if (profileRepository != null) {
      return profileRepository;
    }

    throw AppException(
      message:
          'Repository not found for profile type: ${profileType.displayName}',
      type: AppExceptionType.other,
    );
  }

  /// Handles TDK-specific exceptions and converts them to appropriate AppExceptions.
  void _handleTdkException(TdkException e) {
    if (e.code == 'unable_to_create_node' &&
        e.message.contains('Too many profiles') == true) {
      throw AppException(
        message:
            'You have reached the maximum number of profiles allowed. Please delete an existing profile before creating a new one.',
        type: AppExceptionType.other,
      );
    } else {
      throw AppException(
        message: 'Failed to create profile: ${e.message}',
        type: AppExceptionType.other,
      );
    }
  }

  /// Validates that a profile is empty before allowing deletion.
  ///
  /// Checks for files, folders, and credentials in the profile.
  /// Throws an exception if any data is found.
  Future<void> _validateProfileIsEmpty(Profile profile) async {
    // Check for files and folders
    final folderItems = await _getFolderItems(profile, profile.id);
    if (folderItems.isNotEmpty) {
      throw AppException(
        message:
            'Cannot delete profile "${profile.name}" - it contains ${folderItems.length} items. Please remove all files and folders before deleting the profile.',
        type: AppExceptionType.other,
      );
    }

    // Check for credentials
    final credentials = await _getCredentials(profile);
    if (credentials.isNotEmpty) {
      throw AppException(
        message:
            'Cannot delete profile "${profile.name}" - it contains ${credentials.length} credentials. Please remove all credentials before deleting the profile.',
        type: AppExceptionType.other,
      );
    }

    log('Profile "${profile.name}" is empty and can be deleted',
        name: 'ProfileService');
  }

  /// Deletes the profile from its repository.
  Future<void> _deleteProfileFromRepository(
      Vault vault, Profile profile) async {
    final profileRepository =
        vault.profileRepositories[profile.profileRepositoryId];

    if (profileRepository == null) {
      throw AppException(
        message:
            'Profile repository not found for repository ID: ${profile.profileRepositoryId}',
        type: AppExceptionType.other,
      );
    }

    log('Deleting profile from repository: ${profile.profileRepositoryId}',
        name: 'ProfileService');
    await profileRepository.deleteProfile(profile);
    log('Profile deleted successfully', name: 'ProfileService');
  }

  /// Retrieves all items in a folder.
  Future<List<Item>> _getFolderItems(Profile profile, String folderId) async {
    final items =
        await profile.defaultFileStorage?.getFolder(folderId: folderId);
    return items?.items ?? [];
  }

  /// Retrieves all credentials for a profile.
  Future<List<DigitalCredential>> _getCredentials(Profile profile) async {
    final credentials =
        await profile.defaultCredentialStorage?.listCredentials();
    return credentials?.items ?? [];
  }

  /// Updates the empty status of a profile in the state.
  void _updateProfileEmptyStatus(String profileId, bool isEmpty) {
    final updatedStatus = Map<String, bool>.from(state.profileEmptyStatus);
    updatedStatus[profileId] = isEmpty;
    state = state.copyWith(profileEmptyStatus: updatedStatus);
  }
}

/// Provider that returns the profile type for a given profile ID.
@riverpod
ProfileType profileType(Ref ref, String profileId) {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    return ProfileType.affinidiCloud;
  }

  final repo = vault.profileRepositories[profileId];

  if (repo is EdgeProfileRepository) {
    return ProfileType.edge;
  }
  return ProfileType.affinidiCloud;
}
