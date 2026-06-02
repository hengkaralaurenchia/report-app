class StringHelper {
  static String getFirstName(String fullName) {
    if (fullName.isEmpty) return '-';
    List<String> parts = fullName.split(' ');
    return parts[0];
  }
}