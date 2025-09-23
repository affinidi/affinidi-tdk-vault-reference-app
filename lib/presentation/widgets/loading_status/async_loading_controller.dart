import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Use this controller to execute a future and check its statuses like loading, error and completion.
///
/// Use it together with [AsyncLoadingStatus] to display a loading message as well as any error messages.
///
/// See also:
///
/// * [AsyncLoadingStatus] which is used to give visual feedback
class AsyncLoadingController extends AutoDisposeNotifier<AsyncValue<void>> {
  AsyncLoadingController() : super();

  static AutoDisposeNotifierProvider<AsyncLoadingController,
      AsyncValue<dynamic>> provider(
          String name) =>
      NotifierProvider.autoDispose<AsyncLoadingController, AsyncValue>(
        AsyncLoadingController.new,
        name: name,
      );

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> start(Future<void> Function() load) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => load());
    state = result;

    return result.when(
      data: (_) => null,
      error: (e, st) => throw e,
      loading: () {},
    );
  }
}
