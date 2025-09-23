import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../dialogs/delete_profile_confirmation/delete_profile_confirmation.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/tdk_app_bar.dart';

import 'profile_settings_page_controller.dart';
import '../../widgets/profile/file_settings_bottom_sheet.dart';
import 'access_management_page.dart';

class ProfileSettingsPage extends HookConsumerWidget {
  const ProfileSettingsPage({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final controllerProvider = profileSettingsPageControllerProvider(profileId);
    ref.watch(controllerProvider.notifier);
    final settingsState = ref.watch(controllerProvider);
    final navigation = ref.read(navigationServiceProvider);

    useState(false);

    Future<void> onDeleteProfile() async {
      final confirmed = await DeleteProfileConfirmation.show(
        context: context,
        profileName: settingsState.profile!.name,
        profileId: profileId,
      );

      if (confirmed && context.mounted) {
        navigation.go(ProfilesRoutePath.base);
      }
    }

    if (settingsState.profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizing.paddingSmall,
              right: AppSizing.paddingLarge,
              top: AppSizing.paddingSmall,
              bottom: AppSizing.paddingRegular,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: AppSizing.paddingMedium, top: AppSizing.paddingLarge),
                  child: Text(
                    localizations.profileSettingsTitle,
                    style: AppTheme.headingMedium,
                  ),
                ),
                const SizedBox(height: AppSizing.paddingMedium),
                const Divider(
                  height: 1,
                  color: AppColorScheme.divider,
                ),
              ],
            ),
          ),
          // Settings options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingMedium),
              children: [
                // Edit Profile Section
                _SettingsTile(
                  icon: Icons.person,
                  title: localizations.editProfile,
                  onTap: () {
                    _showEditProfileDialog(context, ref, settingsState.profile!);
                  },
                ),
                const SizedBox(height: AppSizing.paddingSmall),

                // Set File Permissions Section
                _SettingsTile(
                  icon: Icons.folder,
                  title: localizations.setFilePermissions,
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
                ),
                const SizedBox(height: AppSizing.paddingSmall),

                // Access Management Section
                _SettingsTile(
                  icon: Icons.people,
                  title: localizations.accessManagementLabel,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AccessManagementPage(profileId: profileId),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSizing.paddingLarge),

                // Delete Profile Section
                _SettingsTile(
                  key: Key(KeyConstants.keyDeleteProfiletButton),
                  icon: Icons.delete,
                  title: localizations.deleteProfileTitle,
                  titleColor: AppColorScheme.error,
                  iconColor: AppColorScheme.error,
                  onTap: onDeleteProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, dynamic profile) {
    final nameController = TextEditingController(text: profile.name);
    final descriptionController = TextEditingController(text: profile.description);
    final localizations = AppLocalizations.of(context)!;
    final controllerProvider = profileSettingsPageControllerProvider(profileId);
    final controller = ref.read(controllerProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          localizations.editProfile,
          style: AppTheme.headingMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '${localizations.profileName}*',
                labelStyle: Theme.of(context).textTheme.labelLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderUnfocused),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderFocused),
                ),
              ),
            ),
            const SizedBox(height: AppSizing.paddingMedium),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: localizations.profileDescription,
                labelStyle: Theme.of(context).textTheme.labelLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderUnfocused),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderFocused),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              localizations.cancelActionText,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final description = descriptionController.text;
              controller.updateProfile(
                name: name,
                description: description,
                onSuccess: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.profileUpdateSuccess),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onError: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.profileUpdateFailure),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colorScheme.primary,
              foregroundColor: AppColorScheme.backgroundWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizing.paddingXXLarge),
              ),
            ),
            child: Text(
              localizations.saveActionText,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColorScheme.backgroundWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColorScheme.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
        side: BorderSide(color: AppColorScheme.divider),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? AppColorScheme.textPrimary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSizing.iconXSmall,
          color: AppColorScheme.iconInfo,
        ),
        onTap: onTap,
      ),
    );
  }
}
