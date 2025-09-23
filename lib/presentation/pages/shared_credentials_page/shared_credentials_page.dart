import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/services/credential/credential_service.dart';
import '../../../infrastructure/extensions/build_context_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../dialogs/options_picker/credential_option.dart';
import '../../dialogs/options_picker/options_picker.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/claimed_credential_medium_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_status/async_loading_status.dart';
import '../../widgets/pagination_controls.dart';
import '../claimed_credential_details_page/claimed_credential_details_page.dart';

import 'shared_credentials_page_controller.dart';

class SharedCredentialsPage extends HookConsumerWidget {
  static String get routePath => MyCredentialsRoutePath.base;
  const SharedCredentialsPage({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = sharedCredentialsPageControllerProvider(profileId: profileId);
    final controller = ref.read(provider.notifier);

    return Scaffold(
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
      verifiableCredential: digitalCredential.verifiableCredential,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final claimedCredentials = ref.watch(sharedCredentialsPageControllerProvider(profileId: profileId).select(
      (state) => state.digitalCredentials,
    ));
    final credentialServiceState = ref.watch(credentialServiceProvider(profileId: profileId));
    final controller = ref.watch(sharedCredentialsPageControllerProvider(profileId: profileId).notifier);

    void showCredentialOptions(DigitalCredential digitalCredential) async {
      if (!context.mounted) return;

      final selectedOption = await OptionsPicker.show(
        useRootNavigator: true,
        context: context,
        options: [
          CredentialOption.share,
        ],
        itemLeadingBuilder: (option) =>
            SvgPicture.asset(option.svgAssetName, width: AppSizing.iconMedium, height: AppSizing.iconMedium),
        itemTitleBuilder: (option) => Text(localizations.option(option.name)),
      );

      log('selected: ${selectedOption?.name}', name: 'CredentialOption');

      if (!context.mounted) return;

      if (selectedOption == null) return;

      switch (selectedOption) {
        default:
          await shareCredential(digitalCredential, sharePositionOrigin: context.sharePositionOrigin);
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
            EmptyStateWidget(
              description: localizations.credentialsEmptyStateDescription,
              image: SvgPicture.asset('assets/images/illustration-credentials.svg', width: 164, height: 81.8),
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
              separatorBuilder: (context, index) => SizedBox(height: AppSizing.paddingMedium),
            ),
          ),
          PaginationControls(
            isLoading: false,
            currentPageIndex: credentialServiceState.currentPageIndex,
            lastEvaluatedItemIdStack: credentialServiceState.lastEvaluatedItemIdStack,
            onPreviousPage: controller.goToPreviousPage,
            onNextPage: controller.goToNextPage,
            profileId: profileId,
          ),
        ],
      ),
    );
  }

  Future<void> shareCredential(DigitalCredential digitalCredential, {required Rect sharePositionOrigin}) async {
    final credentialJsonString = digitalCredential.verifiableCredential.toString();
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
