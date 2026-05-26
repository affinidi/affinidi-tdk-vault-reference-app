import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'share_credential_page_state.dart';

part 'share_credential_page_controller.g.dart';

@riverpod
class ShareCredentialPageController extends _$ShareCredentialPageController {
  @override
  ShareCredentialPageState build({
    required String requestJwt,
    String? clientId,
  }) {
    return ShareCredentialPageState(
      requestJwt: requestJwt,
      clientId: clientId,
    );
  }
}
