// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:leetkode/helper/username_prompt.dart';
import 'package:leetkode/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  FetchUser fetchUser = FetchUser();
  List<String> friendUsernames = [];

  @override
  void initState() {
    super.initState();
    fetchDataAndNavigate();
  }

  Future<List<String>?> loadFriendsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> friendsMap =
        jsonDecode(prefs.getString('friendsMap') ?? '{}');

    List<String> friendsList =
        friendsMap.values.map((dynamic value) => value.toString()).toList();

    return friendsList.isNotEmpty ? friendsList : null;
  }

  Future<void> fetchDataAndNavigate() async {
    String? savedUsername = await loadUsername();

    if (savedUsername == null || savedUsername.isEmpty) {
      navigateToHomeScreen();
      return;
    }

    Map<String, dynamic> userData =
        await fetchUser.fetchUserData(savedUsername);
    await saveDataToSharedPreferences(savedUsername, userData);

    List<String>? friendsList = await loadFriendsList();

    if (friendsList == null || friendsList.isEmpty) {
      navigateToHomeScreen();
      return;
    }

    for (String friendUsername in friendsList) {
      if (kDebugMode) {
        debugPrint('Loading data for: $friendUsername');
      }
      Map<String, dynamic> friendUserData =
          await fetchUser.fetchUserData(friendUsername);
      await saveDataToSharedPreferences(friendUsername, friendUserData);

      setState(() {
        friendUsernames.add(friendUsername);
      });
    }

    navigateToHomeScreen();
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> saveDataToSharedPreferences(
      String username, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (kDebugMode && data.isNotEmpty) {
      debugPrint('Storing data for username: $username success');
    }

    await prefs.setString(username, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: loadUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final savedUsername = snapshot.data ?? 'Your Username';
                  return Text(
                    'Loading data for: $savedUsername',
                    style: const TextStyle(fontSize: 16),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            if (friendUsernames.isNotEmpty)
              Column(
                children: friendUsernames.map((username) {
                  return Text(
                    'Loading data for: $username',
                    style: const TextStyle(fontSize: 16),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
