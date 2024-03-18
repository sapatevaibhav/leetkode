import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String username;

  const AppDrawer({Key? key, required this.username})
      : super(
          key: key,
        );

  @override
  Widget build(
    BuildContext context,
  ) {
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
              'Settings',
            ),
            onTap: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ],
      ),
    );
  }
}
