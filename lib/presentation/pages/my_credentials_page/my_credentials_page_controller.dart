import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/credential/credential_service.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

import 'my_credentials_page_state.dart';

part 'my_credentials_page_controller.g.dart';

@riverpod
class MyCredentialsPageController extends _$MyCredentialsPageController {
  MyCredentialsPageController() : super();

  /// Provides access to a loading controller used for async status indication
  final loadingController = AsyncLoadingController.provider('myCredentialsPageLoadingController');

  /// Initializes the state and triggers the initial fetch of claimed credentials.
  /// Also listens to credential state changes from the credential service and updates UI state accordingly.
  @override
  MyCredentialsPageState build({required String profileId}) {
    final provider = credentialServiceProvider(profileId: profileId);

    Future(() {
      ref.read(loadingController.notifier).start(
            () async => await ref.read(provider.notifier).getClaimedCredentials(),
          );
    });

    // Listen for updates to claimed credentials and update local state
    ref.listen(
      provider.select((state) => state.claimedCredentials),
      (previous, next) {
        Future(() {
          state = state.copyWith(digitalCredentials: next);
        });
      },
      fireImmediately: true,
    );

    return MyCredentialsPageState();
  }

  /// Refreshes the list of claimed credentials by re-fetching from the credential service.
  Future<void> refreshCredentials() async {
    final provider = credentialServiceProvider(profileId: profileId);
    await ref.read(provider.notifier).getClaimedCredentials();
  }

  /// Navigates to the file preview page for a given profile and node ID.
  ///
  /// [profileId]: The ID of the profile.
  /// [nodeId]: The ID of the digital credential or node to preview.
  void previewFile(String profileId, String nodeId) {
    final navigation = ref.read(navigationServiceProvider);
    navigation.goNamed(
      ProfilesRoutePath.profileFilePreview(
        profileId,
        nodeId,
      ),
    );
  }

  /// Navigates to the next page of paginated claimed credentials.
  Future<void> goToNextPage() async {
    final provider = credentialServiceProvider(profileId: profileId);
    final providerState = ref.read(provider);
    final service = ref.read(provider.notifier);

    final nextPage = providerState.currentPageIndex + 1;
    state = state.copyWith(isLoading: true);
    await service.getClaimedCredentials(pageIndex: nextPage);
    state = state.copyWith(isLoading: false);
  }

  /// Navigates to the previous page of paginated claimed credentials.
  Future<void> goToPreviousPage() async {
    final provider = credentialServiceProvider(profileId: profileId);
    final providerState = ref.read(provider);
    final service = ref.read(provider.notifier);

    final prevPage = providerState.currentPageIndex - 1;
    state = state.copyWith(isLoading: true);
    await service.getClaimedCredentials(pageIndex: prevPage);
    state = state.copyWith(isLoading: false);
  }
}
