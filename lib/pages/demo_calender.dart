// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:leetkode/helper/maptoint.dart';
import 'package:leetkode/widgets/submission_calender.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  CalenderPageState createState() => CalenderPageState();
}

class CalenderPageState extends State<CalenderPage> {
  final TextEditingController _usernameController = TextEditingController();
  String username = '';
  Map<String, dynamic>? _userData;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUsernameFromSharedPreferences();
  }

  void _loadUsernameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    // log(storedUsername!);
    if (storedUsername != null) {
      setState(() {
        username = storedUsername;
        _usernameController.text = storedUsername;
      });
      _loadUserDataFromSharedPreferences(storedUsername);
    }
  }

  void _loadUserDataFromSharedPreferences(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        _userData = userData;
        if (_userData != null && _userData!['submissionCalendar'] != null) {
          convertToMapOfInt(_userData!['submissionCalendar']);
          _isDataLoaded = true;
        } else {
          log('Submission Calendar Data is null or empty');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Submission Calendar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              if (_isDataLoaded)
                _buildUserDataDisplay()
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDataDisplay() {
    return Column(
      children: [
        Text(
          'Name: $username',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Total Solved: ${_userData!['totalSolved']}',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 800,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SubmissionCalendarWidget(
              submissionData: convertToMapOfInt(
                _userData!['submissionCalendar'],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
