import 'package:flutter/material.dart';

class RightColumnText extends StatelessWidget {
  const RightColumnText({
    super.key,
    required this.fieldValue,
  });

  final String fieldValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      fieldValue,
      maxLines: 1,
      style: TextStyle(
        fontSize: 12,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
