import 'package:flutter/widgets.dart';

extension BuildContextSharePositionOrigin on BuildContext {
  Rect get sharePositionOrigin {
    final box = findRenderObject() as RenderBox?;
    final positionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : Rect.fromCenter(center: Offset.zero, width: 0, height: 0);
    return positionOrigin;
  }
}
