import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';

/// A labelled obscured text-field that follows the app's dark-theme design.
///
/// Parameters:
/// * [label] - Text rendered above the input box.
/// * [hint] - Placeholder shown when the field is empty.
/// * [controller] - Optional external [TextEditingController].
/// * [errorText] - Validation error shown below the box. Pass `null` to hide.
/// * [onSubmitted] - Called when the user submits the field (keyboard action).
class LabelTextField extends HookWidget {
  const LabelTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.onSubmitted,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);
    final isFocused = useState(false);

    final borderColor = isFocused.value
        ? AppColorScheme.backgroundWhite
        : AppColorScheme.formFieldBorderUnfocused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColorScheme.textSecondary,
              ),
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        SizedBox(
          height: AppSizing.iconXXLarge,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(AppSizing.paddingXSmall),
            ),
            child: Focus(
              onFocusChange: (hasFocus) => isFocused.value = hasFocus,
              child: TextField(
                controller: controller,
                obscureText: obscure.value,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyMedium,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColorScheme.textSecondary,
                      ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizing.paddingMedium,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColorScheme.textSecondary,
                      size: AppSizing.iconSmall,
                    ),
                    onPressed: () => obscure.value = !obscure.value,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSizing.paddingSmall),
          Text(
            errorText!,
            style: TextStyle(
              color: AppColorScheme.error,
              fontSize: AppSizing.fontMedium,
            ),
          ),
        ],
      ],
    );
  }
}
