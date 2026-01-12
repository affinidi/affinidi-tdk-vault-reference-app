import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';

typedef AccessEntry = ({String granteeDid, ItemPermission permission});

class ManageAccessState {
  const ManageAccessState({
    required this.entries,
    required this.fetchedAt,
    this.isRefreshing = false,
  });

  final List<AccessEntry> entries;
  final DateTime fetchedAt;
  final bool isRefreshing;

  ManageAccessState copyWith({
    List<AccessEntry>? entries,
    DateTime? fetchedAt,
    bool? isRefreshing,
  }) {
    return ManageAccessState(
      entries: entries ?? this.entries,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

final manageNodeAccessProvider = StateNotifierProvider.family<
    ManageNodeAccessNotifier,
    AsyncValue<ManageAccessState>,
    ({String profileId, String nodeId})>((ref, args) {
  return ManageNodeAccessNotifier(
    ref,
    profileId: args.profileId,
    nodeId: args.nodeId,
  );
});

class ManageNodeAccessNotifier
    extends StateNotifier<AsyncValue<ManageAccessState>> {
  ManageNodeAccessNotifier(
    this.ref, {
    required this.profileId,
    required this.nodeId,
  }) : super(const AsyncValue.loading()) {
    _load(force: true, keepPrevious: false);
  }

  final Ref ref;
  final String profileId;
  final String nodeId;

  static const _cacheDuration = Duration(minutes: 3);

  Future<void> refresh({bool force = false}) =>
      _load(force: force, keepPrevious: true);

  Future<void> _load({
    required bool force,
    required bool keepPrevious,
  }) async {
    final previous = state.valueOrNull;
    final lastFetchedAt = previous?.fetchedAt;

    final isFresh = lastFetchedAt != null &&
        DateTime.now().difference(lastFetchedAt) < _cacheDuration;
    if (!force && isFresh) return;

    if (keepPrevious && previous != null) {
      state = AsyncValue.data(previous.copyWith(isRefreshing: true));
    } else {
      state = const AsyncValue.loading();
    }
    state = await AsyncValue.guard(() async {
      final entries = await _fetchAccess();
      return ManageAccessState(
        entries: entries,
        fetchedAt: DateTime.now(),
        isRefreshing: false,
      );
    });
  }

  Future<List<AccessEntry>> _fetchAccess() async {
    final vault = ref.read(vaultServiceProvider).currentVault;
    if (vault == null) {
      return [];
    }

    final vaultNotifier = ref.read(vaultServiceProvider.notifier);
    final profiles = await vault.listProfiles();
    final allAccess = <AccessEntry>[];

    for (final profile in profiles) {
      try {
        final permissions = await vaultNotifier.getItemAccess(
          profileId: profileId,
          granteeDid: profile.did,
        );

        for (final perm in permissions) {
          if (perm.itemIds.contains(nodeId)) {
            allAccess.add((granteeDid: profile.did, permission: perm));
          }
        }
      } catch (e) {
        // Skip profiles we cannot resolve instead of blocking the list.
        debugPrint('manage_access: unable to load ${profile.id}: $e');
        continue;
      }
    }

    return allAccess;
  }

  void removeFromCache(String granteeDid) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(
      current.copyWith(
        entries: current.entries
            .where((entry) => entry.granteeDid != granteeDid)
            .toList(),
        fetchedAt: DateTime.now(),
        isRefreshing: false,
      ),
    );
  }
}
