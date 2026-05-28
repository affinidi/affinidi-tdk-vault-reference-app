import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:ssi/ssi.dart';

extension VerifiableCredentialExtensions on VerifiableCredential {
  String? get displayName => type.firstWhereOrNull((item) => ![
        'VerifiableCredential',
        'VerifiedIdentityDocument',
      ].contains(item));

  String? formattedIssuanceDate(String localeName) {
    final localDate = validFrom?.toLocal();
    if (localDate == null) return null;
    return DateFormat.yMMMd(localeName).format(localDate);
  }

  String? formattedExpiryDate(String localeName) {
    final localDate = validUntil?.toLocal();
    if (localDate == null) return null;
    return DateFormat.yMMMd(localeName).format(localDate);
  }
}
