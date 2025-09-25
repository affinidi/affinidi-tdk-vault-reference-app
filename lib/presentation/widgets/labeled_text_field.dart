import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.labelText = '',
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.autofocus = true,
  });

  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String labelText;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType ?? TextInputType.name,
      decoration: InputDecoration(
        labelText: labelText,
        suffix: suffix,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );
  }
}
