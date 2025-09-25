import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloudIndicator extends StatelessWidget {
  final double size;

  const CloudIndicator({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    String iconPath = 'assets/icons/cloud_indicator.svg';

    return SvgPicture.asset(
      iconPath,
      semanticsLabel: 'Cloud indicator',
      width: size,
      height: size,
    );
  }
}
