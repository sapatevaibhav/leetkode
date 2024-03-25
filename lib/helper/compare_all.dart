import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';
import 'package:leetkode/widgets/friends_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CompareFriends extends StatefulWidget {
  const CompareFriends({Key? key}) : super(key: key);

  @override
  CompareFriendsState createState() => CompareFriendsState();
}

class CompareFriendsState extends State<CompareFriends> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "COMPARE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Text(
            "Total solved",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: FutureBuilder<List<int>>(
              future: fetchHighestSolvedCounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  List<int> highestSolvedCounts = snapshot.data!;
                  return ListView.builder(
                    itemCount: friendUsernames.length,
                    itemBuilder: (context, index) {
                      return FriendTile(
                        username: friendUsernames[index],
                        highestSolvedCount: highestSolvedCounts.isNotEmpty
                            ? highestSolvedCounts.first
                            : 0,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
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
