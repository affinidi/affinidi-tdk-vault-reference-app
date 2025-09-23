import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../application/services/profile/profile_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/loading_status/async_loading_status.dart';
import '../../../widgets/loading_status/modal_async_loading_status.dart';
import '../claim_credentials_page_controller.dart';
import '../claim_credentials_page_state.dart';

import 'verifiable_credential.dart';

class CredentialOfferDetails extends HookConsumerWidget {
  const CredentialOfferDetails({
    super.key,
    this.offerUri,
    required this.profileId,
  });

  final Uri? offerUri;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (offerUri == null) {
      return const SizedBox.shrink();
    }

    final provider =
        claimCredentialsPageControllerProvider(profileId: profileId);
    final fetchStatus = ref.watch(provider.select((s) => s.fetchStatus));

    final controller = ref.read(provider.notifier);
    final localizations = AppLocalizations.of(context)!;

    useEffect(() {
      if (!context.mounted) return;
      Future(() {
        ref.read(profileServiceProvider.notifier).getProfiles();
      });
      return null;
    }, []);

    Future<void> saveCredential() async {
      if (!context.mounted) return;

      controller.saveCredential(
        profileId: profileId,
        onSuccess: () {
          if (!context.mounted) return;
          controller.goToMyCredentialPage();
        },
      );
    }

    return AsyncLoadingStatus(
      controller.loadingController,
      loadingDescription: localizations.loadingCredentials,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            ModalAsyncLoadingStatus(
              controller.validatingController,
              loadingMessage: localizations.claimCredentialsValidating,
            ),
            ModalAsyncLoadingStatus(
              controller.savingController,
              loadingMessage: localizations.claimCredentialsSaving,
            ),
            if (fetchStatus == CredentialOfferFetchStatus.error) ...[
              if (fetchStatus == CredentialOfferFetchStatus.error)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.errorMessage('getCredentialFailed'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => controller.retry(),
                        child: Text(localizations.retryActionText),
                      ),
                    ],
                  ),
                ),
            ] else ...[
              VerifiableCredential(
                offerUri: offerUri!,
                profileId: profileId,
              ),
              Center(
                child: FilledButton(
                  onPressed: saveCredential,
                  child: Text(
                    localizations.saveActionText,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
