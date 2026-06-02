part of 'share_credential_page.dart';

class _VaultProfileSection extends HookConsumerWidget {
  const _VaultProfileSection({
    required this.requestJwt,
    this.clientId,
  });

  final String requestJwt;
  final String? clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controllerProvider = shareCredentialPageControllerProvider(
      requestJwt: requestJwt,
      clientId: clientId,
    );
    final controller = ref.read(controllerProvider.notifier);
    final (
      :vaultRegistry,
      :selectedVaultId,
      :isVerifyingPassphrase,
      :passphraseError,
      :profiles,
      :selectedProfileId,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          vaultRegistry: state.vaultRegistry,
          selectedVaultId: state.selectedVaultId,
          isVerifyingPassphrase: state.isVerifyingPassphrase,
          passphraseError: state.passphraseError,
          profiles: state.profiles,
          selectedProfileId: state.selectedProfileId,
        ),
      ),
    );

    final passphraseController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabelDropdown<String>(
          label: localizations.vault,
          value: selectedVaultId,
          hint: localizations.selectVault,
          items: vaultRegistry.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value.vaultName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (vaultId) {
            if (vaultId != null) {
              passphraseController.clear();
              controller.selectVault(vaultId);
            }
          },
        ),
        if (selectedVaultId != null) ...[
          const SizedBox(height: AppSizing.paddingMedium),
          if (profiles == null) ...[
            LabelTextField(
              label: localizations.vaultPassphrase,
              hint: localizations.vaultPassphraseEnter,
              controller: passphraseController,
              errorText: passphraseError,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.verifyPassphrase(value);
                }
              },
            ),
            if (isVerifyingPassphrase) ...[
              const SizedBox(height: AppSizing.paddingSmall),
              const LinearProgressIndicator(),
            ],
          ] else if (profiles.isEmpty) ...[
            Text(
              localizations.vaultNoProfiles,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ] else ...[
            LabelDropdown<String>(
              label: localizations.profile,
              value: selectedProfileId,
              hint: localizations.selectProfile,
              items: profiles
                  .map(
                    (profile) => DropdownMenuItem<String>(
                      value: profile.id,
                      child: Text(
                        profile.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (profileId) {
                if (profileId != null) controller.selectProfile(profileId);
              },
            ),
          ],
        ],
      ],
    );
  }
}
