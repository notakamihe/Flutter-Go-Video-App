class Utils {
  static String normalizeUrl (String url) {
    return url.split("\\").join("/");
  }
}