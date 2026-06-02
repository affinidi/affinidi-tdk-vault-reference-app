part of 'share_credential_page.dart';

String _descriptorLabel(Map<String, dynamic> descriptor) {
  final name = descriptor['name'];
  if (name is String && name.trim().isNotEmpty) return name.trim();

  final id = descriptor['id'];
  if (id is String && id.trim().isNotEmpty) return id.trim();

  return 'Credential request';
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
      :isMatchingCredentials,
      :selectedCredentialIds,
      :matchResult,
      :matchError,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          isMatchingCredentials: state.isMatchingCredentials,
          selectedCredentialIds: state.selectedCredentialIds,
          matchResult: state.matchResult,
          matchError: state.matchError,
        ),
      ),
    );

    final matchedVCs = matchResult?.requiredMatchedVcs;
    final credentialError = matchError ??
        (matchedVCs != null && matchedVCs.isEmpty
            ? localizations.errorMessage('noShareableCredentials')
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMatchingCredentials) ...[
          const SizedBox(height: AppSizing.paddingMedium),
          const LinearProgressIndicator(),
        ] else if (matchedVCs != null && matchedVCs.isNotEmpty) ...[
          const SizedBox(height: 36),
          ...matchResult!.vcsGroups.entries
              .where(
                  (groupEntry) => groupEntry.value.allAvailableVCs.isNotEmpty)
              .map((entry) {
            final descriptor = entry.key;
            final group = entry.value;
            final groupVcIds = group.allAvailableVCs
                .map((vcItem) => vcItem.vc.id.toString())
                .toList(growable: false);

            final selected = group.allAvailableVCs.firstWhere(
              (vcItem) =>
                  selectedCredentialIds.contains(vcItem.vc.id.toString()),
              orElse: () => group.allAvailableVCs.first,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizing.paddingMedium),
              child: ShareCredentialItem(
                verifiableCredential: selected.vc,
                isSelected:
                    selectedCredentialIds.contains(selected.vc.id.toString()),
                onChanged: (value) => controller.toggleCredentialSelection(
                  selected.vc.id.toString(),
                  selected: value ?? false,
                ),
                onTap: group.allAvailableVCs.length > 1
                    ? () => showModalBottomSheet<void>(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (_) => _CredentialPickerSheet(
                            title: _descriptorLabel(descriptor.toJson()),
                            candidates: group.allAvailableVCs,
                            selectedVcId: selected.vc.id.toString(),
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
  final List<VcAvailable> candidates;
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
          children: candidates.map((candidate) {
            final vc = candidate.vc;
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
