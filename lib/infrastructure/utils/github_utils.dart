import 'package:http/http.dart' as http;
import 'constants.dart';

/// Utility class for handling GitHub-related operations
class GitHubUtils {
  GitHubUtils._();

  /// Converts GitHub web URLs to raw content URLs
  ///
  /// Example: https://github.com/user/repo/blob/branch/path/file.dart
  /// To: https://raw.githubusercontent.com/user/repo/branch/path/file.dart
  static String convertToRawUrl(String githubUrl) {
    // Use configured URLs for replacement
    if (AppConfig.githubRawUrl.isNotEmpty && AppConfig.githubUrl.isNotEmpty) {
      return githubUrl.replaceFirst(AppConfig.githubUrl, AppConfig.githubRawUrl);
    }

    // Fallback: Convert GitHub web URLs to raw URLs
    if (githubUrl.contains('github.com') && githubUrl.contains('/blob/')) {
      return githubUrl.replaceFirst('github.com', 'raw.githubusercontent.com').replaceFirst('/blob/', '/');
    }

    return githubUrl;
  }

  /// Fetches raw content from a GitHub URL
  ///
  /// Throws an exception if the content is HTML instead of raw content
  static Future<String> fetchRawContent(String githubUrl) async {
    try {
      final rawUrl = convertToRawUrl(githubUrl);
      final response = await http.get(Uri.parse(rawUrl));

      if (response.statusCode == 200) {
        final content = response.body;

        // Validate that we received raw content, not HTML
        if (_isHtmlContent(content)) {
          throw GitHubContentException(
            'Received HTML content instead of raw file content. URL: $rawUrl',
            originalUrl: githubUrl,
            rawUrl: rawUrl,
          );
        }

        return content;
      } else {
        throw GitHubContentException(
          'Failed to load content from GitHub: ${response.statusCode}. URL: $rawUrl',
          originalUrl: githubUrl,
          rawUrl: rawUrl,
        );
      }
    } catch (e) {
      if (e is GitHubContentException) {
        rethrow;
      }
      throw GitHubContentException(
        'Error fetching content from GitHub: $e',
        originalUrl: githubUrl,
        rawUrl: convertToRawUrl(githubUrl),
      );
    }
  }

  /// Checks if the content is HTML instead of raw content
  static bool _isHtmlContent(String content) {
    final trimmedContent = content.trim();
    return trimmedContent.startsWith('<!DOCTYPE html>') ||
        trimmedContent.startsWith('<html') ||
        content.contains('<head>') ||
        content.contains('<meta');
  }

  /// Checks if a URL is a GitHub URL
  static bool isGitHubUrl(String url) {
    return url.startsWith('https://github.com/') || url.startsWith('https://raw.githubusercontent.com/');
  }
}

/// Exception thrown when GitHub content operations fail
class GitHubContentException implements Exception {
  const GitHubContentException(
    this.message, {
    required this.originalUrl,
    required this.rawUrl,
  });

  final String message;
  final String originalUrl;
  final String rawUrl;

  @override
  String toString() => 'GitHubContentException: $message';
}
