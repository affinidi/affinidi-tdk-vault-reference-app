import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_history_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ConsentHistoryPageState with _$ConsentHistoryPageState {
  factory ConsentHistoryPageState({
    @Default([]) List<IotaConsentRecord> records,
    @Default(false) bool isLoading,
    String? error,
  }) = _ConsentHistoryPageState;
}
