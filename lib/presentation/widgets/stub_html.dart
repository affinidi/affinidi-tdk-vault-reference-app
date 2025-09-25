// Stub file for non-web platforms
class Blob {
  Blob(List<dynamic> data);
}

class Url {
  static String createObjectUrl(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class Window {
  void open(String url, String target) {}
}

final window = Window();
