import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/profile/profile_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'profile_page_state.dart';

part 'profile_page_controller.g.dart';

@riverpod
class ProfilePageController extends _$ProfilePageController {
  ProfilePageController() : super();

  final loadingController =
      AsyncLoadingController.provider('profilePageLoadingController');

  @override
  ProfilePageState build({
    required String profileId,
  }) {
    ref.listen(
      profileServiceProvider.select((state) => state.profiles),
      (previous, next) {
        Future(() {
          final profile =
              next?.firstWhereOrNull((element) => element.id == profileId);

          state = state.copyWith(profile: profile);
        });
      },
      fireImmediately: true,
    );

    return ProfilePageState();
  }
}
