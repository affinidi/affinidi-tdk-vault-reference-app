import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import '../../../infrastructure/providers/consent_record_store_provider.dart';
import 'consent_history_page_state.dart';

part 'consent_history_page_controller.g.dart';

@riverpod
class ConsentHistoryPageController extends _$ConsentHistoryPageController {
  @override
  ConsentHistoryPageState build() {
    Future.microtask(_loadRecords);
    return ConsentHistoryPageState(isLoading: true);
  }

  Future<void> _loadRecords() async {
    final vault = ref.read(vaultServiceProvider).currentVault;
    final vaultId = ref.read(vaultServiceProvider).currentVaultId;
    if (vault == null || vaultId == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    try {
      final profiles = await vault.listProfiles();
      final profileIds = profiles.map((profile) => profile.id).toSet();
      final profileDidById = {
        for (final profile in profiles) profile.id: profile.did,
      };
      final store = ref.read(consentRecordStoreProvider(vaultId));
      final allRecords = await store.listAll();
      final filtered = allRecords
          .where((record) => profileIds.contains(record.profileId))
          .toList()
        ..sort(
            (recordA, recordB) => recordB.sharedAt.compareTo(recordA.sharedAt));
      state = state.copyWith(
        records: filtered,
        profileDidById: profileDidById,
        isLoading: false,
      );
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: '_loadRecords failed');
      final errorType = e is AppException
          ? e.type.name
          : e is TdkException
              ? e.code
              : AppExceptionType.other.name;
      state = state.copyWith(isLoading: false, error: errorType);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadRecords();
  }

  Future<void> setAutoShareEnabled(String hash, bool value) async {
    final records = state.records;
    final idx = records.indexWhere((record) => record.hash == hash);
    if (idx == -1) return;

    final previous = records[idx];
    final updated = previous.copyWith(isAutoShareEnabled: value);
    state = state.copyWith(records: [...records]..[idx] = updated);

    try {
      final vaultId = ref.read(vaultServiceProvider).currentVaultId;
      if (vaultId == null) return;
      await ref.read(consentRecordStoreProvider(vaultId)).saveOrUpdate(updated);
    } catch (_) {
      state = state.copyWith(records: [...state.records]..[idx] = previous);
    }
  }
}
