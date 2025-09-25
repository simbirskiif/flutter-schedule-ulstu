import 'package:flutter/material.dart';

class LessonTypeWidget extends StatelessWidget {
  final LessonTypes type;
  final Color testColor;
  final String testType;
  const LessonTypeWidget({
    super.key,
    required this.type,
    required this.testColor, required this.testType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorScheme.of(context).onSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          testType,
          //style: TextStyle(color: ColorScheme.of(context).onSecondaryContainer),
          style: TextStyle(color: testColor),
        ),
      ),
    );
  }
}

enum LessonTypes { lecture, practice, seminar }
