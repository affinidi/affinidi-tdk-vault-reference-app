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
    final (:isMatchedVCsEmpty,) = ref.watch(
      controllerProvider.select(
        (state) => (
          isMatchedVCsEmpty:
              _requiredMatchedVcs(state.matchResult)?.isEmpty ?? true,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: isMatchedVCsEmpty
              ? null
              : () async {
                  try {
                    await controller.submitSelectedCredentials();
                  } catch (_) {}
                },
          child: Text(localizations.shareSubmit),
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        OutlinedButton(
          onPressed: () async {
            try {
              await controller.rejectShareRequest();
            } catch (_) {}
          },
          child: Text(localizations.shareReject),
        ),
      ],
    );
  }
}
