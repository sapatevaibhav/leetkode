import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';
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

  @override
  void initState() {
    super.initState();
    retrieveFriendUsernames();
  }

  void retrieveFriendUsernames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> friendsMap =
        jsonDecode(prefs.getString('friendsMap') ?? '{}');

    setState(() {
      friendUsernames = friendsMap.values.toList().cast<String>();
    });
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
          child: FutureBuilder<List<int>>(
            future: fetchHighestSolvedCounts(friendUsernames),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                List<int> highestSolvedCounts = snapshot.data!;
                return Column(
                  children: friendUsernames.map((username) {
                    final highestSolvedCount = highestSolvedCounts.isNotEmpty
                        ? highestSolvedCounts.first
                        : 0;
                    return SizedBox(
                      height: 100,
                      child: HardTile(
                        username: username,
                        highestSolvedCount: highestSolvedCount,
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<int>> fetchHighestSolvedCounts(List<String> usernames) async {
    List<Future<Map<String, dynamic>>> futures = [];
    for (String username in usernames) {
      futures.add(FetchUser().fetchUserData(username));
    }

    List<Map<String, dynamic>> userDataList = await Future.wait(futures);

    List<int> hardSolvedCounts = userDataList
        .map<int>((userData) => userData['hardSolved'] ?? 0)
        .toList();

    hardSolvedCounts.sort((a, b) => b.compareTo(a));

    return hardSolvedCounts;
  }
}
