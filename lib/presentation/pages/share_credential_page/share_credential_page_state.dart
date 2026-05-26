import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_credential_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ShareCredentialPageState with _$ShareCredentialPageState {
  factory ShareCredentialPageState({
    required String requestJwt,
    String? clientId,
  }) = _ShareCredentialPageState;
}
