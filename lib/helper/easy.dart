import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EasyWidget extends StatelessWidget {
  final int easySolved, totalEasy;

  const EasyWidget({
    super.key,
    required this.easySolved,
    required this.totalEasy,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 70,
      lineWidth: 20,
      percent: ((easySolved / totalEasy) * 100) / 100,
      progressColor: Colors.purple,
      backgroundColor: Colors.purple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      header: Text(
        easySolved.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      footer: const Text("Easy"),
      center: Text(
        '${(easySolved / totalEasy * 100).toStringAsFixed(
          2,
        )}%',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }
}
