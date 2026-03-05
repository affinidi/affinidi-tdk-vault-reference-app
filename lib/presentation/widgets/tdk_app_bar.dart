import 'package:flutter/material.dart';

import '../themes/app_color_scheme.dart';
import '../themes/app_theme.dart';

class TdkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TdkAppBar({
    super.key,
    this.elevation = 0,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.title,
    this.titleWidget,
    this.centerTitle,
    this.leadingTitle,
  });

  final double elevation;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;
  final Widget? titleWidget;
  final bool? centerTitle;
  final String? leadingTitle;

  @override
  Widget build(BuildContext context) {
    final shouldCenterTitle = centerTitle ?? !showBackButton;

    Widget? leadingWidget;
    if (showBackButton && leadingTitle != null) {
      leadingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            color: AppColorScheme.textPrimary,
          ),
          Text(leadingTitle!, style: AppTheme.headingMedium),
        ],
      );
    } else if (showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        color: AppColorScheme.textPrimary,
      );
    }

    return AppBar(
      backgroundColor: AppColorScheme.backgroundBlack,
      elevation: elevation,
      leading: leadingWidget,
      leadingWidth: leadingTitle != null ? null : 56,
      centerTitle: shouldCenterTitle,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: shouldCenterTitle
                      ? AppTheme.headingLarge
                      : AppTheme.headingMedium,
                )
              : null),
      titleSpacing: shouldCenterTitle ? null : 0,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(height: 1.0, color: AppColorScheme.divider),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
