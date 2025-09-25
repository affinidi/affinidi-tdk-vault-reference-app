import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'credential_service_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class CredentialServiceState with _$CredentialServiceState {
  factory CredentialServiceState({
    List<DigitalCredential>? claimedCredentials,
    @Default([]) List<String?> lastEvaluatedItemIdStack, // for pagination
    @Default(0) int currentPageIndex,
  }) = _CredentialServiceState;
}
