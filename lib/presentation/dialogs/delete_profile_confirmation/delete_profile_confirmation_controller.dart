import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/profile/profile_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import 'delete_profile_confirmation_state.dart';

part 'delete_profile_confirmation_controller.g.dart';

@riverpod
class DeleteProfileConfirmationController extends _$DeleteProfileConfirmationController {
  DeleteProfileConfirmationController() : super();

  String? profileId;

  @override
  DeleteProfileConfirmationState build() {
    return DeleteProfileConfirmationState();
  }

  Future<void> delete() async {
    if (profileId == null) return;
    state = state.copyWith(isLoading: true, errorMessage: null, success: false);
    try {
      final profileService = ref.read(profileServiceProvider.notifier);
      await profileService.getProfiles();
      final profiles = profileService.state.profiles;
      if (profiles == null || profiles.isEmpty) {
        throw AppException(
          message: 'No profiles found',
          type: AppExceptionType.other,
        );
      }
      final profileToDelete = profiles.firstWhere(
        (p) => p.id == profileId,
        orElse: () => throw AppException(
          message: 'Profile not found',
          type: AppExceptionType.missingProfile,
        ),
      );
      log('Attempting to delete profile:  [32m${profileToDelete.name} (${profileToDelete.id}) [0m',
          name: 'DeleteProfileConfirmationController');
      await profileService.deleteProfile(profileToDelete);
      log('Profile deletion completed successfully', name: 'DeleteProfileConfirmationController');
      state = state.copyWith(isLoading: false, errorMessage: null, success: true);
    } catch (e) {
      log('Error deleting profile: $e', name: 'DeleteProfileConfirmationController');
      state = state.copyWith(isLoading: false, errorMessage: 'Profile Not Deleted', success: false);
    }
  }
}
