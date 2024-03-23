import 'package:flutter/material.dart';
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

Future<String?> loadUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(
    'username',
  );
}

Future<void> saveUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(
    'username',
    username,
  );
}
