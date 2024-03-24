import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leetkode/pages/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  Map<String, String> _friendsMap = {};

  @override
  void initState() {
    super.initState();
    _loadFriendsList();
  }

  Future<void> _loadFriendsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _friendsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('friendsMap') ?? '{}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_friendsMap.isEmpty) {
      return const Center(
        child: Text(
          "LOL\nYou don't have any friend",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _friendsMap.length,
      itemBuilder: (context, index) {
        final List<String> names = _friendsMap.keys.toList();
        final String name = names[index];
        final String username = _friendsMap[name]!;
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  initialUsername: username,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(
              94,
              255,
              193,
              7,
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () => deleteUser(name),
            child: const Icon(
              CupertinoIcons.delete,
            ),
          ),
          title: Text(
            username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            name,
          ),
        );
      },
    );
  }

  void deleteUser(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Friend"),
          content: Text("Are you sure you want to delete $name?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteFriendFromSharedPreferences(name);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFriendFromSharedPreferences(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> friendsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('friendsMap') ?? '{}'));
    friendsMap.remove(name);
    await prefs.setString('friendsMap', jsonEncode(friendsMap));
    setState(() {
      _friendsMap = friendsMap;
    });
  }
}
