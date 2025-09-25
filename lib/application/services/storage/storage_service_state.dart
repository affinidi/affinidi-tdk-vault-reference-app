import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination_state.dart';

part 'storage_service_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class StorageServiceState with _$StorageServiceState {
  factory StorageServiceState({
    @Default([]) List<Item> items,
    @Default({})
    Map<String, PaginationState>
        paginationStates, // folderId -> PaginationState
    Uint8List? fileData,
  }) = _StorageServiceState;
}
