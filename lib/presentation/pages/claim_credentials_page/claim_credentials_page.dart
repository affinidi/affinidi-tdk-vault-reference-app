import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/profile/did_display.dart';

import 'claim_credentials_page_controller.dart';
import 'claim_credentials_page_state.dart';
import 'widgets/claim_uri_form.dart';
import 'widgets/credential_offer_details.dart';

import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../widgets/simple_info_widget.dart';

class ClaimCredentialsPage extends HookConsumerWidget {
  static String routePath = ClaimCredentialsRoutePath.base;

  const ClaimCredentialsPage({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = claimCredentialsPageControllerProvider(
      profileId: profileId,
    );
    final controller = ref.read(
      provider.notifier,
    );

    final profileDidFuture = useMemoized(() => controller.getProfileDid());
    final profileDid = useFuture(profileDidFuture);

    final offerUri = ref.watch(provider.select((s) => s.offerUri));
    final fetchStatus = ref.watch(provider.select((s) => s.fetchStatus));

    final navigation = ref.read(navigationServiceProvider);

    return Scaffold(
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () {
          navigation.pop(VaultsRoutePath.base);
        },
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSClaimCredential,
            codeLocations:
                CodeSnippetLocations.claimCredentialSnippets(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: 480), // Keep content centered & readable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 1.0,
                    left: 1.0,
                    right: 1.0,
                    bottom: AppSizing.paddingRegular),
                child: Text(
                  localizations.claimCredentialsTitle,
                  style: AppTheme.headingXLarge,
                ),
              ),
              if (fetchStatus == CredentialOfferFetchStatus.loading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (fetchStatus == CredentialOfferFetchStatus.success ||
                  fetchStatus == CredentialOfferFetchStatus.error) ...[
                CredentialOfferDetails(
                  offerUri: offerUri,
                  profileId: profileId,
                ),
              ] else ...[
                Text(
                  localizations.claimInputInstruction,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (profileDid.connectionState == ConnectionState.done &&
                    profileDid.hasData &&
                    profileDid.data!.isNotEmpty)
                  DidDisplay(did: profileDid.data!),
                ClaimUriForm(
                  onSubmit: (Uri uri) {
                    controller.fetchCredentialOffer(uri);
                  },
                ),
                const SizedBox(height: AppSizing.paddingXSmall),
                Center(
                  child: SimpleInfoWidget(
                    text: localizations.infoClaimCredential,
                    dialogTitle: localizations.infoClaimCredential,
                    dialogContent: localizations.infoClaimCredentialDescription,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
