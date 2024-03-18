import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchUser {
  Future<Map<String, dynamic>> fetchUserData(String user) async {
    String url = 'https://leetcode-stats-api.herokuapp.com/$user';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(
        response.body,
      );
    } else {
      throw Exception(
        'Failed to load user data',
      );
    }
  }
}
