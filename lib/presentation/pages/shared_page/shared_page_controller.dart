import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import '../../../application/services/storage/storage_service.dart';
import '../../../application/services/sharing/granular_access_service.dart';
import 'shared_page_state.dart';
part 'shared_page_controller.g.dart';

@riverpod
class SharedPageController extends _$SharedPageController {
  final Set<String> _expiredStorageIds = {};
  @override
  SharedPageState build({required String profileId}) {
    state = SharedPageState(selectedProfileId: profileId);
    Future.microtask(() => loadProfilesAndStorages(state.selectedProfileId));
    return state;
  }

  Future<void> loadProfilesAndStorages(String? profileId) async {
    state = state.copyWith(isLoading: true);
    try {
      if (state.selectedProfileId == null) return;
      final selectedProfileId = state.selectedProfileId;
      // Load profile-shared storages
      final sharedStorages =
          await ref.read(sharedStoragesProvider(selectedProfileId!).future);
      final filesMap = <String, List<dynamic>>{};
      final activeStorages = <SharedStorage>[];
      for (final storage in sharedStorages) {
        if (_expiredStorageIds.contains(storage.id)) {
          continue;
        }
        try {
          final files =
              await ref.read(sharedStorageFilesProvider(storage.id).future);
          filesMap[storage.id] = files;
          activeStorages.add(storage);
        } catch (e) {
          final msg = e.toString();
          final isExpired = msg.contains('unable_to_get_node_children') ||
              msg.contains('HTTP 403');
          debugPrint('Error fetching files for ${storage.id}: $e');
          if (isExpired) {
            _expiredStorageIds.add(storage.id);
            continue;
          }
          filesMap[storage.id] = [];
          activeStorages.add(storage);
        }
      }

      List<GranularAccessItem> granularAccessItems = [];
      try {
        final granularAccessService = ref.read(granularAccessServiceProvider);
        granularAccessItems = await granularAccessService.discoverSharedFiles(
          currentProfileId: selectedProfileId,
        );
      } catch (e) {
        debugPrint('Error discovering granular access items: $e');
        granularAccessItems = [];
      }
      state = state.copyWith(
        isLoading: false,
        selectedProfileId: selectedProfileId,
        sharedStorages: activeStorages,
        sharedFiles: filesMap,
        granularAccessItems: granularAccessItems,
      );
    } catch (e) {
      debugPrint('Error loading shared content: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
