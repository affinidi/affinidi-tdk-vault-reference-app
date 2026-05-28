part of 'share_credential_page.dart';

List<VerifiableCredential>? _requiredMatchedVcs(
  ClaimedCredentialsResult? matchResult,
) {
  if (matchResult == null) return null;

  final result = <VerifiableCredential>[];
  for (final group in matchResult.vcsGroups.values) {
    final requiredCount = group.minimumVCsCountToShare;
    result.addAll(
      group.allAvailableVCs.take(requiredCount).map((item) => item.vc),
    );
  }
  return List.unmodifiable(result);
}

class _SharePageBody extends ConsumerWidget {
  const _SharePageBody({
    required this.requestJwt,
    this.clientId,
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
    final (
      :isSubmitting,
      :submitError,
      :requestError,
      :selectedVaultId,
      :hasProfiles,
      :hasMatchResult,
    ) = ref.watch(
      controllerProvider.select(
        (state) => (
          isSubmitting: state.isSubmitting,
          submitError: state.submitError,
          requestError: state.requestError,
          selectedVaultId: state.selectedVaultId,
          hasProfiles: state.profiles != null && state.profiles!.isNotEmpty,
          hasMatchResult: state.matchResult != null,
        ),
      ),
    );

    if (isSubmitting) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSizing.paddingMedium),
            Text(
              localizations.shareSubmitResponse,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    if (submitError != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSizing.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShareFlowErrorCard(
              title: localizations.error,
              message: submitError,
            ),
            const SizedBox(height: AppSizing.paddingMedium),
            FilledButton(
              onPressed: () =>
                  ref.read(navigationServiceProvider).popOrGoHome(),
              child: Text(localizations.cancelActionText),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizing.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (requestError != null) ...[
                  const SizedBox(height: AppSizing.paddingMedium),
                  ShareFlowErrorCard(
                    title: localizations.error,
                    message: requestError,
                  ),
                  const SizedBox(height: AppSizing.paddingMedium),
                ],
                if (requestError == null) ...[
                  _VaultProfileSection(
                    requestJwt: requestJwt,
                    clientId: clientId,
                  ),
                ],
                if (requestError == null &&
                    selectedVaultId != null &&
                    hasProfiles) ...[
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
        if (requestError == null && hasMatchResult) ...[
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
