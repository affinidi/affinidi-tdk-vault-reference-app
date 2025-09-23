import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

Map<String, DocumentType> fileSignatures = {
  '89504E47': DocumentType.png, // PNG
  'FFD8FF': DocumentType.jpg, // JPG/JPEG
  '25504446': DocumentType.pdf, // PDF
};

enum DocumentType {
  pdf,
  png,
  jpg,
  other,
  ;

  factory DocumentType.fromData(Uint8List data) {
    final candidateSignatures = [data.fileSignature(4), data.fileSignature(3)];

    log('FileSignature: $candidateSignatures', name: 'DocumentType');

    final key = fileSignatures.keys.firstWhereOrNull((item) => candidateSignatures.contains(item));

    if (key == null || fileSignatures[key] == null) {
      return DocumentType.other;
    }

    return fileSignatures[key]!;
  }
}

extension _FileSignature on Uint8List {
  String fileSignature(int bytes) => take(bytes).map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
}
