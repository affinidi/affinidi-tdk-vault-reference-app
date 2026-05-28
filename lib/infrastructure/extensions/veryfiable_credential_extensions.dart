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

  /// Parses this credential into a [ParsedVerifiableCredential].
  ///
  /// Tries the LD VC Data Model v1 suite first, then v2.
  /// Throws if the credential cannot be parsed by either suite.
  ParsedVerifiableCredential<dynamic> toParsedCredential() {
    if (this is ParsedVerifiableCredential<dynamic>) {
      return this as ParsedVerifiableCredential<dynamic>;
    }

    final serialized = jsonEncode(toJson());
    final v1Parsed = LdVcDm1Suite().tryParse(serialized);
    if (v1Parsed != null) return v1Parsed;

    final v2Parsed = LdVcDm2Suite().tryParse(serialized);
    if (v2Parsed != null) return v2Parsed;

    throw Exception(
      'Credential $id could not be parsed as linked-data VC data model v1 or v2.',
    );
  }
}
