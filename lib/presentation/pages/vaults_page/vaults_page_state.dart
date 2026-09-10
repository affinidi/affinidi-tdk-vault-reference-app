import 'package:freezed_annotation/freezed_annotation.dart';

part 'vaults_page_state.freezed.dart';

@freezed
class VaultsPageState with _$VaultsPageState {
  const factory VaultsPageState({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _VaultsPageState;
}
