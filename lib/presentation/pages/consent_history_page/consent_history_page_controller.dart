import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/providers/consent_record_store_provider.dart';
import 'consent_history_page_state.dart';

part 'consent_history_page_controller.g.dart';

@riverpod
class ConsentHistoryPageController extends _$ConsentHistoryPageController {
  @override
  ConsentHistoryPageState build() {
    Future(_loadRecords);
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
      final profileIds = profiles.map((p) => p.id).toSet();
      final store = ref.read(consentRecordStoreProvider);
      final allRecords = await store.listAll();
      final filtered = allRecords
          .where((r) => profileIds.contains(r.profileId))
          .toList()
        ..sort((a, b) => b.sharedAt.compareTo(a.sharedAt));
      state = state.copyWith(records: filtered, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadRecords();
  }
}

