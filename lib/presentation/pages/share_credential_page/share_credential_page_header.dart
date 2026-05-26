part of 'share_credential_page.dart';

class _ShareFlowHeader extends StatelessWidget {
  const _ShareFlowHeader({
    required this.localizations,
    this.requesterLogoUrl,
    this.requesterOrigin,
  });

  final String? requesterLogoUrl;
  final String? requesterOrigin;
  final AppLocalizations localizations;

  static const double _logoSize = 48;
  static const double _lineWidth = 32;
  static const double _swapWidth = 20;
  static const double _connectorSpanWidth = AppSizing.paddingSmall * 4 +
      _lineWidth * 2 +
      _swapWidth;
  static const double _labelWidth = 120;
  static const double _labelConnectorSpanWidth =
      _connectorSpanWidth - (_labelWidth - _logoSize);
  static const String _connectorsAsset = 'assets/images/Logos - Connectors.svg';
  static const String _lineAsset = 'assets/images/line.svg';
  static const String _swapAsset = 'assets/images/icon_swap-horiz.svg';

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColorScheme.textSecondary,
        );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Images row
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _RequesterLogo(logoUrl: requesterLogoUrl, size: _logoSize),
              const SizedBox(width: AppSizing.paddingSmall),
              SvgPicture.asset(_lineAsset),
              const SizedBox(width: AppSizing.paddingSmall),
              SvgPicture.asset(
                _swapAsset,
                colorFilter: const ColorFilter.mode(
                  AppColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSizing.paddingSmall),
              SvgPicture.asset(_lineAsset),
              const SizedBox(width: AppSizing.paddingSmall),
              SvgPicture.asset(
                _connectorsAsset,
                width: _logoSize,
                height: _logoSize,
              ),
            ],
          ),
          const SizedBox(height: AppSizing.paddingSmall),
          // Labels row — mirrors the image row so each label is centered
          // directly below its logo.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _labelWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        requesterOrigin ?? localizations.unknownOrigin,
                        style: labelStyle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      // TODO: handle requester info tap
                      onTap: () {},
                      child: Icon(
                        Icons.info_outline,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: _labelConnectorSpanWidth),
              SizedBox(
                width: _labelWidth,
                child: Text(
                  localizations.referenceApp,
                  style: labelStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequesterLogo extends StatelessWidget {
  const _RequesterLogo({required this.size, this.logoUrl});

  final double size;
  final String? logoUrl;

  static const String _fallbackAsset = 'assets/images/Logos - Connectors.svg';

  @override
  Widget build(BuildContext context) {
    if (logoUrl == null || logoUrl!.isEmpty) {
      return SvgPicture.asset(_fallbackAsset, width: size, height: size);
    }

    return Image.network(
      logoUrl!,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          SvgPicture.asset(_fallbackAsset, width: size, height: size),
    );
  }
}
