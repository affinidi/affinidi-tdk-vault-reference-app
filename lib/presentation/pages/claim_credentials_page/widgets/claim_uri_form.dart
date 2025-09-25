import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../widgets/labeled_text_field.dart';

class ClaimUriForm extends HookConsumerWidget {
  const ClaimUriForm({
    super.key,
    required this.onSubmit,
  });

  final void Function(Uri uri) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final inputController = useTextEditingController();
    final errorText = useState<String?>(null);

    void onFetchPressed() {
      final text = inputController.text.trim();

      try {
        final uri = Uri.parse(text);
        if (!uri.hasScheme || !uri.hasAuthority) {
          throw FormatException();
        }
        errorText.value = null;
        onSubmit(uri);
      } catch (_) {
        errorText.value = localizations.errorMessage('invalidUrl');
      }
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LabeledTextField(
            controller: inputController,
            labelText: localizations.url,
            onSubmitted: (_) => onFetchPressed(),
          ),
          const SizedBox(height: 8),
          if (errorText.value != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                errorText.value!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          FilledButton(
            onPressed: onFetchPressed,
            child: Text(localizations.fetchActionText),
          ),
        ],
      ),
    );
  }
}
