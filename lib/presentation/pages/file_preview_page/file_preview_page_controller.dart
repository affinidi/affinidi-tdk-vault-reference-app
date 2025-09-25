import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'document_type.dart';
import 'file_preview_page_state.dart';

part 'file_preview_page_controller.g.dart';

@riverpod
class FilePreviewPageController extends _$FilePreviewPageController {
  FilePreviewPageController() : super();

  final loadingController =
      AsyncLoadingController.provider('filePreviewPageController');

  @override
  FilePreviewPageState build(
      {required String nodeId,
      required String profileId,
      String? parentNodeId,
      bool isSharedProfile = false}) {
    final provider = storageServiceProvider(
        parentNodeId: parentNodeId, profileId: profileId);
    Future(() {
      ref.read(loadingController.notifier).start(() async {
        await ref.read(provider.notifier).getFileContent(
              fileId: nodeId,
              isSharedProfile: isSharedProfile,
            );
      });
    });

    ref.listen(
      provider.select((state) => state.fileData),
      (previous, next) {
        Future(() {
          if (next != null) {
            state = state.copyWith(
                data: next, documentType: DocumentType.fromData(next));
          } else {
            state = state.copyWith(data: null, documentType: null);
          }
        });
      },
      fireImmediately: true,
    );

    return FilePreviewPageState();
  }

  Future<void> shareFile({Rect? sharePositionOrigin}) async {
    final fileData = state.data;

    if (fileData == null) {
      Error.throwWithStackTrace(
          'A file must be selected to be shared', StackTrace.current);
    }

    final documentType = DocumentType.fromData(fileData);
    final fileName = 'file.${documentType.name}';

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(fileData);

    await Share.shareXFiles(
      [XFile(tempFile.path)],
      subject: fileName,
      sharePositionOrigin: sharePositionOrigin,
    );

    await tempFile.delete();
  }
}
