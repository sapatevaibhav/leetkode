import 'package:flutter/material.dart';
import 'package:leetkode/helper/data_fetch.dart';

class EasyTile extends StatelessWidget {
  final String username;
  final int highestSolvedCount;

  const EasyTile({
    Key? key,
    required this.username,
    required this.highestSolvedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: FutureBuilder<Map<String, dynamic>>(
        future: FetchUser().fetchUserData(username),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: Color.fromARGB(131, 158, 158, 158),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final userData = snapshot.data;
            if (userData == null || !userData.containsKey('easySolved')) {
              return const Text("Invalid user data");
            }

            final totalSolved = userData['easySolved'] as int;
            final nearestBig50Multiple = ((totalSolved + 9) ~/ 10) * 10;
            final progressValue = totalSolved / nearestBig50Multiple;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8, 
                  child: LinearProgressIndicator(
                    value: progressValue.isNaN || progressValue.isInfinite
                        ? 0.0
                        : progressValue,
                    backgroundColor: const Color.fromARGB(131, 158, 158, 158),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      totalSolved < 3
                          ? Colors.green
                          : totalSolved < 5
                              ? Colors.orange
                              : totalSolved < 10
                                  ? Colors.lightBlue
                                  : totalSolved < 25
                                      ? Colors.indigoAccent
                                      : totalSolved < 50
                                          ? Colors.yellow
                                          : Colors.redAccent,
                    ),
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
            );
          }
        },
      ),
    );
  }
}
