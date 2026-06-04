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

  /// Returns the currently selected [VcAvailable] per descriptor group.
  ///
  /// Parameters:
  /// * [selectedIds] - the set of currently selected credential IDs.
  ///
  /// Falls back to the first available VC for any group where none of the
  /// [selectedIds] match.
  Map<PDDescriptor, VcAvailable> selectedVcFor(Set<String> selectedIds) {
    return {
      for (final entry in vcsGroups.entries)
        if (entry.value.allAvailableVCs.isNotEmpty)
          entry.key: entry.value.allAvailableVCs.firstWhere(
            (vcItem) => selectedIds.contains(vcItem.vc.id.toString()),
            orElse: () => entry.value.allAvailableVCs.first,
          ),
    };
  }
}
