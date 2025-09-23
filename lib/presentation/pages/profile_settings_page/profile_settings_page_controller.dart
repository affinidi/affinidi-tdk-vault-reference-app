import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/sharing/shared_profile_access_service.dart';
import '../../../infrastructure/db/app_database.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import 'profile_settings_page_state.dart';

part 'profile_settings_page_controller.g.dart';

enum ProfileSettingsActionStatus { none, revokeSuccess, revokeFailure }

@riverpod
Stream<List<SharedProfileAccessData>> sharedProfileAccesses(
  Ref ref,
  String profileId,
) {
  final service = ref.watch(sharedProfileAccessServiceProvider);
  return service.watchSharedAccessesForProfile(profileId);
}

@riverpod
class ProfileSettingsPageController extends _$ProfileSettingsPageController {
  ProfileSettingsActionStatus _lastActionStatus =
      ProfileSettingsActionStatus.none;
  ProfileSettingsActionStatus get lastActionStatus => _lastActionStatus;

  @override
  ProfileSettingsPageState build(String profileId) {
    final profiles = ref.read(profileServiceProvider).profiles;
    final matched = profiles?.firstWhereOrNull((p) => p.id == profileId);

    return ProfileSettingsPageState(profile: matched);
  }

  Future<void> updateProfile({
    required String name,
    required String description,
    void Function()? onSuccess,
    void Function()? onError,
  }) async {
    state = state.copyWith(isSaving: true);

    try {
      final profileService = ref.read(profileServiceProvider.notifier);
      profileService.updateProfile(
        profile: state.profile,
        name: name,
        description: description,
      );
      onSuccess?.call();
    } catch (e) {
      if (onError != null) {
        onError.call();
      }
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  void goToProfileSharing() {
    final navigation = ref.read(navigationServiceProvider);
    navigation.push(ProfilesRoutePath.profileSharingTest);
  }

  Future<void> revokeAccess({
    required int entryId,
    required String profileId,
    required String receiverDid,
  }) async {
    // Add entryId to revoking set
    state = state.copyWith(revokingIds: {...state.revokingIds, entryId});

    final vaultService = ref.read(vaultServiceProvider.notifier);
    final sharedAccessService = ref.read(sharedProfileAccessServiceProvider);
    try {
      await vaultService.revokeProfileAccess(
          profileId: profileId, granteeDid: receiverDid);
      await sharedAccessService.removeSharedAccess(entryId);
      _lastActionStatus = ProfileSettingsActionStatus.revokeSuccess;
    } catch (e) {
      _lastActionStatus = ProfileSettingsActionStatus.revokeFailure;
    } finally {
      state =
          state.copyWith(revokingIds: state.revokingIds.difference({entryId}));
    }
  }
}
