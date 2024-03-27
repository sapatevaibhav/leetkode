import 'package:flutter/material.dart';

class SubmissionTile extends StatelessWidget {
  final DateTime dateTime;
  final int submissionCount;
  final VoidCallback onTap;
  final bool isFlipped;
  final int submissionValue;

  const SubmissionTile({
    Key? key,
    required this.dateTime,
    required this.submissionCount,
    required this.onTap,
    required this.isFlipped,
    required this.submissionValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isFlipped ? const Color.fromARGB(55, 0, 179, 255) : _getColorForDate(submissionCount),
          shape: BoxShape.circle,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dateTime.day}',
                  style: TextStyle(
                    color: isFlipped
                        ? Colors.black
                        : _getTextColorForDate(submissionCount),
                  ),
                ),
                if (isFlipped) ...[
                  const SizedBox(height: 5),
                  Text(
                    '$submissionValue',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForDate(int submissionCount) {
    final colorValue = submissionCount / 30;
    return Color.lerp(const Color.fromARGB(255, 19, 75, 40),
        const Color.fromARGB(255, 128, 236, 166), colorValue)!;
  }

  Color _getTextColorForDate(int submissionCount) {
    return submissionCount > 0 ? Colors.white : Colors.black;
  }
}
