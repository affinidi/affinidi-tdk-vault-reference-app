import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../l10n/app_localizations.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/simple_info_widget.dart';
import '../../widgets/tdk_app_bar.dart';

class ShareNodeFullScreenPage extends HookConsumerWidget {
  const ShareNodeFullScreenPage({
    super.key,
    required this.profileId,
    required this.nodeId,
    required this.nodeName,
  });

  final String profileId;
  final String nodeId;
  final String nodeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);
    final vaultService = ref.read(vaultServiceProvider.notifier);
    final didController = useTextEditingController();
    final selectedPermission = useState<Permissions?>(Permissions.read);
    final hasTimeLimit = useState<bool>(false);
    final selectedDate = useState<DateTime?>(null);
    final selectedTime = useState<TimeOfDay?>(null);
    final isLoading = useState<bool>(false);

    Future<void> handleShare() async {
      if (didController.text.trim().isEmpty) return;

      isLoading.value = true;
      try {
        final receiverDid = didController.text.trim();
        DateTime? expiresAt;

        if (hasTimeLimit.value && selectedDate.value != null) {
          final date = selectedDate.value!;
          final time =
              selectedTime.value ?? const TimeOfDay(hour: 23, minute: 59);
          final localDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          final now = DateTime.now();
          if (localDateTime.isBefore(now)) {
            throw Exception('Expiration date must be in the future');
          }
          expiresAt = localDateTime.toUtc();
        }

        await vaultService.shareItem(
          profileId: profileId,
          nodeId: nodeId,
          toDid: receiverDid,
          permissions: selectedPermission.value ?? Permissions.read,
          expiresAt: expiresAt,
        );

        if (context.mounted) {
          navigation.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.fileSharedMessage,
                style: const TextStyle(color: AppColorScheme.textPrimary),
              ),
              backgroundColor: AppColorScheme.backgroundDark,
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${localizations.errorSharingFile}: $e',
                style: const TextStyle(color: AppColorScheme.textPrimary),
              ),
              backgroundColor: AppColorScheme.backgroundDark,
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> selectDate() async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? now,
        firstDate: today,
        lastDate: DateTime(now.year + 10),
      );
      if (picked != null) {
        selectedDate.value = picked;
        if (picked.year == now.year &&
            picked.month == now.month &&
            picked.day == now.day) {
          final currentTime = TimeOfDay.fromDateTime(now);
          if (selectedTime.value != null) {
            final selectedTimeValue = selectedTime.value!;
            if (selectedTimeValue.hour < currentTime.hour ||
                (selectedTimeValue.hour == currentTime.hour &&
                    selectedTimeValue.minute <= currentTime.minute)) {
              selectedTime.value = TimeOfDay(
                hour: currentTime.hour,
                minute: (currentTime.minute + 1) % 60,
              );
            }
          }
        }
      }
    }

    Future<void> selectTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value ?? TimeOfDay.now(),
      );
      if (picked != null) {
        selectedTime.value = picked;
      }
    }

    Widget permissionSelector({
      required Permissions value,
      required String label,
    }) {
      final isSelected = selectedPermission.value == value;

      return ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 8,
        minVerticalPadding: 0,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
        leading: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: AppColorScheme.textPrimary,
          size: AppSizing.iconSmall + 2,
        ),
        title: Text(label, style: Theme.of(context).textTheme.bodySmall),
        onTap: isLoading.value
            ? null
            : () {
                selectedPermission.value = value;
              },
      );
    }

    return Scaffold(
      appBar: TdkAppBar(showBackButton: true, title: localizations.shareFile),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSizing.paddingLarge,
            right: AppSizing.paddingLarge,
            top: AppSizing.paddingLarge,
            bottom:
                AppSizing.paddingLarge +
                MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleInfoWidget(
                text: '${localizations.recipientDidLabel}*',
                dialogTitle: localizations.infoShareRecipientDID,
                dialogContent: localizations.infoShareRecipientDIDDescription,
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSizing.paddingSmall),
              TextField(
                controller: didController,
                enabled: !isLoading.value,
                enableInteractiveSelection: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: localizations.recipientDidHint,
                  hintStyle: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)
                      .copyWith(color: AppColorScheme.textPrimary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColorScheme.formFieldBorderUnfocused,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXSmall,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColorScheme.formFieldBorderUnfocused,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXSmall,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColorScheme.formFieldBorderUnfocused,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXSmall,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(AppSizing.paddingMedium),
                ),
              ),
              const SizedBox(height: AppSizing.paddingLarge),
              SimpleInfoWidget(
                text: localizations.accessPermissionLabel,
                dialogTitle: localizations.infoSharePermissions,
                dialogContent: localizations.infoSharePermissionsDescription,
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSizing.paddingSmall),
              permissionSelector(
                value: Permissions.read,
                label: localizations.canViewOnlyLabel,
              ),
              permissionSelector(
                value: Permissions.all,
                label: localizations.canWriteLabel,
              ),
              const SizedBox(height: AppSizing.paddingLarge),
              Row(
                children: [
                  Checkbox(
                    value: hasTimeLimit.value,
                    onChanged: isLoading.value
                        ? null
                        : (value) {
                            hasTimeLimit.value = value ?? false;
                            if (!hasTimeLimit.value) {
                              selectedDate.value = null;
                              selectedTime.value = null;
                            }
                          },
                  ),
                  Expanded(
                    child: Text(
                      localizations.timeLimitLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              if (hasTimeLimit.value) ...[
                const SizedBox(height: AppSizing.paddingMedium),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading.value ? null : selectDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          selectedDate.value != null
                              ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}'
                              : localizations.selectDateLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizing.paddingMedium),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading.value ? null : selectTime,
                        icon: const Icon(Icons.access_time, size: 18),
                        label: Text(
                          selectedTime.value != null
                              ? selectedTime.value!.format(context)
                              : localizations.selectTimeLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSizing.paddingLarge),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => navigation.pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColorScheme.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizing.paddingRegular,
                        ),
                      ),
                      child: Text(localizations.cancelActionText),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          isLoading.value || didController.text.trim().isEmpty
                          ? null
                          : handleShare,
                      child: isLoading.value
                          ? const SizedBox(
                              width: AppSizing.iconSmall,
                              height: AppSizing.iconSmall,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColorScheme.textPrimary,
                              ),
                            )
                          : Text(localizations.shareProfile),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
