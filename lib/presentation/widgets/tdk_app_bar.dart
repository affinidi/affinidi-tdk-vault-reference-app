import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../themes/app_color_scheme.dart';
import '../themes/app_sizing.dart';

class TdkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TdkAppBar({
    super.key,
    this.elevation = 0,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final double elevation;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColorScheme.backgroundWhite,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              color: AppColorScheme.textPrimary,
            )
          : null,
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/icons/tdk-logo-dark.svg',
        width: AppSizing.iconMedium,
        height: AppSizing.iconMedium,
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          color: AppColorScheme.divider,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
