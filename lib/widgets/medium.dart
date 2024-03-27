import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MediumWidget extends StatelessWidget {
  final int mediumSolved, totalMedium;

  const MediumWidget({
    super.key,
    required this.mediumSolved,
    required this.totalMedium,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 70,
      lineWidth: 20,
      percent: ((mediumSolved / totalMedium) * 100) / 100,
      progressColor: Colors.yellow,
      backgroundColor: Colors.yellow.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      header: Text(
        mediumSolved.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      footer: const Text("Medium"),
      center: Text(
        '${(mediumSolved / totalMedium * 100).toStringAsFixed(
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
