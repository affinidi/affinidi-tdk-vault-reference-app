import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/models/profile/profile_type.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import '../../widgets/simple_info_widget.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import 'create_profile_form_controller.dart';

class CreateProfileForm extends ConsumerWidget {
  const CreateProfileForm({
    super.key,
  });

  static void show({
    required BuildContext context,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => CreateProfileForm(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = createProfileFormControllerProvider;
    final controller = ref.read(provider.notifier);
    final nameController = controller.profileNameController;
    final descriptionController = controller.profileDescriptionController;
    final navigation = ref.read(navigationServiceProvider);

    void onCancel() {
      if (!context.mounted) return;

      FocusScope.of(context).unfocus();
      navigation.pop();
    }

    void onCreateProfile() async {
      if (!context.mounted) return;

      HapticFeedback.lightImpact();
      await controller.create(
        onSuccess: () {
          if (!context.mounted) return;
          FocusScope.of(context).unfocus();
          navigation.pop();
        },
      );
    }

    return BottomSheetDialog(
      title: localizations.createProfileTitle,
      titleStyle: Theme.of(context).textTheme.titleMedium,
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: AppColorScheme.textPrimary,
          ),
          child: Text(
            localizations.cancelActionText,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        CodeSnippetWidget(
          title: localizations.lblCSCreateProfile,
          codeLocations: CodeSnippetLocations.createProfileSnippets(context),
        ),
        _CreateProfileButton(onCreateProfile: onCreateProfile),
      ],
      body: Column(
        children: [
          ModalAsyncLoadingStatus(
              loadingMessage: localizations.createProfileLoadingMessage, controller.loadingController),
          Column(
            spacing: AppSizing.paddingLarge,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileNameField(nameController: nameController),
              _ProfileDescriptionField(descriptionController: descriptionController),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(createProfileFormControllerProvider);
                  final controller = ref.read(createProfileFormControllerProvider.notifier);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RadioTile(
                        value: ProfileType.affinidiCloud,
                        groupValue: state.selectedProfileType,
                        label: localizations.profileTypeAffinidiCloud,
                        icon: 'assets/icons/affinidi-cloud.svg',
                        onChanged: (value) {
                          if (value != null) controller.setProfileType(value);
                        },
                      ),
                      const SizedBox(height: AppSizing.paddingXSmall),
                      _RadioTile(
                        value: ProfileType.edge,
                        groupValue: state.selectedProfileType,
                        label: localizations.profileTypeDrift,
                        icon: 'assets/icons/drift-profile.svg',
                        onChanged: (value) {
                          if (value != null) controller.setProfileType(value);
                        },
                      ),
                      const SizedBox(height: AppSizing.paddingXSmall),
                      Center(
                        child: SimpleInfoWidget(
                          text: localizations.infoProfileStorage,
                          dialogTitle: localizations.infoProfileStorage,
                          dialogContent: localizations.infoProfileStorageDescription,
                          textStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      if (state.selectedProfileType == ProfileType.edge) ...[
                        const SizedBox(height: AppSizing.paddingSmall),
                        Container(
                          padding: const EdgeInsets.all(AppSizing.paddingRegular),
                          decoration: BoxDecoration(
                            color: AppColorScheme.backgroundLight,
                            borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: AppSizing.iconSmall,
                                height: AppSizing.iconSmall,
                                decoration: const BoxDecoration(
                                  color: AppColorScheme.textPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'i',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w600)
                                        .copyWith(color: AppColorScheme.backgroundWhite),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizing.paddingSmall),
                              Expanded(
                                child: Text(
                                  localizations.profileNotice,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSizing.paddingSmall),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
      onCancel: () => onCancel(),
    );
  }
}

class _ProfileNameField extends HookConsumerWidget {
  const _ProfileNameField({required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isNameFocused = useState(false);
    final hasName = ref.watch(createProfileFormControllerProvider.select((state) => state.hasName));
    final controller = ref.read(createProfileFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localizations.profileName}*',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        FormField<String>(
          builder: (field) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isNameFocused.value
                      ? AppColorScheme.formFieldBorderFocused
                      : AppColorScheme.formFieldBorderUnfocused,
                ),
                borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  isNameFocused.value = hasFocus;
                },
                child: TextField(
                  controller: nameController,
                  onChanged: (_) => field.didChange(nameController.text),
                  decoration: InputDecoration(
                    hintText: localizations.profileNamePlaceholder,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSizing.paddingRegular),
                    suffixIcon: hasName
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: () => controller.clearName(),
                          )
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileDescriptionField extends HookConsumerWidget {
  const _ProfileDescriptionField({required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDescriptionFocused = useState(false);
    final hasDescription = ref.watch(createProfileFormControllerProvider.select((state) => state.hasDescription));
    final controller = ref.read(createProfileFormControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.profileDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        FormField<String>(
          builder: (field) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDescriptionFocused.value ? const Color(0xff0467f1) : const Color(0xffcdced3),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  isDescriptionFocused.value = hasFocus;
                },
                child: TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  onChanged: (_) => field.didChange(descriptionController.text),
                  decoration: InputDecoration(
                    hintText: localizations.profileDescriptionPlaceholder,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSizing.paddingRegular),
                    suffixIcon: hasDescription
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded),
                            onPressed: () => controller.clearDescription(),
                          )
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    this.icon,
  });

  final ProfileType value;
  final ProfileType groupValue;
  final String label;
  final void Function(ProfileType?) onChanged;

  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<ProfileType>(
          key: Key('${KeyConstants.keyRadio}_${value.name}'),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppTheme.colorScheme.primary,
        ),
        const SizedBox(width: AppSizing.paddingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSizing.paddingSmall),
                    SvgPicture.asset(
                      icon!,
                      width: AppSizing.iconSmall,
                      height: AppSizing.iconSmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreateProfileButton extends ConsumerWidget {
  const _CreateProfileButton({
    required this.onCreateProfile,
  });

  final void Function() onCreateProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = createProfileFormControllerProvider;

    final isCreateProfileButtonEnabled = ref.watch(provider.select((state) => state.isCreateProfileButtonEnabled));

    return FilledButton(
      onPressed: isCreateProfileButtonEnabled ? () => onCreateProfile() : null,
      child: Text(localizations.createProfileActionText),
    );
  }
}
