// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:leetkode/helper/username_prompt.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:leetkode/helper/data_fetch.dart'; // Import other dependencies as needed

// Future<void> fetchDataAndNavigate(BuildContext context) async {
//   // Fetch user data
//   String? savedUsername = await loadUsername();
//   if (savedUsername == null || savedUsername.isEmpty) {
//     // Handle the case where the username is not available
//     return;
//   }
//   Map<String, dynamic> userData = await fetchUser.fetchUserData(savedUsername);

//   // Save user data to SharedPreferences
//   await saveDataToSharedPreferences(savedUsername, userData);

//   // Fetch friend's data
//   List<String>? friendsList = await loadFriendsList();
//   if (friendsList == null || friendsList.isEmpty) {
//     // Handle the case where the friend's list is not available
//     return;
//   }
//   for (String friendUsername in friendsList) {
//     Map<String, dynamic> friendUserData =
//         await fetchUser.fetchUserData(friendUsername);
//     // Save each friend's data separately
//     await saveDataToSharedPreferences(friendUsername, friendUserData);
//   }

//   // Navigate to the home screen after saving data
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => const HomePage()),
//   );
// }
