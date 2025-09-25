import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../application/services/profile/profile_service.dart';
import '../../../../domain/models/profile/profile_type.dart';
import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';

class ProfileCard extends HookConsumerWidget {
  final Profile profile;
  final void Function(Profile profile) onSelected;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileType =
        ref.watch(profileTypeProvider(profile.profileRepositoryId));

    return Card(
      color: AppColorScheme.backgroundWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizing.paddingRegular),
      ),
      child: InkWell(
        onTap: () => onSelected(profile),
        borderRadius: BorderRadius.circular(AppSizing.paddingRegular),
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileType == ProfileType.affinidiCloud
                  ? SvgPicture.asset(
                      'assets/icons/affinidi-cloud.svg',
                      width: AppSizing.iconLarge,
                      height: AppSizing.iconLarge,
                    )
                  : SvgPicture.asset(
                      'assets/icons/drift-profile.svg',
                      width: AppSizing.iconLarge,
                      height: AppSizing.iconLarge,
                    ),
              const SizedBox(height: AppSizing.paddingMedium),
              Text(
                profile.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizing.paddingXSmall),
              if (profile.description != null &&
                  profile.description!.isNotEmpty)
                Text(
                  profile.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColorScheme.textSecondary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
