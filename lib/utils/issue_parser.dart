Map<String, String> parseHistoryEntry(String entry) {
  Map<String, String> parsed = {};
  List<String> submissionParts = entry.split('<submission_status>');
  String mainEntry = submissionParts[0];
  parsed['submission_status'] = submissionParts.length > 1 ? submissionParts[1] : 'unknown';

  List<String> parts = mainEntry.split(', ');
  
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