import 'package:flutter/material.dart';
import 'package:leetkode/widgets/comparison/easy_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EasySolved extends StatefulWidget {
  const EasySolved({Key? key}) : super(key: key);

  @override
  EasySolvedState createState() => EasySolvedState();
}

class EasySolvedState extends State<EasySolved> {
  late List<String> friendUsernames = [];
  late List<int> highestSolvedCounts = [];
  int highestEasySolved = 0;

  @override
  void initState() {
    super.initState();
    retrieveFriendData();
  }

  Future<void> retrieveFriendData() async {
    await retrieveFriendUsernames();
    await retrieveHighestSolvedCounts();
    calculateHighestEasySolved();
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
        int easySolved = userData['easySolved'] ?? 0;
        counts.add(easySolved);
      } else {
        print('User data not found for username: $username');
      }
    }

    counts.sort((a, b) => b.compareTo(a));

    setState(() {
      highestSolvedCounts = counts;
    });
  }

  void calculateHighestEasySolved() {
    if (highestSolvedCounts.isNotEmpty) {
      highestEasySolved = ((highestSolvedCounts.first + 49) ~/ 50) * 50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Easy solved",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Flexible(
          child: FutureBuilder<List<int>>(
            future: fetchEasySolvedCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                List<int> easySolvedCounts = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true, // Add this line
                  itemCount: friendUsernames.length,
                  itemBuilder: (context, index) => EasyTile(
                    username: friendUsernames[index],
                    highestSolvedCount: easySolvedCounts[index],
                    highestEasySolved: highestEasySolved,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<int>> fetchEasySolvedCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> userDataList = [];
    for (String username in friendUsernames) {
      String? userDataString = prefs.getString(username);
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        userDataList.add(userData);
      }
    }

    List<int> easySolvedCounts = userDataList
        .map<int>((userData) => userData['easySolved'] ?? 0)
        .toList();

    easySolvedCounts.sort((a, b) => b.compareTo(a));

    return easySolvedCounts;
  }
}
