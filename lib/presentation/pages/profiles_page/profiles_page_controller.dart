import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'profiles_page_state.dart';

part 'profiles_page_controller.g.dart';

@riverpod
class ProfilesPageController extends _$ProfilesPageController {
  ProfilesPageController() : super();

  final loadingController = AsyncLoadingController.provider('profilesPageLoadingController');

  /// Initializes the controller state.
  ///
  /// Automatically loads profiles and listens for profile updates from
  /// [profileServiceProvider].
  ///
  /// Returns the initial [ProfilesPageState].
  @override
  ProfilesPageState build() {
    _loadProfiles();

    ref.listen(
      profileServiceProvider.select((state) => state.profiles),
      (previous, next) {
        Future.microtask(() {
          state = state.copyWith(
            profiles: next,
          );
        });
      },
      fireImmediately: true,
    );

    return ProfilesPageState();
  }

  /// Triggers a refresh of profiles by calling [getProfiles] in the profile service.
  Future<void> refreshProfiles() async {
    await ref.read(profileServiceProvider.notifier).getProfiles();
  }

  /// Handles logic for closing the Profiles Page:
  /// - Resets the current vault
  /// - Navigates back to the Vaults page
  void resetCurrentVault() {
    final vaultService = ref.read(vaultServiceProvider.notifier);
    vaultService.resetCurrentVault();
  }

  /// Internal method that loads profiles with a loading indicator.
  void _loadProfiles() {
    Future.microtask(() {
      ref.read(loadingController.notifier).start(
            () async => await ref.read(profileServiceProvider.notifier).getProfiles(),
          );
    });
  }
}
