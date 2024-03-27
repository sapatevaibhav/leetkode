import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TotalTile extends StatelessWidget {
  final String username;
  final int highestSolvedCount;
  final int highestTotalSolved;

  const TotalTile({
    Key? key,
    required this.username,
    required this.highestSolvedCount,
    required this.highestTotalSolved,
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
          int totalSolved = userData['totalSolved'] ?? 0;

          double progressValue = highestTotalSolved != 0
              ? totalSolved / highestTotalSolved
              : 0; // Check if highestTotalSolved is not zero to avoid division by zero error

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
                      totalSolved < 25
                          ? Colors.green
                          : totalSolved < 50
                              ? Colors.orange
                              : totalSolved < 100
                                  ? Colors.lightBlue
                                  : totalSolved < 150
                                      ? Colors.indigoAccent
                                      : totalSolved < 200
                                          ? Colors.yellow
                                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '$totalSolved',
                      style: TextStyle(
                        fontSize: 18,
                        color: totalSolved < 25
                            ? Colors.green
                            : totalSolved < 50
                                ? Colors.orange
                                : totalSolved < 100
                                    ? Colors.lightBlue
                                    : totalSolved < 150
                                        ? Colors.indigoAccent
                                        : totalSolved < 200
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
