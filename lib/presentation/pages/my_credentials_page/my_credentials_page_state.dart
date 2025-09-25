import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_credentials_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class MyCredentialsPageState with _$MyCredentialsPageState {
  factory MyCredentialsPageState({
    List<DigitalCredential>? digitalCredentials,
    @Default(false) bool isLoading,
  }) = _MyCredentialsPageState;
}
