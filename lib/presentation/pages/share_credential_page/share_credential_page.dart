import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/tdk_app_bar.dart';

import 'share_credential_page_controller.dart';

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizing.paddingLarge),
            child: Text(
              localizations.shareYourData,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColorScheme.textSecondary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
