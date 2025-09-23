import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/messaging/message_service.dart';
import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/sharing/shared_profile_access_service.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../domain/models/profile/profile_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../pages/profile_sharing_page/profile_sharing_page_controller.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../widgets/simple_info_widget.dart';

import 'did_display.dart';

class ProfileAppBar extends ConsumerWidget {
  const ProfileAppBar({
    super.key,
    required this.profileName,
    this.profileDescription = '',
    required this.profileId,
    this.profileDid = '',
  });

  final String profileId;
  final String profileName;
  final String profileDescription;
  final String profileDid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final profileType = ref.watch(profileTypeProvider(profileId));
    final navigation = ref.read(navigationServiceProvider);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizing.paddingSmall,
              right: AppSizing.paddingSmall,
              top: AppSizing.paddingSmall,
              bottom: AppSizing.paddingRegular,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  key: Key(KeyConstants.keyShareButton),
                  icon: const Icon(Icons.share_outlined),
                  tooltip: localizations?.shareProfile ?? 'Share',
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ShareProfileBottomSheet(
                        profileId: profileId,
                        ref: ref,
                        localizations: localizations,
                      ),
                    );
                    if (result == 'shared' && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(localizations?.profileSharedMessage ?? 'Profile has been shared')),
                      );
                    }
                  },
                ),
                IconButton(
                  key: Key(KeyConstants.keySettingsButton),
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: localizations?.shareProfile ?? 'Settings',
                  onPressed: () {
                    navigation.push(ProfilesRoutePath.profileSettings(profileId));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizing.paddingMedium),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizing.paddingLarge,
              right: AppSizing.paddingLarge,
              top: AppSizing.paddingSmall,
              bottom: AppSizing.paddingRegular,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: profileType == ProfileType.affinidiCloud
                          ? SvgPicture.asset(
                              'assets/icons/affinidi-cloud.svg',
                              width: AppSizing.iconMedium,
                              height: AppSizing.iconMedium,
                            )
                          : SvgPicture.asset(
                              'assets/icons/drift-profile.svg',
                              width: AppSizing.iconMedium,
                              height: AppSizing.iconMedium,
                            ),
                    ),
                    const SizedBox(width: AppSizing.paddingMedium),
                    Text(
                      profileName,
                      style: AppTheme.headingMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DidDisplay(did: profileDid),
                    if (profileDescription.isNotEmpty) ...[
                      Text(
                        profileDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColorScheme.divider),
        ],
      ),
    );
  }
}

class ShareProfileBottomSheet extends ConsumerStatefulWidget {
  final String profileId;
  final WidgetRef ref;
  final AppLocalizations? localizations;

  const ShareProfileBottomSheet({
    required this.profileId,
    required this.ref,
    required this.localizations,
    super.key,
  });

  @override
  ConsumerState<ShareProfileBottomSheet> createState() => _ShareProfileBottomSheetState();
}

class _ShareProfileBottomSheetState extends ConsumerState<ShareProfileBottomSheet> {
  late final TextEditingController didController;

  bool isLoading = false;
  Permissions? selectedPermission = Permissions.read;
  ValueNotifier<String>? loadingMessageNotifier;

  @override
  void initState() {
    super.initState();
    didController = TextEditingController();
  }

  @override
  void dispose() {
    didController.dispose();
    super.dispose();
  }

  void handleShare() async {
    final navigation = ref.read(navigationServiceProvider);

    setState(() => isLoading = true);
    loadingMessageNotifier = ValueNotifier<String>(widget.localizations!.sharingProfileMessage);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          decoration: BoxDecoration(
            color: AppColorScheme.backgroundWhite,
            borderRadius: BorderRadius.circular(AppSizing.paddingMedium),
          ),
          child: SizedBox(
            width: 320,
            height: AppSizing.paddingXXLarge,
            child: ValueListenableBuilder<String>(
              valueListenable: loadingMessageNotifier!,
              builder: (context, message, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: AppSizing.iconMedium,
                    height: AppSizing.iconMedium,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: AppSizing.paddingMedium),
                  Flexible(child: Text(message, textAlign: TextAlign.left)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final didValue = didController.text.trim();
    final controller = widget.ref.read(profileSharingControllerProvider.notifier);
    controller.selectProfile(widget.profileId);
    await controller.shareAndAutoAccept(
      receiverDid: didValue,
      permissions: selectedPermission!,
      onMessage: (message) {
        final messageService = widget.ref.read(messageServiceProvider);
        final localizedMessage = messageService.getLocalizedMessage(message, widget.localizations!);
        loadingMessageNotifier!.value = localizedMessage;
      },
    );
    await SharedProfileAccessService().addSharedAccess(
      receiverDid: didValue,
      profileId: widget.profileId,
      accessLevel: selectedPermission == Permissions.read ? 'read' : 'write',
    );
    if (!mounted) return;
    navigation.pop();
    if (!mounted) return;
    navigation.pop('shared');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final navigation = ref.read(navigationServiceProvider);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizing.iconSmall)),
        ),
        padding: const EdgeInsets.all(AppSizing.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations?.shareProfile ?? 'Share Profile',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: AppSizing.paddingMedium),
            SimpleInfoWidget(
              text: '${localizations?.recipientDidLabel ?? 'Enter Receiver Profile DID'}*',
              dialogTitle: localizations!.infoShareRecipientDID,
              dialogContent: localizations.infoShareRecipientDIDDescription,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizing.paddingSmall),
            TextField(
              key: Key(KeyConstants.keyEnterDiDTextField),
              controller: didController,
              decoration: InputDecoration(
                hintText: localizations.recipientDidHint,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)
                    .copyWith(color: AppColorScheme.backgroundDark),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderUnfocused),
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderUnfocused),
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColorScheme.formFieldBorderUnfocused),
                  borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
                ),
                contentPadding: const EdgeInsets.all(AppSizing.paddingMedium),
              ),
              enabled: !isLoading,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizing.paddingLarge),
            SimpleInfoWidget(
              text: localizations.accessPermissionLabel,
              dialogTitle: localizations.infoSharePermissions,
              dialogContent: localizations.infoSharePermissionsDescription,
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizing.paddingSmall),
            RadioListTile<Permissions>(
              title: Text(
                localizations.canViewOnlyLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: Permissions.read,
              groupValue: selectedPermission,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() => selectedPermission = value);
                    },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4),
            ),
            RadioListTile<Permissions>(
              key: Key(KeyConstants.keyCanWriteRadio),
              title: Text(
                localizations.canWriteLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: Permissions.all,
              groupValue: selectedPermission,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() => selectedPermission = value);
                    },
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4),
            ),
            Center(
                child: SimpleInfoWidget(
              text: localizations.infoShareFlow,
              dialogTitle: localizations.infoShareFlow,
              dialogContent: localizations.infoShareFlowDescription,
              textStyle: Theme.of(context).textTheme.bodySmall,
            )),
            const SizedBox(height: AppSizing.paddingLarge),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (isLoading) return;
                      navigation.pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColorScheme.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSizing.paddingRegular),
                    ),
                    child: Text(localizations.cancelActionText),
                  ),
                ),
                Expanded(
                  child: CodeSnippetWidget(
                    title: localizations.lblCSShareProfile,
                    codeLocations: CodeSnippetLocations.shareProfileSnippets(context),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    key: Key(KeyConstants.keyShareSubmitButton),
                    onPressed: isLoading || didController.text.trim().isEmpty ? null : handleShare,
                    child: isLoading
                        ? const SizedBox(
                            width: AppSizing.iconSmall,
                            height: AppSizing.iconSmall,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(localizations.shareProfile),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
