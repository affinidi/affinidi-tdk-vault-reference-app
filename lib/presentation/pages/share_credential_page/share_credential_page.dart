import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/tdk_app_bar.dart';

import 'share_credential_page_controller.dart';

part 'share_credential_page_header.dart';

class ShareCredentialPage extends ConsumerWidget {
  const ShareCredentialPage({
    super.key,
    required this.requestJwt,
    this.clientId,
    this.requesterLogoUrl,
  });

  final String requestJwt;
  final String? clientId;

  /// Optional URL for the requester's logo. Falls back to the default
  /// Connectors asset when null or when the image fails to load.
  final String? requesterLogoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);

    ref.watch(shareCredentialPageControllerProvider(
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
                requesterLogoUrl: requesterLogoUrl,
                requesterOrigin: clientId,
                localizations: localizations,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

