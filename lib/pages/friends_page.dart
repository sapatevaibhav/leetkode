// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leetkode/pages/friends_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Friends",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const FriendsList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton.extended(
          onPressed: addFriend,
          label: const Icon(
            CupertinoIcons.add,
          ),
        ),
      ),
    );
  }

void addFriend() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String username = '';
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return CupertinoAlertDialog(
              title: const Text("Add new friend"),
              content: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoTextField(
                    placeholder: 'Name',
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    style: const TextStyle(
                      color: Color.fromARGB(
                        201,
                        33,
                        149,
                        243,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoTextField(
                    placeholder: 'Username',
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    style: const TextStyle(
                      color: Color.fromARGB(
                        201,
                        33,
                        149,
                        243,
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                CupertinoButton(
                  onPressed: () async {
                    if (name.isNotEmpty && username.isNotEmpty) {
                      await _addFriendToSharedPreferences(name, username);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FriendsPage()),
                      );
                    } else {}
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addFriendToSharedPreferences(
      String name, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> friendsMap = Map<String, String>.from(
        jsonDecode(prefs.getString('friendsMap') ?? '{}'));

    friendsMap[name] = username;
    await prefs.setString('friendsMap', jsonEncode(friendsMap));
  }
}
