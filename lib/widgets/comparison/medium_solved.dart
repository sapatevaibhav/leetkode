import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:leetkode/widgets/comparison/medium_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MediumSolved extends StatefulWidget {
  const MediumSolved({Key? key}) : super(key: key);

  @override
  MediumSolvedState createState() => MediumSolvedState();
}

class MediumSolvedState extends State<MediumSolved> {
  late List<String> friendUsernames = [];
  late List<int> highestSolvedCounts = [];
  int highestMediumSolved = 0;

  @override
  void initState() {
    super.initState();
    retrieveFriendData();
  }

  Future<void> retrieveFriendData() async {
    await retrieveFriendUsernames();
    await retrieveHighestSolvedCounts();
    calculateHighestMediumSolved();
  }

  Future<void> retrieveFriendUsernames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? friendsMapString = prefs.getString('friendsMap');
    if (friendsMapString != null) {
      Map<String, dynamic> friendsMap = jsonDecode(friendsMapString);
      setState(() {
        friendUsernames = friendsMap.values.toList().cast<String>();
      });
    } else {
      log('Friends map not found in SharedPreferences');
    }
  }

  Future<void> retrieveHighestSolvedCounts() async {
    List<int> counts = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String username in friendUsernames) {
      String? userDataString = prefs.getString(username);
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        int mediumSolved = userData['mediumSolved'] ?? 0;
        counts.add(mediumSolved);
      } else {
        log('User data not found for username: $username');
      }
    }

    counts.sort((a, b) => b.compareTo(a));

    setState(() {
      highestSolvedCounts = counts;
    });
  }

  void calculateHighestMediumSolved() {
    if (highestSolvedCounts.isNotEmpty) {
      highestMediumSolved = ((highestSolvedCounts.first + 49) ~/ 50) * 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Medium solved",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Flexible(
          child: FutureBuilder<List<int>>(
            future: fetchMediumSolvedCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                List<int> mediumSolvedCounts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: friendUsernames.length,
                  itemBuilder: (context, index) => MediumTile(
                    username: friendUsernames[index],
                    highestSolvedCount: mediumSolvedCounts[index],
                    highestMediumSolved: highestMediumSolved,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<int>> fetchMediumSolvedCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> userDataList = [];
    for (String username in friendUsernames) {
      String? userDataString = prefs.getString(username);
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        userDataList.add(userData);
      }
    }

    List<int> mediumSolvedCounts = userDataList
        .map<int>((userData) => userData['mediumSolved'] ?? 0)
        .toList();

    mediumSolvedCounts.sort((a, b) => b.compareTo(a));

    return mediumSolvedCounts;
  }
}
