// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leetkode/helper/submission_tile.dart';

class SubmissionCalendarWidget extends StatefulWidget {
  final Map<String, int>? submissionData;

  const SubmissionCalendarWidget({Key? key, required this.submissionData})
      : super(key: key);

  @override
  _SubmissionCalendarWidgetState createState() =>
      _SubmissionCalendarWidgetState();
}

class _SubmissionCalendarWidgetState extends State<SubmissionCalendarWidget> {
  Map<int, List<MapEntry<String, int>>> groupedData = {};
  Map<int, Map<int, bool>> tileFlippedStates = {};
  Map<int, Map<int, int>> tileSubmissionValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.submissionData != null) {
      widget.submissionData!.forEach((date, count) {
        final dateTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
        final month = dateTime.month;
        groupedData.putIfAbsent(month, () => []).add(MapEntry(date, count));

        tileFlippedStates[month] = {};
        tileSubmissionValues[month] = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.submissionData == null || widget.submissionData!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final month = groupedData.keys.toList()[index];
        final monthData = groupedData[month]!;
        return _buildMonthCalendar(month, monthData, index);
      },
    );
  }

  Widget _buildMonthCalendar(
      int month, List<MapEntry<String, int>> monthData, int monthIndex) {
    final firstDate = monthData.isNotEmpty
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(monthData.first.key) * 1000)
        : DateTime.now();
    final year = firstDate.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            '${_getMonthName(month)} $year',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: monthData.length,
          itemBuilder: (context, index) {
            final date = monthData[index].key;
            final submissionCount = monthData[index].value;
            final DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(int.parse(date) * 1000);
            final tileIndex = _calculateTileIndex(monthIndex, index);

            return SubmissionTile(
              dateTime: dateTime,
              submissionCount: submissionCount,
              onTap: () {
                _handleTileTap(month, tileIndex, submissionCount);
              },
              isFlipped: tileFlippedStates[month]?[tileIndex] ?? false,
              submissionValue: tileSubmissionValues[month]?[tileIndex] ?? 0,
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  int _calculateTileIndex(int monthIndex, int indexInMonth) {
    int tileIndex = 0;
    for (int i = 1; i <= monthIndex; i++) {
      if (groupedData.containsKey(i)) {
        tileIndex += groupedData[i]!.length;
      }
    }
    tileIndex += indexInMonth;
    return tileIndex;
  }

  void _handleTileTap(int month, int index, int submissionCount) {
    setState(() {
      tileFlippedStates[month] ??= {};
      tileSubmissionValues[month] ??= {};

      tileFlippedStates[month]![index] =
          !(tileFlippedStates[month]![index] ?? false);
      tileSubmissionValues[month]![index] = submissionCount;

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          tileFlippedStates[month]![index] = false;
          tileSubmissionValues[month]![index] = 0;
        });
      });
    });
  }
}
