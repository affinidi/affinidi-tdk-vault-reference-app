import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/vault/vault_service.dart';
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
    if (vault == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    try {
      final profiles = await vault.listProfiles();
      final profileIds = profiles.map((profile) => profile.id).toSet();
      final store = ref.read(consentRecordStoreProvider);
      final allRecords = await store.listAll();
      final filtered = allRecords
          .where((record) => profileIds.contains(record.profileId))
          .toList()
        ..sort((recordA, recordB) => recordB.sharedAt.compareTo(recordA.sharedAt));
      state = state.copyWith(records: filtered, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
      await ref.read(consentRecordStoreProvider).saveOrUpdate(updated);
    } catch (_) {
      state = state.copyWith(records: [...state.records]..[idx] = previous);
    }
  }

  static String formatDisplayText(String? value, String notAvailable) {
    if (value == null || value.trim().isEmpty) return notAvailable;
    return value.trim();
  }

  static String formatDataShared(
    IotaConsentRecord record,
    String notAvailable,
  ) {
    final data = record.historySharedData;
    if (data.isEmpty) return notAvailable;

    final values = data.entries
        .map((entry) {
          final key = entry.key.trim();
          final value = entry.value.trim();
          if (key.isEmpty && value.isEmpty) return '';
          if (key.isEmpty) return value;
          if (value.isEmpty) return key;
          return '$key: $value';
        })
        .where((entry) => entry.isNotEmpty)
        .toList();

    if (values.isEmpty) return notAvailable;
    return values.join('\n');
  }

  static String formatDid(IotaConsentRecord record, String notAvailable) {
    final data = record.historySharedData;
    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value.trim();
      if (key.contains('did') && value.isNotEmpty) return value;
      if (value.startsWith('did:')) return value;
    }
    return notAvailable;
  }

  static String formatDate(String isoDate, String notAvailable) {
    if (isoDate.isEmpty) return notAvailable;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('MMM d, yyyy HH:mm').format(dt);
    } catch (_) {
      return notAvailable;
    }
  }
}

