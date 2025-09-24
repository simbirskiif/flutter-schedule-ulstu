import 'package:flutter/material.dart';

class LessonTypeWidget extends StatelessWidget {
  final LessonTypes type;
  const LessonTypeWidget({super.key, required this.type});

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
          "datadatadata",
          style: TextStyle(color: ColorScheme.of(context).onSecondaryContainer),
        ),
      ),
    );
  }
}

enum LessonTypes { lecture, practice, seminar }
