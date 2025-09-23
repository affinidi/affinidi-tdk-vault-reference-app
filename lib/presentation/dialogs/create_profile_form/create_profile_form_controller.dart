import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/profile/profile_type.dart';
import '../../../application/services/profile/profile_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'create_profile_form_state.dart';

part 'create_profile_form_controller.g.dart';

@riverpod
class CreateProfileFormController extends _$CreateProfileFormController {
  CreateProfileFormController() : super();

  final profileNameController = TextEditingController();
  final profileDescriptionController = TextEditingController();
  final loadingController = AsyncLoadingController.provider('createProfileFormLoadingController');

  @override
  CreateProfileFormState build() {
    void profileNameListener() {
      Future(() {
        state = state.copyWith(hasName: profileNameController.text.trim().isNotEmpty);
      });
    }

    profileNameController.addListener(profileNameListener);

    void profileDescriptionListener() {
      Future(() {
        state = state.copyWith(hasDescription: profileDescriptionController.text.trim().isNotEmpty);
      });
    }

    profileDescriptionController.addListener(profileDescriptionListener);

    ref.onDispose(() {
      profileNameController.removeListener(profileNameListener);
      profileNameController.dispose();

      profileDescriptionController.removeListener(profileDescriptionListener);
      profileDescriptionController.dispose();
    });

    return CreateProfileFormState();
  }

  Future<void> create({required void Function() onSuccess}) async {
    if (profileNameController.text.trim().isEmpty) {
      Error.throwWithStackTrace(
          AppException(message: 'Profile name is mandatory', type: AppExceptionType.missingProfileName),
          StackTrace.current);
    }

    await ref.read(loadingController.notifier).start(() async {
      final profileService = ref.read(profileServiceProvider.notifier);

      await profileService.createProfile(
        name: profileNameController.text.trim(),
        description: profileDescriptionController.text.trim(),
        profileType: state.selectedProfileType,
      );
      onSuccess.call();
    });
  }

  void setProfileType(ProfileType profileType) {
    state = state.copyWith(selectedProfileType: profileType);
  }

  void clearName() {
    profileNameController.clear();
  }

  void clearDescription() {
    profileDescriptionController.clear();
  }
}
