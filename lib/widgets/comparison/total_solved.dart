import 'package:flutter/material.dart';
import 'package:leetkode/widgets/comparison/total_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TotalSolved extends StatefulWidget {
  const TotalSolved({Key? key}) : super(key: key);

  @override
  TotalSolvedState createState() => TotalSolvedState();
}

class TotalSolvedState extends State<TotalSolved> {
  late List<String> friendUsernames = [];
  late List<int> highestSolvedCounts = [];
  int highestTotalSolved = 0;

  @override
  void initState() {
    super.initState();
    retrieveFriendData();
  }
  Future<void> retrieveFriendData() async {
    await retrieveFriendUsernames();
    await retrieveHighestSolvedCounts();
    calculateHighestTotalSolved();
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
      print('Friends map not found in SharedPreferences');
    }
  }

  Future<void> retrieveHighestSolvedCounts() async {
    List<int> counts = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (String username in friendUsernames) {
      String? userDataString = prefs.getString(username);
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        int totalSolved =
            userData['totalSolved'] ?? 0; 
        counts.add(totalSolved);
      } else {
        print('User data not found for username: $username');
      }
    }

    counts.sort((a, b) => b.compareTo(a));

    setState(() {
      highestSolvedCounts = counts;
    });
  }

  void calculateHighestTotalSolved() {
    if (highestSolvedCounts.isNotEmpty) {
      highestTotalSolved = ((highestSolvedCounts.first + 99) ~/ 100) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Total solved",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Flexible(
          child: highestSolvedCounts.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: friendUsernames.length,
                  itemBuilder: (context, index) => TotalTile(
                    username: friendUsernames[index],
                    highestSolvedCount: highestSolvedCounts[index],
                    highestTotalSolved: highestTotalSolved,
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
