import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:ssi/ssi.dart';

extension ClaimedCredentialsResultExtension on ClaimedCredentialsResult {
  /// Returns the VCs required to satisfy the presentation definition —
  /// taking only [VCsGroupByType.minimumVCsCountToShare] from each group.
  List<VerifiableCredential> get requiredMatchedVcs {
    final result = <VerifiableCredential>[];
    for (final group in vcsGroups.values) {
      final requiredCount = group.minimumVCsCountToShare;
      result.addAll(
        group.allAvailableVCs.take(requiredCount).map((item) => item.vc),
      );
    }
    return List.unmodifiable(result);
  }
}
