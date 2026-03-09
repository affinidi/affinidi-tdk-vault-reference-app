import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: content,
      version: QrVersions.auto,
      size: 300,
      gapless: false,
      backgroundColor: const Color.fromARGB(255, 193, 185, 185),
    );
  }
}
