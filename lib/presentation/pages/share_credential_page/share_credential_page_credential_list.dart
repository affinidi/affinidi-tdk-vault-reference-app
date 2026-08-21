part of 'share_credential_page.dart';

/// Converts snake_case strings to Title Case format.
/// Example: "personal_info" -> "Personal Info"
String _toTitleCase(String text) {
  return text
      .split('_')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

class _MatchedCredentialList extends ConsumerWidget {
  const _MatchedCredentialList({
    required this.requestJwt,
    required this.clientId,
  });

  final String requestJwt;
  final String? clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final controllerProvider = shareCredentialPageControllerProvider(
      requestJwt: requestJwt,
      clientId: clientId,
    );
    final controller = ref.read(controllerProvider.notifier);
    final (
      :stage,
      :selectedCredentialIds,
      :matchResult,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          stage: state.stage,
          selectedCredentialIds: state.selectedCredentialIds,
          matchResult: state.matchResult,
        ),
      ),
    );

    final isMatchingCredentials = stage is StageMatchingCredentials;
    final matchError = stage is StageMatchFailed ? stage.message : null;

    final matchedVCs = matchResult?.requiredMatchedVcs;
    final hasEnoughVCs = matchResult?.hasEnoughVCsAvailableToShare ?? false;
    final credentialError = matchError ??
        (matchedVCs != null && (matchedVCs.isEmpty || !hasEnoughVCs)
            ? (matchedVCs.isEmpty
                ? localizations.errorMessage('noShareableCredentials')
                : localizations.shareFlowNotEnoughMatchingCredentials)
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMatchingCredentials) ...[
          const SizedBox(height: AppSizing.paddingMedium),
          const LinearProgressIndicator(),
        ] else if (matchedVCs != null &&
            matchedVCs.isNotEmpty &&
            hasEnoughVCs) ...[
          const SizedBox(height: 36),
          ...matchResult!.groups
              .where((group) => group.availableCredentials.isNotEmpty)
              .map((group) {
            final groupVcIds = group.availableCredentials
                .map((vc) => vc.id.toString())
                .toList(growable: false);
            final requiredCount = group.minimumVCsCountToShare;

            final selectedInGroup = group.availableCredentials
                .where((vc) => selectedCredentialIds.contains(vc.id.toString()))
                .toList(growable: false);
            final displayVCs = selectedInGroup.isNotEmpty
                ? selectedInGroup
                : group.availableCredentials.take(requiredCount).toList();

            // Only offer the picker when there are more candidates than the
            // group requires; otherwise the selection is fixed and valid.
            final canPick = group.availableCredentials.length > requiredCount;

            void openPicker() => showModalBottomSheet<void>(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  builder: (_) => _CredentialPickerSheet(
                    title: _toTitleCase(group.label),
                    candidates: group.availableCredentials,
                    initialSelectedIds:
                        displayVCs.map((vc) => vc.id.toString()).toSet(),
                    requiredCount: requiredCount,
                    onConfirm: (ids) {
                      Navigator.of(context).pop();
                      controller.setGroupSelection(groupVcIds, ids);
                    },
                  ),
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final vc in displayVCs)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSizing.paddingMedium),
                    child: ShareCredentialItem(
                      verifiableCredential: vc,
                      onTap: canPick ? openPicker : null,
                    ),
                  ),
              ],
            );
          }),
        ] else if (credentialError != null) ...[
          const SizedBox(height: AppSizing.paddingLarge),
          ShareFlowErrorCard(
            title: localizations.error,
            message: credentialError,
          ),
        ],
      ],
    );
  }
}

class _CredentialPickerSheet extends StatefulWidget {
  const _CredentialPickerSheet({
    required this.title,
    required this.candidates,
    required this.initialSelectedIds,
    required this.requiredCount,
    required this.onConfirm,
  });

  final String title;
  final List<VerifiableCredential> candidates;
  final Set<String> initialSelectedIds;
  final int requiredCount;
  final void Function(Set<String> vcIds) onConfirm;

  @override
  State<_CredentialPickerSheet> createState() => _CredentialPickerSheetState();
}

class _CredentialPickerSheetState extends State<_CredentialPickerSheet> {
  late final Set<String> _selected = {...widget.initialSelectedIds};

  bool get _isMultiSelect => widget.requiredCount > 1;

  void _onTap(String vcId) {
    // Single-credential groups apply immediately (radio-like); multi-credential
    // groups toggle until exactly `requiredCount` are chosen, then confirm.
    if (!_isMultiSelect) {
      widget.onConfirm({vcId});
      return;
    }
    setState(() {
      if (_selected.contains(vcId)) {
        _selected.remove(vcId);
      } else if (_selected.length < widget.requiredCount) {
        _selected.add(vcId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canConfirm = _selected.length == widget.requiredCount;

    return SafeArea(
      child: BottomSheetDialog(
        title: widget.title,
        actions: _isMultiSelect
            ? [
                FilledButton(
                  onPressed:
                      canConfirm ? () => widget.onConfirm(_selected) : null,
                  child: Text(localizations.continueActionText),
                ),
              ]
            : const [],
        onCancel: () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: widget.candidates.map((vc) {
            final vcId = vc.id.toString();
            final isSelected = _selected.contains(vcId);
            final atCap =
                _isMultiSelect && _selected.length >= widget.requiredCount;
            final canToggle = isSelected || !atCap;
            final displayName = vc.displayName;
            final issuanceDate =
                vc.formattedIssuanceDate(localizations.localeName);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizing.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: canToggle ? () => _onTap(vcId) : null,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: canToggle ? (_) => _onTap(vcId) : null,
                          ),
                          const SizedBox(width: AppSizing.paddingSmall),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  displayName ?? localizations.verifiedData,
                                  style: theme.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSizing.paddingXSmall),
                                Text(
                                  '${localizations.issuanceDate}: $issuanceDate',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColorScheme.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizing.paddingSmall),
                  GestureDetector(
                    onTap: () => ClaimedCredentialDetailsPage.show(
                      context: context,
                      verifiableCredential: vc,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppColorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
