import 'dart:developer';

Map<String, int> convertToMapOfInt(Map<String, dynamic>? data) {
  if (data == null || data.isEmpty) {
    log('Submission Calendar Data is null or empty');
    return {};
  }

  Map<String, int> result = {};
  data.forEach((key, value) {
    result[key] = value as int;
  });

  return result;
}
