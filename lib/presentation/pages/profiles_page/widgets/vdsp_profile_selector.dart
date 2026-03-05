import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../themes/app_sizing.dart';
import '../profiles_page_controller.dart';

Future<Profile?> showProfileSelector(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  final selectedProfile = showModalBottomSheet<Profile>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Consumer(
        builder: (c, ref, _) {
          final profiles =
              ref.read(profilesPageControllerProvider).profiles ?? [];

          int? selectedIndex;

          return StatefulBuilder(
            builder: (c, setState) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSizing.paddingMedium),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: AppSizing.paddingRegular,
                              ),
                              child: RadioListTile<int>(
                                value: index,
                                groupValue: selectedIndex,
                                onChanged: (v) =>
                                    setState(() => selectedIndex = v),
                                title: Text(profile.name),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(null),
                            child: Text(localizations.cancelActionText),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedIndex != null) {
                                Navigator.of(ctx).pop(profiles[selectedIndex!]);
                              }
                            },
                            child: Text(localizations.selectActionText),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  return selectedProfile;
}
