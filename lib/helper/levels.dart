import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ThreeLevels extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ThreeLevels({Key? key, required this.userData})
      : super(
          key: key,
        );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 70,
          lineWidth: 20,
          percent:
              ((userData!['easySolved'] / userData!['totalEasy']) * 100) / 100,
          progressColor: Colors.purple,
          backgroundColor: Colors.purple.shade100,
          circularStrokeCap: CircularStrokeCap.round,
          header: Text(
            userData!['easySolved'].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          footer: const Text("Easy"),
          center: Text(
            '${(userData!['easySolved'] / userData!['totalEasy'] * 100).toStringAsFixed(
              2,
            )}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        CircularPercentIndicator(
          radius: 70,
          lineWidth: 20,
          percent:
              ((userData!['mediumSolved'] / userData!['totalMedium']) * 100) /
                  100,
          progressColor: Colors.yellow,
          backgroundColor: Colors.yellow.shade100,
          circularStrokeCap: CircularStrokeCap.round,
          header: Text(
            userData!['mediumSolved'].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          footer: const Text(
            "Medium",
          ),
          center: Text(
            '${(userData!['mediumSolved'] / userData!['totalMedium'] * 100).toStringAsFixed(
              2,
            )}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        CircularPercentIndicator(
          radius: 70,
          lineWidth: 20,
          percent:
              ((userData!['hardSolved'] / userData!['totalHard']) * 100) / 100,
          progressColor: Colors.red,
          backgroundColor: Colors.red.shade100,
          circularStrokeCap: CircularStrokeCap.round,
          header: Text(
            userData!['hardSolved'].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          footer: const Text(
            "Hard",
          ),
          center: Text(
            '${(userData!['hardSolved'] / userData!['totalHard'] * 100).toStringAsFixed(
              2,
            )}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
