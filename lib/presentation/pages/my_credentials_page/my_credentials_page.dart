import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/services/credential/credential_service.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../infrastructure/extensions/build_context_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../dialogs/delete_credential_form/delete_credential_form.dart';
import '../../dialogs/options_picker/credential_option.dart';
import '../../dialogs/options_picker/options_picker.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/claimed_credential_medium_widget.dart';
import '../../widgets/loading_status/async_loading_status.dart';
import '../../widgets/pagination_controls.dart';
import '../claimed_credential_details_page/claimed_credential_details_page.dart';
import '../../widgets/simple_info_widget.dart';

import 'my_credentials_page_controller.dart';

class MyCredentialsPage extends HookConsumerWidget {
  static String get routePath => MyCredentialsRoutePath.base;
  const MyCredentialsPage({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = myCredentialsPageControllerProvider(profileId: profileId);
    final controller = ref.read(provider.notifier);
    // Get credentials to determine if we should show FAB or not
    final claimedCredentials = ref.watch(
      provider.select(
        (state) => state.digitalCredentials,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: RefreshIndicator(
                  onRefresh: () => controller.refreshCredentials(),
                  child: AsyncLoadingStatus(
                    controller.loadingController,
                    child: _MyCredentialsContent(profileId: profileId),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Show FAB only when there are credentials
      floatingActionButton: (claimedCredentials != null &&
              claimedCredentials.isNotEmpty)
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                final navigation = ref.read(navigationServiceProvider);
                navigation.push(ClaimCredentialsRoutePath.claimCredentialWithId(
                  profileId,
                ));
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

class _MyCredentialsContent extends ConsumerWidget {
  const _MyCredentialsContent({required this.profileId});

  final String profileId;

  void showCredentialDetailsBottomSheet(
    BuildContext context, {
    required DigitalCredential digitalCredential,
  }) {
    if (!context.mounted) return;

    ClaimedCredentialDetailsPage.show(
        context: context,
        verifiableCredential: digitalCredential.verifiableCredential);
  }

  void showDeleteCredentialDialog(
    BuildContext context, {
    required DigitalCredential digitalCredential,
    required String profileId,
  }) {
    if (!context.mounted) return;

    DeleteCredentialForm.show(
      context: context,
      digitalCredential: digitalCredential,
      profileId: profileId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final claimedCredentials = ref
        .watch(myCredentialsPageControllerProvider(profileId: profileId).select(
      (state) => state.digitalCredentials,
    ));
    final credentialServiceState =
        ref.watch(credentialServiceProvider(profileId: profileId));
    final controller = ref.watch(
        myCredentialsPageControllerProvider(profileId: profileId).notifier);

    void showCredentialOptions(DigitalCredential digitalCredential) async {
      if (!context.mounted) return;

      final selectedOption = await OptionsPicker.show(
        useRootNavigator: true,
        context: context,
        options: [
          CredentialOption.delete,
          CredentialOption.share,
        ],
        itemLeadingBuilder: (option) => SvgPicture.asset(option.svgAssetName,
            width: AppSizing.iconMedium, height: AppSizing.iconMedium),
        itemTitleBuilder: (option) => Text(localizations.option(option.name)),
      );

      log('selected: ${selectedOption?.name}', name: 'CredentialOption');

      if (!context.mounted) return;

      if (selectedOption == null) return;

      switch (selectedOption) {
        case CredentialOption.delete:
          showDeleteCredentialDialog(
            context,
            digitalCredential: digitalCredential,
            profileId: profileId,
          );
        case CredentialOption.share:
          await shareCredential(digitalCredential,
              sharePositionOrigin: context.sharePositionOrigin);
      }
    }

    if (claimedCredentials == null) {
      return SizedBox.shrink();
    }

    if (claimedCredentials.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 42.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/illustration-credentials.svg',
                width: 164, height: 81.8),
            const SizedBox(height: AppSizing.paddingLarge),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.credentialsEmptyStateDescription.substring(
                      0,
                      localizations.credentialsEmptyStateDescription.indexOf(
                          localizations.targetKeywordClaimedCredential)),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SimpleInfoWidget(
                  text: localizations.credentialsEmptyStateDescription
                      .split(' ')
                      .skip(4)
                      .join(' '),
                  dialogTitle: localizations.infoCredential,
                  dialogContent: localizations.infoCredentialDescription,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
            // Claim Credentials button at the bottom when empty
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32.0, horizontal: 32.0),
                    child: FilledButton(
                      key: Key(KeyConstants.keyClaimCredentialsButton),
                      onPressed: () {
                        final navigation = ref.read(navigationServiceProvider);
                        navigation.push(
                            ClaimCredentialsRoutePath.claimCredentialWithId(
                          profileId,
                        ));
                      },
                      child: Text(localizations.claimCredentialsTitle),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: claimedCredentials.length,
              itemBuilder: (context, index) {
                final digitalCredential = claimedCredentials[index];

                return GestureDetector(
                  onTap: () => showCredentialDetailsBottomSheet(
                    context,
                    digitalCredential: digitalCredential,
                  ),
                  child: ClaimedCredentialMediumWidget(
                    digitalCredential: digitalCredential,
                    onShowOptions: showCredentialOptions,
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSizing.paddingMedium),
            ),
          ),
          PaginationControls(
            isLoading: false,
            currentPageIndex: credentialServiceState.currentPageIndex,
            lastEvaluatedItemIdStack:
                credentialServiceState.lastEvaluatedItemIdStack,
            onPreviousPage: controller.goToPreviousPage,
            onNextPage: controller.goToNextPage,
            profileId: profileId,
          ),
        ],
      ),
    );
  }

  Future<void> shareCredential(DigitalCredential digitalCredential,
      {required Rect sharePositionOrigin}) async {
    final credentialJsonString =
        digitalCredential.verifiableCredential.toString();
    final tempDir = await getTemporaryDirectory();
    final tempFile = io.File('${tempDir.path}/credential.json');
    await tempFile.writeAsString(credentialJsonString);

    await Share.shareXFiles(
      [XFile(tempFile.path)],
      subject: 'Verifiable Credential',
      sharePositionOrigin: sharePositionOrigin,
    );

    await tempFile.delete();
  }
}
