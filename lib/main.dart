import 'package:flutter/material.dart';
import 'package:leetkode/helper/app_drawer.dart';
import 'package:leetkode/helper/username_prompt.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:leetkode/helper/accuracy.dart';
import 'package:leetkode/helper/levels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeetKode',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key})
      : super(
          key: key,
        );

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  String _username = '';
  Map<String, dynamic>? _userData;
  final FetchUser _fetchUser = FetchUser();

  @override
  void initState() {
    super.initState();
    _loadUsernameOrPrompt();
  }

  void _loadUsernameOrPrompt() async {
    String? savedUsername = await loadUsername();

    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        _username = savedUsername;
      });
      _fetchUserData(
        savedUsername,
      );
    } else {
      _promptUsername();
    }
  }

  void _promptUsername() async {
    String? username = await promptUsername(
      context,
    );
    if (username != null && username.isNotEmpty) {
      setState(() {
        _username = username;
      });
      saveUsername(
        username,
      );
      _fetchUserData(
        username,
      );
    }
  }

  void _fetchUserData(
    String username,
  ) {
    _fetchUser
        .fetchUserData(
      username,
    )
        .then((
      userData,
    ) {
      setState(() {
        _userData = userData;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error fetching user data: $error',
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LeetCode Stats',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter your LeetCode username',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = _usernameController.text;
                  saveUsername(_username);
                  _fetchUser
                      .fetchUserData(
                    _username,
                  )
                      .then((
                    userData,
                  ) {
                    setState(() {
                      _userData = userData;
                    });
                  }).catchError((
                    error,
                  ) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error fetching user data: $error',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                });
              },
              child: const Text(
                'Submit',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_userData != null)
              Column(
                children: [
                  Text(
                    'Name: $_username',
                  ),
                  Text(
                    'Total Solved: ${_userData!['totalSolved']}',
                  ),
                  Text(
                    'Rank: ${_userData!['ranking']}',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ThreeLevels(
                    userData: _userData,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  UserAccuracy(
                    userData: _userData,
                  ),
                ],
              ),
          ],
        ),
      ),
      drawer: AppDrawer(
        username: _username,
      ),
    );
  }
}
