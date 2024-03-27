// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:leetkode/helper/username_prompt.dart';
import 'package:leetkode/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  FetchUser fetchUser = FetchUser();

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
      return;
    }
    Map<String, dynamic> userData =
        await fetchUser.fetchUserData(savedUsername);

    await saveDataToSharedPreferences(savedUsername, userData);

    List<String>? friendsList = await loadFriendsList();
    if (friendsList == null || friendsList.isEmpty) {
      return;
    }
    for (String friendUsername in friendsList) {
      Map<String, dynamic> friendUserData =
          await fetchUser.fetchUserData(friendUsername);

      await saveDataToSharedPreferences(friendUsername, friendUserData);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> saveDataToSharedPreferences(
      String username, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (kDebugMode && data.isNotEmpty) {
      log('Storing data for username: $username success');
    }

    await prefs.setString(username, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
