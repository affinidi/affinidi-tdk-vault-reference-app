import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../l10n/app_localizations.dart';

class QrScannerPage extends HookConsumerWidget {
  const QrScannerPage({super.key});

  static Future<String?> scan(BuildContext context) {
    return Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScannerPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => MobileScannerController());
    final isProcessing = useState(false);

    final localizations = AppLocalizations.of(context)!;

    useEffect(() {
      return () {
        controller.dispose();
      };
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.scanVerifierQrCode),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? scannedDid = barcode.rawValue;

            if (scannedDid != null &&
                scannedDid.isNotEmpty &&
                !isProcessing.value) {
              isProcessing.value = true;
              await controller.stop();

              if (!context.mounted) return;
              Navigator.pop(context, scannedDid);
              return;
            }
          }
        },
      ),
    );
  }
}
