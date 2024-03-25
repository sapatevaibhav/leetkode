import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';

class TotalTile extends StatelessWidget {
  final String username;
  final int highestSolvedCount;

  const TotalTile({
    Key? key,
    required this.username,
    required this.highestSolvedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int nearestBig100Multiple = ((highestSolvedCount + 99) ~/ 100) * 100;
    return FutureBuilder<Map<String, dynamic>>(
      future: FetchUser().fetchUserData(username),
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
              child:  LinearProgressIndicator(
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
          int totalSolved = userData['totalSolved'];
          return ListTile(
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: SizedBox(
              // height: 8, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    minHeight: 8,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    value: totalSolved / nearestBig100Multiple,
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
}
