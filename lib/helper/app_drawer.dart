import 'package:flutter/material.dart';
import 'package:leetkode/helper/username_prompt.dart';
import 'package:leetkode/pages/demo_calender.dart';
import 'package:leetkode/pages/view_profile.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final Function(String) onUpdateUsername;

  const AppDrawer({
    Key? key,
    required this.username,
    required this.onUpdateUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Hey, $username',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Change username',
            ),
            onTap: () async {
              String? newUsername = await promptUsername(context);
              if (newUsername != null && newUsername.isNotEmpty) {
                onUpdateUsername(newUsername);
                saveUsername(newUsername);
              }
            },
          ),
          ListTile(
            title: const Text(
              'View Profile',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),ListTile(
            title: const Text(
              'Calender',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalenderPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
