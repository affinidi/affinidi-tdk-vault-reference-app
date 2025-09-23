import 'package:flutter/cupertino.dart';

import '../themes/app_sizing.dart';

class BottomOptionsPicker<T> extends StatelessWidget {
  const BottomOptionsPicker({
    super.key,
    required this.options,
    required this.itemBuilder,
  });

  final List<T> options;
  final Widget? Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSizing.paddingSmall, AppSizing.paddingSmall, AppSizing.paddingSmall, AppSizing.paddingMedium),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) => itemBuilder(context, options[index]),
        ),
      ),
    );
  }
}
