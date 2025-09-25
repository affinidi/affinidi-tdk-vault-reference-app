import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_credentials_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class SharedCredentialsPageState with _$SharedCredentialsPageState {
  factory SharedCredentialsPageState({
    List<DigitalCredential>? digitalCredentials,
    @Default(false) bool isLoading,
  }) = _SharedCredentialsPageState;
}
