import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../l10n/app_localizations.dart';

import 'labeled_text_field.dart';

class PassphraseTextField extends HookWidget {
  const PassphraseTextField({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final shouldObscureText = useState(true);

    return LabeledTextField(
      controller: controller,
      labelText: localizations.enterPassphrase,
      obscureText: shouldObscureText.value,
      keyboardType: TextInputType.visiblePassword,
      errorText: errorText,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      suffix: InkWell(
        onTap: () => shouldObscureText.value = !shouldObscureText.value,
        child: Icon(
          shouldObscureText.value
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
      autofocus: true,
    );
  }
}
