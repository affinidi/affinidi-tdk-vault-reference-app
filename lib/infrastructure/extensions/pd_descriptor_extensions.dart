import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

extension PDDescriptorExtensions on PDDescriptor {
  /// Returns a human-readable label for this descriptor.
  ///
  /// Prefers [name] if non-empty, falls back to [id], then a generic fallback.
  String get label {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) return trimmedName;
    final trimmedId = id.trim();
    if (trimmedId.isNotEmpty) return trimmedId;
    return 'Credential request';
  }
}
