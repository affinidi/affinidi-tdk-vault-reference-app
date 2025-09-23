import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/profile/file_settings_bottom_sheet.dart';

class FilePermissionsTile extends StatelessWidget {
  const FilePermissionsTile({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(localizations.setFilePermissions, style: Theme.of(context).textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizing.paddingLarge)),
          ),
          builder: (context) => FileSettingsBottomSheet(profileId: profileId),
        );
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
