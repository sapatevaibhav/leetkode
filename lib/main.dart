import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeetCode Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
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

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  void _saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<void> _fetchUserData() async {
    String url = 'https://leetcode-stats-api.herokuapp.com/$_username';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(response.body);
      setState(() {
        _userData = userData;
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> valueNotifier = ValueNotifier(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeetCode Stats'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _username = _usernameController.text;
                  _saveUsername(_username);
                  _fetchUserData();
                });
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            if (_userData != null)
              Column(
                children: [
                  Text('Name: $_username'),
                  Text('Total Solved: ${_userData!['totalSolved']}'),
                  Text('Rank: ${_userData!['ranking']}'),
                  const SizedBox(
                    height: 25,
                  ),
                  // SimpleCircularProgressBar(
                  //   maxValue:
                  //       _userData!['easySolved'] / _userData!['totalEasy'],
                  //   progressStrokeWidth: 20,
                  //   backStrokeWidth: 10,
                  //   onGetText: (double value) {
                  //     return Text('${value.toInt()}%');
                  //   },
                  //   // valueNotifier: progval,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 20,
                        percent: ((_userData!['easySolved'] /
                                    _userData!['totalEasy']) *
                                100) /
                            100,
                        progressColor: Colors.purple,
                        backgroundColor: Colors.purple.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        header: Text(_userData!['easySolved'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        footer: const Text("Easy"),
                        center: Text(
                          '${(_userData!['easySolved'] / _userData!['totalEasy'] * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 20,
                        percent: ((_userData!['mediumSolved'] /
                                    _userData!['totalMedium']) *
                                100) /
                            100,
                        progressColor: Colors.yellow,
                        backgroundColor: Colors.yellow.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        header: Text(
                          _userData!['mediumSolved'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        footer: const Text("Medium"),
                        center: Text(
                          '${(_userData!['mediumSolved'] / _userData!['totalMedium'] * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircularPercentIndicator(
                        radius: 70,
                        lineWidth: 20,
                        percent: ((_userData!['hardSolved'] /
                                    _userData!['totalHard']) *
                                100) /
                            100,
                        progressColor: Colors.red,
                        backgroundColor: Colors.red.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        header: Text(_userData!['hardSolved'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        footer: const Text("Hard"),
                        center: Text(
                          '${(_userData!['hardSolved'] / _userData!['totalHard'] * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                  // SimpleCircularProgressBar(
                  //   maxValue:
                  //       (_userData!['easySolved'] / _userData!['totalEasy']) *
                  //           100,
                  //   // mergeMode: true,
                  //   onGetText: (double value) {
                  //     return Text('${value.toInt()}%');
                  //   },
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 2.5,
                    valueNotifier: valueNotifier,
                    progress: _userData!['acceptanceRate'],
                    startAngle: 225,
                    sweepAngle: 270,
                    foregroundColor: Colors.green,
                    backgroundColor: const Color(0xffeeeeee),
                    foregroundStrokeWidth: 15,
                    backgroundStrokeWidth: 15,
                    animation: true,
                    seekSize: 6,
                    seekColor: const Color(0xffeeeeee),
                    child: Center(
                      child: ValueListenableBuilder(
                          valueListenable: valueNotifier,
                          builder: (_, double value, __) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_userData!['acceptanceRate'].toInt()}%',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 60),
                                  ),
                                  const Text(
                                    'Accuracy',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 37, 37, 37),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ],
                              )),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
