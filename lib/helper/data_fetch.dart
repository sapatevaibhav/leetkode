// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class DataFetcher {
//   Future<Map<String, dynamic>> fetchUserData(String username) async {
//     String url = 'https://leetcode-stats-api.herokuapp.com/$username';
//     http.Response response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> userData = json.decode(response.body);
//       return userData;
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   }

//   Future<String> loadUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('username') ?? '';
//   }

//   Future<void> saveUsername(String username) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('username', username);
//   }
// }
