import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';

/// A labelled dropdown selector that follows the app's dark-theme design.
///
/// Parameters:
/// * [label] - Text rendered above the dropdown box.
/// * [items] - The list of selectable menu items.
/// * [value] - Currently selected value. Pass `null` to show [hint].
/// * [hint] - Placeholder text shown when [value] is `null`.
/// * [onChanged] - Called when the user selects an item.
class LabelDropdown<T> extends HookWidget {
  const LabelDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.hint,
    this.onChanged,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? hint;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final isOpen = useState(false);

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
        LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColorScheme.formFieldBorderUnfocused,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  padding: EdgeInsets.zero,
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    menuWidth: constraints.maxWidth,
                    style: Theme.of(context).textTheme.bodyMedium,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isOpen.value ? Icons.expand_less : Icons.expand_more,
                      color: AppColorScheme.textSecondary,
                    ),
                    hint: hint != null
                        ? Text(
                            hint!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColorScheme.textSecondary,
                                ),
                          )
                        : null,
                    onTap: () => isOpen.value = true,
                    onChanged: (value) {
                      isOpen.value = false;
                      onChanged?.call(value);
                    },
                    items: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
