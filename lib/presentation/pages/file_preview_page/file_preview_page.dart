import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../infrastructure/extensions/build_context_extensions.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/loading_status/async_loading_status.dart';
import '../../widgets/stub_html.dart' as platform;
import 'document_type.dart';
import 'file_preview_page_controller.dart';

class FilePreviewPage extends ConsumerWidget {
  const FilePreviewPage({
    super.key,
    required this.nodeId,
    required this.profileId,
    this.parentNodeId,
    this.isSharedProfile = false,
  });

  final String nodeId;
  final String profileId;
  final String? parentNodeId;
  final bool isSharedProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = filePreviewPageControllerProvider(
      nodeId: nodeId,
      profileId: profileId,
      parentNodeId: parentNodeId,
      isSharedProfile: isSharedProfile,
    );
    final controller = ref.read(provider.notifier);
    final state = ref.watch(provider);
    final data = state.data;
    final documentType = state.documentType;

    void onCancel() {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    void shareFile(Rect sharePositionOrigin) {
      if (!context.mounted) return;

      controller.shareFile(sharePositionOrigin: sharePositionOrigin);
    }

    return Scaffold(
        appBar: AppBar(
          leading: data != null
              ? IconButton(
                  onPressed: () => shareFile(context.sharePositionOrigin),
                  icon: SvgPicture.asset('assets/icons/icon-share.svg'))
              : SizedBox.shrink(),
          title: Text(localizations.previewTitle),
          actions: [IconButton(onPressed: onCancel, icon: SvgPicture.asset('assets/icons/icon-close.svg'))],
        ),
        body: AsyncLoadingStatus(
          controller.loadingController,
          child: Hero(
            tag: nodeId,
            child: (data != null && documentType != null)
                ? //
                _DocumentWidget(data: data, documentType: documentType)
                : //
                SizedBox.shrink(),
          ),
        ));
  }
}

class _DocumentWidget extends StatelessWidget {
  const _DocumentWidget({required this.data, required this.documentType});

  final Uint8List data;
  final DocumentType documentType;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (documentType == DocumentType.pdf) {
      if (kIsWeb) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(localizations.unsupportedPreview),
              SizedBox(height: AppSizing.paddingMedium),
              ElevatedButton(
                onPressed: () {
                  final blob = platform.Blob([data]);
                  final url = platform.Url.createObjectUrl(blob);
                  platform.window.open(url, '_blank');
                  platform.Url.revokeObjectUrl(url);
                },
                child: Text(localizations.openPDF),
              ),
            ],
          ),
        );
      }
      return SfPdfViewer.memory(
        data,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
      );
    }

    if ([DocumentType.png, DocumentType.jpg].contains(documentType)) {
      return Center(child: Image.memory(data));
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizing.paddingLarge),
        child: Text(localizations.unsupportedPreview),
      ),
    );
  }
}
