import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:ssi/ssi.dart';

import '../../../infrastructure/extensions/veryfiable_credential_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/tdk_app_bar.dart';
import '../claimed_credential_details_page/claimed_credential_details_page.dart';

import 'share_credential_page_controller.dart';
import 'widgets/label_text_field.dart';
import 'widgets/label_dropdown.dart';
import 'widgets/share_credential_item.dart';
import 'widgets/share_flow_error_card.dart';

part 'share_credential_page_header.dart';
part 'share_credential_page_body.dart';
part 'share_credential_page_vault_selection.dart';
part 'share_credential_page_credential_list.dart';
part 'share_credential_page_action_bar.dart';

class ShareCredentialPage extends ConsumerWidget {
  const ShareCredentialPage({
    super.key,
    required this.requestJwt,
    this.clientId,
  });

  final String requestJwt;
  final String? clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);

    final state = ref.watch(shareCredentialPageControllerProvider(
      requestJwt: requestJwt,
      clientId: clientId,
    ));

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      appBar: TdkAppBar(
        title: localizations.shareYourData,
        showBackButton: true,
        onBackPressed: () => navigation.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSizing.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ShareFlowHeader(
                verifierMetadata: state.verifierMetadata,
                localizations: localizations,
              ),
              const SizedBox(height: AppSizing.paddingMedium),
              const Divider(color: AppColorScheme.divider),
              const SizedBox(height: AppSizing.paddingLarge),
              Expanded(
                child: _SharePageBody(
                  requestJwt: requestJwt,
                  clientId: clientId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
