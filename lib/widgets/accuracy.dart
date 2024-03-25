import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';

class UserAccuracy extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const UserAccuracy({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> valueNotifier = ValueNotifier(0);

    return DashedCircularProgressBar.aspectRatio(
      aspectRatio: 2.5,
      valueNotifier: valueNotifier,
      progress: userData!['acceptanceRate'],
      startAngle: 225,
      sweepAngle: 270,
      foregroundColor: Colors.green,
      backgroundColor: const Color(
        0xffeeeeee,
      ),
      foregroundStrokeWidth: 15,
      backgroundStrokeWidth: 15,
      animation: true,
      seekSize: 6,
      seekColor: const Color(
        0xffeeeeee,
      ),
      child: Center(
        child: ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (
            _,
            double value,
            __,
          ) =>
              Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${userData!['acceptanceRate'].toInt()}%',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
              ),
              const Text(
                'Accuracy',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
