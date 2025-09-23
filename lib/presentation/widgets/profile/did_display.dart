import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';

class DidDisplay extends StatelessWidget {
  const DidDisplay({super.key, required this.did});

  final String did;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)?.didLabel(did) ?? 'DID: $did',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Color(0xFF9B9CA7), height: 1.33, letterSpacing: 0.2),
            overflow: TextOverflow.ellipsis,
            semanticsLabel:
                AppLocalizations.of(context)?.didLabel(did) ?? 'DID: $did',
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.copy_outlined,
            size: AppSizing.iconMedium,
            color: AppColorScheme.backgroundDark,
          ),
          tooltip: AppLocalizations.of(context)?.copy ?? 'Copy',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: did));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.copiedToClipboard)),
              );
            }
          },
        ),
      ],
    );
  }
}
