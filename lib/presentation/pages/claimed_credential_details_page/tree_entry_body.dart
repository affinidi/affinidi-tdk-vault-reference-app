import 'package:flutter/material.dart';

import '../../themes/app_sizing.dart';
import 'left_column_text.dart';
import 'right_column_text.dart';

class TreeEntryBody extends StatelessWidget {
  final String fieldName;
  final dynamic fieldValue;
  final bool isHidden;
  final double rightColumnWidth;

  const TreeEntryBody({
    super.key,
    required this.fieldName,
    required this.fieldValue,
    this.isHidden = false,
    required this.rightColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    return isHidden
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(
                left: AppSizing.paddingXSmall, top: AppSizing.paddingRegular, bottom: AppSizing.paddingRegular),
            child: Row(
              children: [
                Expanded(
                  child: LeftColumnText(fieldName: fieldName),
                ),
                SizedBox(
                  width: rightColumnWidth,
                  child: fieldValue is String ? RightColumnText(fieldValue: fieldValue) : fieldValue,
                ),
              ],
            ),
          );
  }
}
