import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../themes/app_sizing.dart';

class SimpleInfoWidget extends StatelessWidget {
  const SimpleInfoWidget({
    super.key,
    required this.text,
    required this.dialogTitle,
    required this.dialogContent,
    this.dialogContentSpan,
    this.textStyle,
    this.borderColor,
  });

  final String text;
  final String dialogTitle;
  final String dialogContent;
  final InlineSpan? dialogContentSpan;
  final TextStyle? textStyle;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: DottedBorder(
        color: borderColor ?? Colors.blue.shade700,
        strokeWidth: 3.0,
        dashPattern: [4, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(text, style: textStyle?.copyWith(color: Colors.white)),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSizing.paddingRegular,
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSizing.paddingRegular),
            child: dialogContentSpan != null
                ? Text.rich(dialogContentSpan!, style: TextStyle(fontSize: 20))
                : Text.rich(
                    _parseStyledText(dialogContent),
                    style: TextStyle(fontSize: 20),
                  ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _parseStyledText(String text) {
    final List<InlineSpan> spans = [];
    final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    if (spans.isEmpty) {
      return TextSpan(text: text);
    }

    return TextSpan(children: spans);
  }
}
