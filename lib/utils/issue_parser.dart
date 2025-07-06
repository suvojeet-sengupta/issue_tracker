Map<String, String> parseHistoryEntry(String entry) {
  Map<String, String> parsed = {};
  List<String> parts = entry.split(', ');
  
  for (String part in parts) {
    List<String> keyValue = part.split(': ');
    if (keyValue.length >= 2) {
      String key = keyValue[0];
      String value = keyValue.sublist(1).join(': ');
      parsed[key] = value;
    }
  }
  
  return parsed;
}