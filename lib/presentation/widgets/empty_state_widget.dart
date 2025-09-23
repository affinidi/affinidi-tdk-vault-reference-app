import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget(
      {super.key, required this.description, required this.image});

  final String description;
  final SvgPicture image;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        image,
        Text(description),
      ],
    );
  }
}
