import 'package:flutter/material.dart';
import 'package:timetable/widgets/lesson_type_widget.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';
import 'package:timetable/utils/color_utils.dart';

class DebugWindow extends StatelessWidget {
  const DebugWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.lecture),
                  child: Text(
                    "Лекция",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.lecture),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.practice),
                  child: Text(
                    "Практика",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.practice),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.seminar),
                  child: Text(
                    "Лабораторная",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.seminar),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: ColorScheme.of(context).errorContainer,
                  child: Text(
                    "Неизвестно",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        ColorScheme.of(context).errorContainer,
                      ),
                    ),
                  ),
                ),
              ),
              NewLessonWidget(lesson: null),
            ],
          ),
        ),
      ),
    );
  }
}
