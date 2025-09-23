import 'package:flutter/material.dart';

class SimpleInfoWidget extends StatelessWidget {
  const SimpleInfoWidget({
    super.key,
    required this.text,
    required this.dialogTitle,
    required this.dialogContent,
    this.textStyle,
    this.borderColor,
  });

  final String text;
  final String dialogTitle;
  final String dialogContent;
  final TextStyle? textStyle;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: Text(
        text,
        style: textStyle?.copyWith(
          color: Colors.blue.shade700,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue.shade700,
          decorationThickness: 1.0,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
