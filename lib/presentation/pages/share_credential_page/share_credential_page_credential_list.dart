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
    final selectedVcByGroup =
        matchResult?.selectedVcFor(selectedCredentialIds) ??
            <String, VerifiableCredential>{};
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

            final selected =
                selectedVcByGroup[group.id] ?? group.availableCredentials.first;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizing.paddingMedium),
              child: ShareCredentialItem(
                verifiableCredential: selected,
                onTap: group.availableCredentials.length > 1
                    ? () => showModalBottomSheet<void>(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (_) => _CredentialPickerSheet(
                            title: _toTitleCase(group.label),
                            candidates: group.availableCredentials,
                            selectedVcId: selected.id.toString(),
                            onSelect: (newId) {
                              Navigator.of(context).pop();
                              controller.selectCredentialForGroup(
                                  groupVcIds, newId);
                            },
                          ),
                        )
                    : null,
              ),
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

class _CredentialPickerSheet extends StatelessWidget {
  const _CredentialPickerSheet({
    required this.title,
    required this.candidates,
    required this.selectedVcId,
    required this.onSelect,
  });

  final String title;
  final List<VerifiableCredential> candidates;
  final String selectedVcId;
  final void Function(String vcId) onSelect;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: BottomSheetDialog(
        title: title,
        actions: const [],
        onCancel: () {
          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: candidates.map((vc) {
            final vcId = vc.id.toString();
            final isSelected = vcId == selectedVcId;
            final displayName = vc.displayName;
            final issuanceDate =
                vc.formattedIssuanceDate(localizations.localeName);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizing.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect(vcId),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (_) => onSelect(vcId),
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
