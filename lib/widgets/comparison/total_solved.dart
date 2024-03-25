import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';
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
      mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
      children: [
        const Text(
          "Total solved",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 20),
        ),
        Flexible(
          child: FutureBuilder<List<int>>(
            future: fetchHighestSolvedCounts(),
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
                    return TotalTile(
                      username: username,
                      highestSolvedCount: highestSolvedCount,
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

  Future<List<int>> fetchHighestSolvedCounts() async {
    // Create a list to hold all the futures
    List<Future<Map<String, dynamic>>> futures = [];
    for (String username in friendUsernames) {
      // Add the future for fetching user data to the list
      futures.add(FetchUser().fetchUserData(username));
    }

    // Use Future.wait to fetch all user data concurrently
    List<Map<String, dynamic>> userDataList = await Future.wait(futures);

    // Extract totalSolved counts from fetched user data
    List<int> totalSolvedCounts = userDataList
        .map<int>((userData) => userData['totalSolved'] ?? 0)
        .toList();

    // Sort the counts in descending order
    totalSolvedCounts.sort((a, b) => b.compareTo(a));

    return totalSolvedCounts;
  }
}
