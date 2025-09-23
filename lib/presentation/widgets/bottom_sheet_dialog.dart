import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/app_sizing.dart';

class BottomSheetDialog extends StatelessWidget {
  const BottomSheetDialog({
    super.key,
    this.title,
    this.titleStyle,
    required this.actions,
    required this.body,
    this.onCancel,
    this.actionsAlignment = MainAxisAlignment.spaceBetween,
  });

  final void Function()? onCancel;
  final String? title;
  final TextStyle? titleStyle;
  final Widget body;
  final List<Widget> actions;
  final MainAxisAlignment actionsAlignment;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizing.paddingMedium),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: (title != null && title!.isNotEmpty) ? EdgeInsets.only(top: 56) : EdgeInsets.zero,
                child: Container(
                  color: theme.colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizing.paddingLarge, vertical: AppSizing.paddingXLarge),
                        child: body,
                      ),
                      if (actions.isNotEmpty) ...[
                        Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizing.paddingLarge, vertical: AppSizing.paddingMedium),
                          child: Row(
                            mainAxisAlignment: actionsAlignment,
                            children: actions,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              if (title != null && title!.isNotEmpty)
                Positioned(
                  top: MediaQuery.viewInsetsOf(context).top,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: theme.colorScheme.surface,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(AppSizing.paddingLarge, AppSizing.paddingSmall,
                              AppSizing.paddingSmall, AppSizing.paddingXSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title!, style: titleStyle ?? Theme.of(context).textTheme.headlineSmall),
                              IconButton(onPressed: onCancel, icon: SvgPicture.asset('assets/icons/icon-close.svg'))
                            ],
                          ),
                        ),
                        Divider(height: 1),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
