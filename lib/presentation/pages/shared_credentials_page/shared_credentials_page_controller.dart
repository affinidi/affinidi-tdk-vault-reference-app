import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/credential/credential_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

import 'shared_credentials_page_state.dart';

part 'shared_credentials_page_controller.g.dart';

@riverpod
class SharedCredentialsPageController extends _$SharedCredentialsPageController {
  SharedCredentialsPageController() : super();

  /// Provides access to a loading controller used for async status indication
  final loadingController = AsyncLoadingController.provider('sharedCredentialsPageLoadingController');

  /// Initializes the state and triggers the initial fetch of claimed credentials.
  /// Also listens to credential state changes from the credential service and updates UI state accordingly.
  @override
  SharedCredentialsPageState build({required String profileId}) {
    final provider = credentialServiceProvider(
      profileId: profileId,
    );

    Future(() {
      ref.read(loadingController.notifier).start(
            () async => await ref.read(provider.notifier).getClaimedCredentials(
                  isSharedProfile: true,
                ),
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

    return SharedCredentialsPageState();
  }

  /// Refreshes the list of claimed credentials by re-fetching from the credential service.
  Future<void> refreshCredentials() async {
    final provider = credentialServiceProvider(profileId: profileId);
    await ref.read(provider.notifier).getClaimedCredentials();
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
