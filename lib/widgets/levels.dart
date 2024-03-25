import 'package:flutter/material.dart';
import 'package:leetkode/helper/easy.dart';
import 'package:leetkode/helper/hard.dart';
import 'package:leetkode/helper/medium.dart';

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
        EasyWidget(
          easySolved: userData!['easySolved'],
          totalEasy: userData!['totalEasy'],
        ),
        const SizedBox(
          width: 10,
        ),
        MediumWidget(
          mediumSolved: userData!['mediumSolved'],
          totalMedium: userData!['totalMedium'],
        ),
        const SizedBox(
          width: 10,
        ),
        HardWidget(
          hardSolved: userData!['hardSolved'],
          totalHard: userData!['totalHard'],
        )
      ],
    );
  }
}
