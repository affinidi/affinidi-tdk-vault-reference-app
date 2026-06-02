import 'package:flutter/material.dart';

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
class LabelTextField extends StatefulWidget {
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
  State<LabelTextField> createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {
  bool _obscure = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = _isFocused
        ? AppColorScheme.backgroundWhite
        : AppColorScheme.formFieldBorderUnfocused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColorScheme.textSecondary,
              ),
        ),
        const SizedBox(height: AppSizing.paddingSmall),
        SizedBox(
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Focus(
              onFocusChange: (hasFocus) =>
                  setState(() => _isFocused = hasFocus),
              child: TextField(
                controller: widget.controller,
                obscureText: _obscure,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyMedium,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColorScheme.textSecondary,
                      ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizing.paddingMedium,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColorScheme.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSizing.paddingSmall),
          Text(
            widget.errorText!,
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
