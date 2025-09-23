import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation_provider.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigationService = ref.read(navigationServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 2), () {
        if (context.mounted) {
          navigationService.go(VaultsRoutePath.base);
        }
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppSizing.paddingXLarge, top: AppSizing.paddingXXLarge, bottom: AppSizing.paddingXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/tdk-logo-light.svg',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: AppSizing.paddingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.reference,
                    style: AppTheme.headingXLarge.copyWith(color: AppColorScheme.backgroundWhite),
                  ),
                  Text(
                    localizations.app,
                    style: AppTheme.headingLarge
                        .copyWith(color: AppColorScheme.backgroundWhite, height: 1.0, letterSpacing: -0.2),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/affinidi-vault-logo.svg',
                    width: AppSizing.iconMedium,
                    height: AppSizing.iconMedium,
                  ),
                  const SizedBox(width: AppSizing.paddingSmall),
                  Text(
                    localizations.builtWithAffinidiVaultTdk,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColorScheme.backgroundWhite, height: 1.29, letterSpacing: 0.2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
