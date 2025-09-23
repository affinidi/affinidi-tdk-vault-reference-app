import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_vault_page_state.freezed.dart';

enum SeedMode { generate, useExisting }

@Freezed(fromJson: false, toJson: false)
class CreateVaultPageState with _$CreateVaultPageState {
  const factory CreateVaultPageState({
    @Default(SeedMode.generate) SeedMode seedMode,
    @Default(false) bool isFormValid,
  }) = _CreateVaultPageState;

  const CreateVaultPageState._();
}
