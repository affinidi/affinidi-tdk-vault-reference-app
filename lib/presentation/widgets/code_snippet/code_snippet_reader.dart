import 'package:flutter/services.dart';
import '../../../infrastructure/utils/github_utils.dart';
import '../../../l10n/app_localizations.dart';

class CodeSnippetReader {
  static Future<String> readLines(String filePath, int startLine, int endLine, AppLocalizations localizations) async {
    try {
      final content = isRemoteContent(filePath)
          ? await GitHubUtils.fetchRawContent(filePath)
          : await _loadStringFromLocal(filePath);

      final result = _extractLines(content, startLine, endLine);
      return result;
    } catch (e) {
      return '${localizations.errorLoadingCodeSnippetsMessage}: $e';
    }
  }

  static bool isRemoteContent(String filePath) {
    return GitHubUtils.isGitHubUrl(filePath);
  }

  static String _normalizeLocalPath(String filePath) {
    return filePath.startsWith('lib/') ? filePath : 'lib/$filePath';
  }

  static String _extractLines(String content, int startLine, int endLine) {
    final lines = content.split('\n');
    final start = (startLine - 1).clamp(0, lines.length);
    final end = endLine.clamp(0, lines.length);

    if (start >= end) return '';

    return lines.sublist(start, end).join('\n');
  }

  static Future<String> _loadStringFromLocal(String filePath) async {
    final normalizedPath = _normalizeLocalPath(filePath);
    final content = await rootBundle.loadString(normalizedPath);

    return content;
  }
}

class CodeSnippetLocation {
  const CodeSnippetLocation({
    required this.filePath,
    required this.startLine,
    required this.endLine,
    required this.description,
  });

  final String filePath;
  final int startLine;
  final int endLine;
  final String description;

  Future<String> getCode(AppLocalizations localizations) async {
    return CodeSnippetReader.readLines(filePath, startLine, endLine, localizations);
  }
}
