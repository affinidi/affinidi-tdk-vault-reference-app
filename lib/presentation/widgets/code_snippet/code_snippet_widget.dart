import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import 'code_snippet_reader.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class CodeSnippetWidget extends StatelessWidget {
  const CodeSnippetWidget({
    super.key,
    this.codeSnippets,
    this.codeLocations,
    this.title = 'Code Snippets',
  });

  final Map<String, String>? codeSnippets;
  final List<CodeSnippetLocation>? codeLocations;
  final String title;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return IconButton(
      icon: const Icon(Icons.code),
      onPressed: () => _showCodeSnippetOverlay(context),
      tooltip: localizations.viewCodeSnippetsActionText,
    );
  }

  void _showCodeSnippetOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CodeSnippetOverlay(
        codeSnippets: codeSnippets,
        codeLocations: codeLocations,
        title: title,
      ),
    );
  }
}

class _CodeSnippetOverlay extends StatefulWidget {
  const _CodeSnippetOverlay({
    this.codeSnippets,
    this.codeLocations,
    required this.title,
  });

  final Map<String, String>? codeSnippets;
  final List<CodeSnippetLocation>? codeLocations;
  final String title;

  @override
  State<_CodeSnippetOverlay> createState() => _CodeSnippetOverlayState();
}

class _CodeSnippetOverlayState extends State<_CodeSnippetOverlay> {
  CodeController? codeController;
  bool isLoading = true;
  bool isCodeCopied = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCode().catchError((error) {});
  }

  Future<void> _loadCode() async {
    final localizations = AppLocalizations.of(context)!;
    try {
      String allCode = '';

      if (widget.codeSnippets != null) {
        allCode = widget.codeSnippets!.values.join('\n\n');
      } else if (widget.codeLocations != null) {
        final codeParts = <String>[];
        for (final location in widget.codeLocations!) {
          try {
            final code = await location.getCode(localizations).timeout(
                  const Duration(seconds: 5),
                  onTimeout: () => '${localizations.timeoutLoadingCodeMessage} ${location.filePath}',
                );

            codeParts.add(
                ' /*****\n  Purpose: ${location.description}\n  Location: ${location.filePath}#L${location.startLine}\n *****/');
            codeParts.add(code);
          } catch (e) {
            codeParts.add('${localizations.errorLoadingCodeMessage} ${location.filePath}: $e');
          }
        }
        allCode = codeParts.join('\n\n');
      }

      if (mounted) {
        setState(() {
          codeController = CodeController(
            text: allCode,
            language: dart,
          );
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          codeController = CodeController(
            text: '${localizations.errorLoadingCodeSnippetsMessage}: $e',
            language: dart,
          );
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColorScheme.backgroundWhite,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizing.paddingMedium),
              decoration: BoxDecoration(
                color: AppColorScheme.backgroundWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppColorScheme.divider,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTheme.headingMedium,
                    ),
                  ),
                  IconButton(
                    icon: Icon(isCodeCopied ? Icons.check : Icons.copy),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: codeController!.text));
                      setState(() {
                        isCodeCopied = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(AppSizing.paddingMedium),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColorScheme.divider,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CodeTheme(
                            data: CodeThemeData(styles: monokaiSublimeTheme),
                            child: CodeField(
                              controller: codeController!,
                              readOnly: true,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white, fontFamily: 'SourceCode'),
                              gutterStyle: GutterStyle.none,
                              expands: true,
                            ),
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
