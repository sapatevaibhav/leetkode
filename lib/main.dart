import 'package:adaptive_theme/adaptive_theme.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      dark: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        title: 'LeetKode',
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
      _fetchUserData(savedUsername);
    } else {
      _promptUsername();
    }
  }

  void _promptUsername() async {
    String? username = await promptUsername(context);
    if (username != null && username.isNotEmpty) {
      setState(() {
        _username = username;
      });
      saveUsername(username);
      _fetchUserData(username);
    }
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

  void updateUsername(String newUsername) {
    setState(() {
      _username = newUsername;
    });
    _fetchUserData(newUsername);
  }

  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LeetCode Stats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              setState(() {
                _isDarkTheme = !_isDarkTheme;
              });
              final themeMode = Theme.of(context).brightness == Brightness.dark
                  ? AdaptiveThemeMode.light
                  : AdaptiveThemeMode.dark;
              AdaptiveTheme.of(context).setThemeMode(themeMode);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            if (_userData != null)
              // Expanded(
              //   child:
              Column(
                children: [
                  Text(
                    'Name: $_username',
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
                ],
              ),
            // ),
          ],
        ),
      ),
      drawer: AppDrawer(username: _username, onUpdateUsername: updateUsername),
    );
  }
}
