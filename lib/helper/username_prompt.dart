// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> promptUsername(BuildContext context) async {
  TextEditingController usernameController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return AlertDialog(
        title: const Text(
          'Enter your LeetCode username',
        ),
        content: TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            hintText: 'Username',
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              String enteredUsername = usernameController.text;

              if (enteredUsername.isNotEmpty) {
                Navigator.of(context).pop(
                  enteredUsername,
                );
              }
            },
            child: const Text(
              'Submit',
            ),
          ),
        ],
      );
    },
  );
}

Future<void> saveUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'username',
    username,
  );
}

Future<void> saveUserData(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'userData',
    jsonEncode(userData),
  );
}

Future<void> updateUsernameAndFetchData(BuildContext context) async {
  String? newUsername = await promptUsername(context);
  if (newUsername != null) {
    try {
      FetchUser fetchUser = FetchUser();
      Map<String, dynamic> userData =
          await fetchUser.fetchUserData(newUsername);
      await saveUsername(newUsername);
      await saveUserData(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username updated successfully'),
        ),
      );
    } catch (e) {
      log('Error updating username: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update username'),
        ),
      );
    }
  }
}

Future<String?> loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(
    'username',
  );
}
