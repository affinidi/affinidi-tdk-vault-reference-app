import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_type.dart';

part 'file_preview_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class FilePreviewPageState with _$FilePreviewPageState {
  factory FilePreviewPageState({
    Uint8List? data,
    DocumentType? documentType,
  }) = _FilePreviewPageState;
}
