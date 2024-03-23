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
  const MyApp({super.key});

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
        title: const Text('LeetCode Stats'),
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
      // backgroundColor:
      //     const Color.fromARGB(255, 0, 0, 0), // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
              ),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(
                    fontWeight: FontWeight.bold), // Set text color
                decoration: InputDecoration(
                  hintText: 'Enter your LeetCode username',

                  labelStyle: const TextStyle(
                      color: Colors.white), // Set label text color
                  fillColor: const Color.fromARGB(
                      81, 125, 124, 124), // Set background color
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.blue), // Set focused border color
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _promptUsername();
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
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
                  const SizedBox(height: 25),
                  ThreeLevels(userData: _userData),
                  const SizedBox(height: 25),
                  UserAccuracy(userData: _userData),
                ],
              ),
          ],
        ),
      ),
      drawer: AppDrawer(username: _username, onUpdateUsername: updateUsername),
    );
  }
}
