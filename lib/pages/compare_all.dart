import 'package:flutter/material.dart';
import 'package:leetkode/widgets/comparison/easy_solved.dart';
import 'package:leetkode/widgets/comparison/medium_solved.dart';
import 'package:leetkode/widgets/comparison/total_solved.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({Key? key}) : super(key: key);

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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TotalSolved(),
                  SizedBox(height: 20),
                  EasySolved(),
                  SizedBox(height: 20),
                  MediumSolved(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
