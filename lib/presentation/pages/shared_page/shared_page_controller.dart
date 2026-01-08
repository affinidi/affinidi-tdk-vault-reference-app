import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../../application/services/sharing/granular_access_service.dart';
import 'shared_page_state.dart';

part 'shared_page_controller.g.dart';

@riverpod
class SharedPageController extends _$SharedPageController {
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

      for (final storage in sharedStorages) {
        try {
          final files =
              await ref.read(sharedStorageFilesProvider(storage.id).future);
          filesMap[storage.id] = files;
        } catch (e) {
          debugPrint('Error fetching files for ${storage.id}: $e');
          filesMap[storage.id] = [];
        }
      }

      // Load granular access items
      List<GranularAccessItem> granularAccessItems = [];
      try {
        final granularAccessService = ref.read(granularAccessServiceProvider);
        granularAccessItems = await granularAccessService.discoverSharedFiles(
          currentProfileId: selectedProfileId,
        );
      } catch (e) {
        debugPrint('Error discovering granular access items: $e');
        // Continue even if discovery fails
        granularAccessItems = [];
      }

      state = state.copyWith(
        isLoading: false,
        selectedProfileId: selectedProfileId,
        sharedStorages: sharedStorages,
        sharedFiles: filesMap,
        granularAccessItems: granularAccessItems,
      );
    } catch (e) {
      debugPrint('Error loading shared content: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
