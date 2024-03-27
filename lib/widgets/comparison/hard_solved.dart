import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:leetkode/widgets/comparison/hard_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HardSolved extends StatefulWidget {
  const HardSolved({Key? key}) : super(key: key);

  @override
  HardSolvedState createState() => HardSolvedState();
}

class HardSolvedState extends State<HardSolved> {
  late List<String> friendUsernames = [];
  late List<int> highestSolvedCounts = [];
  int highestHardSolved = 0;

  @override
  void initState() {
    super.initState();
    retrieveFriendData();
  }

  Future<void> retrieveFriendData() async {
    await retrieveFriendUsernames();
    await retrieveHighestSolvedCounts();
    calculateHighestHardSolved();
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
        int hardSolved = userData['hardSolved'] ?? 0;
        counts.add(hardSolved);
      } else {
        log('User data not found for username: $username');
      }
    }

    counts.sort((a, b) => b.compareTo(a));

    setState(() {
      highestSolvedCounts = counts;
    });
  }

  void calculateHighestHardSolved() {
    if (highestSolvedCounts.isNotEmpty) {
      highestHardSolved = ((highestSolvedCounts.first + 9) ~/ 10) * 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Hard solved",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Flexible(
          child: highestSolvedCounts.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: friendUsernames.length,
                  itemBuilder: (context, index) => HardTile(
                    username: friendUsernames[index],
                    highestSolvedCount: highestSolvedCounts[index],
                    highestHardSolved: highestHardSolved,
                  ),
                )
              : const Center(
                  child: Text("No data available"),
                ),
        ),
      ],
    );
  }
}
