import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../infrastructure/providers/file_settings_provider.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_theme.dart';
import '../../widgets/simple_info_widget.dart';

class FileSettingsBottomSheet extends HookConsumerWidget {
  const FileSettingsBottomSheet({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final maxFileSizeController = useTextEditingController();
    final formatInputController = useTextEditingController();
    final formats = useState<List<String>>([]);
    final formatOption = useState(0);
    final navigation = ref.read(navigationServiceProvider);

    final fileSettingsAsync = ref.watch(fileSettingsProvider(profileId));
    final localizations = AppLocalizations.of(context)!;

    useEffect(() {
      final settings = fileSettingsAsync.value;
      if (settings != null) {
        maxFileSizeController.text = settings.maxFileSize?.toString() ?? '';
        if (settings.allowedExtensions == null) {
          formatOption.value = 0;
          formats.value = [];
        } else {
          formatOption.value = 1;
          formats.value = settings.allowedExtensions?.split(',') ?? [];
        }
      } else {
        maxFileSizeController.clear();
        formatOption.value = 0;
        formats.value = [];
      }
      return null;
    }, [fileSettingsAsync]);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColorScheme.backgroundWhite,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizing.paddingMedium)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSizing.paddingLarge),
              child: Row(
                children: [
                  SimpleInfoWidget(
                    text: localizations.setFilePermissions,
                    dialogTitle: localizations.infoSetFilePermissions,
                    dialogContent:
                        localizations.infoSetFilePermissionsDescription,
                    textStyle: AppTheme.headingMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => navigation.pop(),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizing.paddingLarge),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localizations.fileFormatOptions,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSizing.paddingRegular),
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: formatOption.value,
                          onChanged: (v) => formatOption.value = v ?? 0,
                          activeColor: AppTheme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSizing.paddingSmall),
                        Text(
                          localizations.acceptAllFormats,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizing.paddingSmall),
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: formatOption.value,
                          onChanged: (v) => formatOption.value = v ?? 1,
                          activeColor: AppTheme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSizing.paddingSmall),
                        Text(
                          localizations.specifyAllowedFormats,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppSizing.paddingSmall),
                      ],
                    ),
                    const SizedBox(height: AppSizing.paddingLarge),

                    // File format input
                    if (formatOption.value == 1) ...[
                      Text(
                        'File format',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSizing.paddingSmall),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColorScheme.formFieldBorderFocused,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppSizing.paddingXSmall),
                              ),
                              child: TextFormField(
                                controller: formatInputController,
                                decoration: InputDecoration(
                                  hintText:
                                      localizations.inputAllowedFileFormats,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: AppColorScheme.backgroundDark),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.all(AppSizing.paddingMedium),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizing.paddingSmall),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColorScheme.formFieldBorderFocused,
                              borderRadius: BorderRadius.circular(
                                  AppSizing.paddingXSmall),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add,
                                  color: AppColorScheme.backgroundWhite,
                                  size: AppSizing.iconSmall),
                              onPressed: () {
                                final value = formatInputController.text
                                    .trim()
                                    .toLowerCase();
                                if (value.isNotEmpty &&
                                    !formats.value.contains(value)) {
                                  formats.value = [...formats.value, value];
                                  formatInputController.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizing.paddingSmall),
                      if (formats.value.isNotEmpty) ...[
                        Wrap(
                          spacing: AppSizing.paddingSmall,
                          children: formats.value
                              .map((format) => Chip(
                                    label: Text(format),
                                    onDeleted: () {
                                      formats.value = formats.value
                                          .where((f) => f != format)
                                          .toList();
                                    },
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: AppSizing.paddingMedium),
                      ],
                    ],

                    // File size limit
                    Text(
                      localizations.fileSizeLimit,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSizing.paddingSmall),
                    TextFormField(
                      controller: maxFileSizeController,
                      decoration: InputDecoration(
                        hintText: localizations.inputFileSizeInMb,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColorScheme.backgroundDark),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColorScheme.formFieldBorderUnfocused),
                          borderRadius:
                              BorderRadius.circular(AppSizing.paddingXSmall),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColorScheme.formFieldBorderUnfocused),
                          borderRadius:
                              BorderRadius.circular(AppSizing.paddingXSmall),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColorScheme.formFieldBorderUnfocused),
                          borderRadius:
                              BorderRadius.circular(AppSizing.paddingXSmall),
                        ),
                        contentPadding: EdgeInsets.all(AppSizing.paddingMedium),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSizing.paddingXLarge),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => navigation.pop(),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColorScheme.backgroundWhite,
                              foregroundColor: AppColorScheme.textPrimary,
                              side: const BorderSide(
                                  color:
                                      AppColorScheme.formFieldBorderUnfocused),
                              minimumSize: const Size.fromHeight(
                                  AppSizing.paddingXXLarge),
                            ),
                            child: Text(
                              localizations.cancelActionText,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizing.paddingSmall),
                        Expanded(
                          child: FilledButton(
                            onPressed: fileSettingsAsync.isLoading
                                ? null
                                : () async {
                                    final maxFileSize = int.tryParse(
                                        maxFileSizeController.text);
                                    final allowedExtensions =
                                        formatOption.value == 1
                                            ? formats.value.join(',')
                                            : null;
                                    await ref
                                        .read(fileSettingsProvider(profileId)
                                            .notifier)
                                        .update(
                                          maxFileSize: maxFileSize,
                                          allowedExtensions:
                                              allowedExtensions?.isEmpty ?? true
                                                  ? null
                                                  : allowedExtensions,
                                        );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                localizations.settingsSaved)),
                                      );
                                    }
                                  },
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: AppColorScheme.backgroundWhite,
                              minimumSize: const Size.fromHeight(
                                  AppSizing.paddingXXLarge),
                            ),
                            child: fileSettingsAsync.isLoading
                                ? const SizedBox(
                                    width: AppSizing.iconSmall,
                                    height: AppSizing.iconSmall,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColorScheme.backgroundWhite),
                                    ),
                                  )
                                : Text(
                                    localizations.saveActionText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppColorScheme.backgroundWhite),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizing.paddingLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
