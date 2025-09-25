class FileUploadException implements Exception {
  FileUploadException({
    required this.filesWithErrors,
    required this.total,
    required this.completed,
  });

  final Map<String, String> filesWithErrors;
  final int total;
  final int completed;
}
