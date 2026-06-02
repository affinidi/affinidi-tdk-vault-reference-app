part of 'share_credential_page.dart';

class _ShareActionBar extends ConsumerWidget {
  const _ShareActionBar({
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
      :isMatchedVCsEmpty,
      :autoAllowConsent,
      :isConsentManagementEnabled,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          isMatchedVCsEmpty:
              state.matchResult?.requiredMatchedVcs.isEmpty ?? true,
          autoAllowConsent: state.autoAllowConsent,
          isConsentManagementEnabled: state.isConsentManagementEnabled,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isConsentManagementEnabled) ...[
          Row(
            children: [
              SizedBox(
                width: AppSizing.iconXSmall,
                child: Checkbox(
                  visualDensity: VisualDensity.comfortable,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: autoAllowConsent,
                  onChanged: (value) {
                    controller.setAutoAllowConsent(value ?? false);
                  },
                ),
              ),
              const SizedBox(width: AppSizing.paddingSmall),
              Expanded(
                child: Text(
                  localizations.automaticallyAllowConsent,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColorScheme.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizing.paddingSmall),
        ],
        FilledButton(
          onPressed: isMatchedVCsEmpty
              ? null
              : () async {
                  try {
                    final redirectUri =
                        await controller.submitSelectedCredentials();
                    if (redirectUri != null) {
                      await launchUrl(
                        redirectUri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                    if (!context.mounted) return;
                    ref.read(navigationServiceProvider).popOrGoHome();
                  } catch (_) {}
                },
          child: Text(localizations.shareSubmit),
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        OutlinedButton(
          onPressed: () async {
            try {
              final redirectUri = await controller.rejectShareRequest();
              if (redirectUri != null) {
                await launchUrl(
                  redirectUri,
                  mode: LaunchMode.externalApplication,
                );
              }
              if (!context.mounted) return;
              ref.read(navigationServiceProvider).popOrGoHome();
            } catch (_) {}
          },
          child: Text(localizations.shareReject),
        ),
      ],
    );
  }
}
