import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

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
