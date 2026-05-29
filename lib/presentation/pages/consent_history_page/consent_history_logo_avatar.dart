import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConsentHistoryLogoAvatar extends StatelessWidget {
  const ConsentHistoryLogoAvatar({super.key, required this.logoUrl});

  final String? logoUrl;

  static const double _size = 24;
  static const String _fallbackAsset = 'assets/images/Logos - Connectors.svg';

  @override
  Widget build(BuildContext context) {
    if (logoUrl == null || logoUrl!.isEmpty) {
      return const _ConsentHistoryLogoFallback();
    }

    return Image.network(
      logoUrl!,
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          const _ConsentHistoryLogoFallback(),
    );
  }
}

class _ConsentHistoryLogoFallback extends StatelessWidget {
  const _ConsentHistoryLogoFallback();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      ConsentHistoryLogoAvatar._fallbackAsset,
      width: ConsentHistoryLogoAvatar._size,
      height: ConsentHistoryLogoAvatar._size,
    );
  }
}
