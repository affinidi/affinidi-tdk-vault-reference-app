import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:ssi/ssi.dart';

extension MatchedCredentialsResultExtension on MatchedCredentialsResult {
  /// Returns the VCs required to satisfy the request — taking only
  /// [MatchedCredentialGroup.minimumVCsCountToShare] from each group.
  List<VerifiableCredential> get requiredMatchedVcs {
    final result = <VerifiableCredential>[];
    for (final group in groups) {
      result.addAll(
        group.availableCredentials.take(group.minimumVCsCountToShare),
      );
    }
    return List.unmodifiable(result);
  }
}

extension MatchedCredentialGroupExtension on MatchedCredentialGroup {
  /// Returns a human-readable label for this credential group.
  ///
  /// Falls back to [id] when set, then a generic label.
  String get label {
    final trimmedId = id.trim();
    if (trimmedId.isNotEmpty) return trimmedId;
    return 'Credential request';
  }
}
