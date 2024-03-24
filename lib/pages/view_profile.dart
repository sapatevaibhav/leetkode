import 'package:flutter/material.dart';
import 'package:leetkode/helper/accuracy.dart';
import 'package:leetkode/helper/levels.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:leetkode/helper/maptoint.dart';
import 'package:leetkode/helper/submission_calender.dart';

class ProfilePage extends StatefulWidget {
  final String? initialUsername;

  const ProfilePage({Key? key, this.initialUsername}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  String username = '';
  Map<String, dynamic>? _userData;
  final FetchUser _fetchUser = FetchUser();

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null) {
      username = widget.initialUsername!;
      _fetchUserData(username);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Friends profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.initialUsername == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Enter your LeetCode username',
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color.fromARGB(81, 125, 124, 124),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (widget.initialUsername == null || _userData != null)
                const SizedBox(height: 20),
              if (widget.initialUsername == null)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (widget.initialUsername == null) {
                        username = _usernameController.text;
                      }
                      _fetchUserData(username);
                    });
                  },
                  child: const Text('Submit'),
                ),
              if (_userData != null)
                Column(
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
                    Text(
                      'Rank: ${_userData!['ranking']}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ThreeLevels(userData: _userData),
                    const SizedBox(height: 25),
                    UserAccuracy(userData: _userData),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 800,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SubmissionCalendarWidget(
                          submissionData: convertToMapOfInt(
                            _userData!['submissionCalendar'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchUserData(String username) {
    _fetchUser.fetchUserData(username).then((userData) {
      setState(() {
        _userData = userData;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
