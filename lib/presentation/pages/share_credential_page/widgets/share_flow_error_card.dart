import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';

/// A styled error card used throughout the share flow.
///
/// Parameters:
/// * [title] - Bold text shown in the red header strip.
/// * [message] - Body text shown below the header.
class ShareFlowErrorCard extends StatelessWidget {
  const ShareFlowErrorCard({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  static const String _closeIcon = 'assets/icons/icon_close-filled.svg';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColorScheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizing.paddingMedium,
              vertical: AppSizing.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColorScheme.error.withValues(alpha: 0.22),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  _closeIcon,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColorScheme.error,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSizing.paddingSmall),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColorScheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizing.paddingMedium),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColorScheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
