import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HardWidget extends StatelessWidget {
  final int hardSolved, totalHard;

  const HardWidget({
    super.key,
    required this.hardSolved,
    required this.totalHard,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 70,
      lineWidth: 20,
      percent: ((hardSolved / totalHard) * 100) / 100,
      progressColor: Colors.red,
      backgroundColor: Colors.red.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      header: Text(
        hardSolved.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      footer: const Text("Easy"),
      center: Text(
        '${(hardSolved / totalHard * 100).toStringAsFixed(
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
