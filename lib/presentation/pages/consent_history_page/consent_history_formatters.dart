import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:intl/intl.dart';

/// Pure display formatters for the consent history widgets.
abstract final class ConsentHistoryFormatters {
  static String formatDisplayText(String? value, String notAvailable) {
    if (value == null) return notAvailable;

    final trimmed = value.trim();
    if (trimmed.isEmpty) return notAvailable;

    return trimmed;
  }

  static String formatDataShared(
    IotaConsentRecord record,
    String notAvailable,
  ) {
    final types = record.claimedVcTypesCsv
        .split(',')
        .map((type) => type.trim())
        .where((type) => type.isNotEmpty)
        .toList();
    if (types.isEmpty) return notAvailable;
    return types.join(', ');
  }

  static String formatProfileDid(
    IotaConsentRecord record,
    Map<String, String> profileDidById,
    String notAvailable,
  ) {
    final did = profileDidById[record.profileId]?.trim();
    if (did == null || did.isEmpty) return notAvailable;
    return did;
  }

  static String formatDate(String isoDate, String notAvailable) {
    if (isoDate.isEmpty) return notAvailable;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('MMM d, yyyy HH:mm').format(dt);
    } catch (_) {
      return notAvailable;
    }
  }
}
