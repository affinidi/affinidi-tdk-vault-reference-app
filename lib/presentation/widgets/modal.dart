import 'package:flutter/material.dart';

import '../themes/app_sizing.dart';

class Modal {
  static void open(
    BuildContext context, {
    required Widget child,
  }) {
    showGeneralDialog(
      barrierLabel: 'Dismiss',
      barrierDismissible: true,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Material(
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return child;
      },
    );
  }

  static EdgeInsets getContentPaddings() {
    return EdgeInsets.symmetric(
      vertical: AppSizing.paddingXLarge,
      horizontal: AppSizing.paddingLarge,
    );
  }
}
