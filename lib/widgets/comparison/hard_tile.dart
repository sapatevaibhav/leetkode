import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HardTile extends StatelessWidget {
  final String username;
  final int highestSolvedCount;
  final int highestHardSolved;

  const HardTile({
    Key? key,
    required this.username,
    required this.highestSolvedCount,
    required this.highestHardSolved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserDataFromSharedPreferences(username),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: const SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                backgroundColor: Color.fromARGB(131, 158, 158, 158),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text("Error loading data for $username"),
          );
        } else {
          Map<String, dynamic> userData = snapshot.data!;
          int hardSolved = userData['hardSolved'] ?? 0;

          double progressValue =
              highestHardSolved != 0 ? hardSolved / highestHardSolved : 0;

          return ListTile(
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    minHeight: 8,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    value: progressValue,
                    backgroundColor: const Color.fromARGB(131, 158, 158, 158),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hardSolved < 3
                          ? Colors.green
                          : hardSolved < 5
                              ? Colors.orange
                              : hardSolved < 10
                                  ? Colors.lightBlue
                                  : hardSolved < 25
                                      ? Colors.indigoAccent
                                      : hardSolved < 50
                                          ? Colors.yellow
                                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '$hardSolved',
                      style: TextStyle(
                        fontSize: 18,
                        color: hardSolved < 3
                            ? Colors.green
                            : hardSolved < 5
                                ? Colors.orange
                                : hardSolved < 10
                                    ? Colors.lightBlue
                                    : hardSolved < 25
                                        ? Colors.indigoAccent
                                        : hardSolved < 50
                                            ? Colors.yellow
                                            : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _loadUserDataFromSharedPreferences(
      String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString(username);

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      return userData;
    } else {
      throw Exception('User data not found for username: $username');
    }
  }
}
