import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:intl/intl.dart';

extension NodeDates on Item {
  String formattedCreateDate(String localeName) {
    final createdAtDate = createdAt.toLocal();
    return [
      DateFormat.yMMMd(localeName).format(createdAtDate),
      DateFormat.Hms(localeName).format(createdAtDate)
    ].join(' ');
  }
}
