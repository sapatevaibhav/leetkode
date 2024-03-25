import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leetkode/helper/username_prompt.dart';
import 'package:leetkode/pages/compare_all.dart';
import 'package:leetkode/pages/demo_calender.dart';
import 'package:leetkode/pages/friends_page.dart';
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
            // decoration:  BoxDecoration(
            //   // color: Colors.lightBlue[100],
            // ),
            // child: Center(
            child: Text(
              'Hey,\n $username',
              style: const TextStyle(
                // color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.pen,
            ),
            title: const Text(
              'Change username',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
            leading: const Icon(
              CupertinoIcons.person,
            ),
            title: const Text(
              'View Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.calendar,
            ),
            title: const Text(
              'Calender',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalenderPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.person_3_fill,
            ),
            title: const Text(
              'Friends',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.uiwindow_split_2x1,
            ),
            title: const Text(
              'Compare',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComparePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
