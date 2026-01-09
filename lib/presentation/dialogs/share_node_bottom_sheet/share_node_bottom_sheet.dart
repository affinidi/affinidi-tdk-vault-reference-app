import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation_provider.dart';
import '../../pages/share_node_full_screen_page/share_node_full_screen_page.dart';
import '../../pages/manage_node_access/manage_node_access.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/simple_info_widget.dart';

class ShareNodeBottomSheet extends HookConsumerWidget {
  const ShareNodeBottomSheet({
    super.key,
    required this.profileId,
    required this.nodeId,
    required this.nodeName,
  });

  final String profileId;
  final String nodeId;
  final String nodeName;

  static void show({
    required BuildContext context,
    required String profileId,
    required String nodeId,
    required String nodeName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareNodeBottomSheet(
        profileId: profileId,
        nodeId: nodeId,
        nodeName: nodeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);
    final didController = useTextEditingController();
    final selectedPermission = useState<Permissions?>(Permissions.read);
    final hasTimeLimit = useState<bool>(false);
    final selectedDate = useState<DateTime?>(null);
    final selectedTime = useState<TimeOfDay?>(null);
    final isLoading = useState<bool>(false);

    void openFullPage() {
      final navigator = Navigator.of(context);
      navigator.pop();
      Future.microtask(
        () => navigator.push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ShareNodeFullScreenPage(
              profileId: profileId,
              nodeId: nodeId,
              nodeName: nodeName,
            ),
          ),
        ),
      );
    }

    void openManageAccessPage() {
      final navigator = Navigator.of(context);
      navigator.pop();
      Future.microtask(
        () => navigator.push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => ManageNodeAccessPage(
              profileId: profileId,
              nodeId: nodeId,
              nodeName: nodeName,
            ),
          ),
        ),
      );
    }

    Future<void> selectDate() async {
      final now = DateTime.now();
      // Use today's date (midnight) to ensure we don't allow past dates
      final today = DateTime(now.year, now.month, now.day);
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? now,
        firstDate: today,
        lastDate: DateTime(now.year + 10),
      );
      if (picked != null) {
        selectedDate.value = picked;
        // If date is today, ensure time is in the future
        if (picked.year == now.year &&
            picked.month == now.month &&
            picked.day == now.day) {
          final currentTime = TimeOfDay.fromDateTime(now);
          if (selectedTime.value != null) {
            final selectedTimeValue = selectedTime.value!;
            // If selected time is before current time, set it to current time + 1 minute
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

    final mq = MediaQuery.of(context);

    return DraggableScrollableSheet(
      expand: false,
      minChildSize: 0.35,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Padding(
          padding: mq.viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizing.iconSmall),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSizing.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.shareFile,
                    style: AppTheme.headingMedium,
                  ),
                  const SizedBox(height: AppSizing.paddingMedium),
                  SimpleInfoWidget(
                    text: '${localizations.recipientDidLabel}*',
                    dialogTitle: localizations.infoShareRecipientDID,
                    dialogContent:
                        localizations.infoShareRecipientDIDDescription,
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
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)
                          .copyWith(color: AppColorScheme.textPrimary),
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
                      contentPadding:
                          const EdgeInsets.all(AppSizing.paddingMedium),
                    ),
                  ),
                  const SizedBox(height: AppSizing.paddingLarge),
                  SimpleInfoWidget(
                    text: localizations.accessPermissionLabel,
                    dialogTitle: localizations.infoSharePermissions,
                    dialogContent:
                        localizations.infoSharePermissionsDescription,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSizing.paddingSmall),
                  _PermissionTile(
                    label: localizations.canViewOnlyLabel,
                    value: Permissions.read,
                    selected: selectedPermission.value == Permissions.read,
                    enabled: !isLoading.value,
                    onSelect: () => selectedPermission.value = Permissions.read,
                  ),
                  _PermissionTile(
                    label: localizations.canWriteLabel,
                    value: Permissions.all,
                    selected: selectedPermission.value == Permissions.all,
                    enabled: !isLoading.value,
                    onSelect: () => selectedPermission.value = Permissions.all,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (isLoading.value) return;
                            navigation.pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColorScheme.textPrimary,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSizing.paddingRegular),
                          ),
                          child: Text(localizations.cancelActionText),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: openFullPage,
                          child: Text(localizations.shareProfile),
                        ),
                      ),
                      const SizedBox(width: AppSizing.paddingSmall),
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: openManageAccessPage,
                          child: Text(localizations.manageAccess),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.label,
    required this.value,
    required this.selected,
    required this.enabled,
    required this.onSelect,
  });

  final String label;
  final Permissions value;
  final bool selected;
  final bool enabled;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? AppColorScheme.textPrimary : AppColorScheme.textSecondary;

    return InkWell(
      onTap: enabled ? onSelect : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizing.paddingSmall),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: color,
              size: AppSizing.iconSmall + 2,
            ),
            const SizedBox(width: AppSizing.paddingSmall),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
