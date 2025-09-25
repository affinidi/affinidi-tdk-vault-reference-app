import 'package:flutter/material.dart';

import '../../widgets/bottom_options_picker.dart';

class OptionsPicker<T> extends StatelessWidget {
  const OptionsPicker(this.options,
      {super.key, this.itemTitleBuilder, this.itemLeadingBuilder});
  final List<T> options;
  final Widget Function(T)? itemTitleBuilder;
  final Widget Function(T)? itemLeadingBuilder;

  static Future<T?> show<T>({
    required BuildContext context,
    bool useRootNavigator = false,
    required List<T> options,
    required Widget Function(T)? itemTitleBuilder,
    Widget Function(T)? itemLeadingBuilder,
  }) =>
      showModalBottomSheet<T>(
        useRootNavigator: true,
        context: context,
        builder: (context) => OptionsPicker(
          options,
          itemTitleBuilder: itemTitleBuilder,
          itemLeadingBuilder: itemLeadingBuilder,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BottomOptionsPicker<T>(
      options: options,
      itemBuilder: (context, option) => ListTile(
        onTap: () => Navigator.of(context).pop(option),
        leading: itemLeadingBuilder?.call(option),
        title: itemTitleBuilder?.call(option),
      ),
    );
  }
}
