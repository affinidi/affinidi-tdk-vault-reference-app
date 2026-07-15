part of 'share_credential_page.dart';

class _SharePageBody extends ConsumerWidget {
  const _SharePageBody({
    required this.requestJwt,
    this.clientId,
  });

  final String requestJwt;
  final String? clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = shareCredentialPageControllerProvider(
      requestJwt: requestJwt,
      clientId: clientId,
    );
    final (
      :stage,
      :selectedVaultId,
      :hasProfiles,
      :hasMatchResult,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          stage: state.stage,
          selectedVaultId: state.selectedVaultId,
          hasProfiles: state.profiles != null && state.profiles!.isNotEmpty,
          hasMatchResult: state.matchResult != null,
        ),
      ),
    );

    switch (stage) {
      case StageSubmitting():
        return Center(
          child: SizedBox(
            width: 80,
            height: 80,
            child: const CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),
        );
      case StageSubmitFailed(:final message) ||
            StageRequestInvalid(:final message):
        return _TerminalErrorView(message: message);
      case StageValidatingRequest():
      case StageAwaitingPassphrase():
      case StageVerifyingPassphrase():
      case StageAwaitingProfile():
      case StageMatchingCredentials():
      case StageMatchFailed():
      case StageReadyToShare():
      case StageDismissed():
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizing.paddingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _VaultProfileSection(
                      requestJwt: requestJwt,
                      clientId: clientId,
                    ),
                    if (selectedVaultId != null && hasProfiles) ...[
                      const SizedBox(height: AppSizing.paddingMedium),
                      _MatchedCredentialList(
                        requestJwt: requestJwt,
                        clientId: clientId,
                      ),
                    ],
                    const SizedBox(height: AppSizing.paddingLarge),
                  ],
                ),
              ),
            ),
            if (hasMatchResult) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizing.paddingMedium,
                  0,
                  AppSizing.paddingMedium,
                  AppSizing.paddingMedium,
                ),
                child: _ShareActionBar(
                  requestJwt: requestJwt,
                  clientId: clientId,
                ),
              ),
            ],
          ],
        );
    }
  }
}

class _TerminalErrorView extends ConsumerWidget {
  const _TerminalErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSizing.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShareFlowErrorCard(
            title: localizations.error,
            message: message,
          ),
          const SizedBox(height: AppSizing.paddingMedium),
          FilledButton(
            onPressed: () => ref.read(navigationServiceProvider).popOrGoHome(),
            child: Text(localizations.cancelActionText),
          ),
        ],
      ),
    );
  }
}
