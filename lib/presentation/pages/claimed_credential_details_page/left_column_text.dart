import 'package:flutter/material.dart';

class LeftColumnText extends StatelessWidget {
  const LeftColumnText({
    super.key,
    required this.fieldName,
  });

  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Text(
      fieldName,
      overflow: TextOverflow.ellipsis,
    );
  }
}
