class Patch {
  final String path;
  final Map<String, String>? headers;
  const Patch({this.headers, this.path = ""});
}
