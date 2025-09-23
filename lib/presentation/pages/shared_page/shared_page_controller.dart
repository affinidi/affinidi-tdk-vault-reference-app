import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
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

      state = state.copyWith(
        isLoading: false,
        selectedProfileId: selectedProfileId,
        sharedStorages: sharedStorages,
        sharedFiles: filesMap,
      );
    } catch (e) {
      debugPrint('Error loading shared content: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
