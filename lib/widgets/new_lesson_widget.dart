// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:timetable/utils/lessons.dart';

class NewLessonWidget extends StatelessWidget {
  final Lesson? lesson;
  const NewLessonWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 650),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: ColorScheme.of(context).surfaceVariant,
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              spacing: 2,
              children: [
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: SizedBox(
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(right: 2),
                              child: SizedBox(
                                width: 80,
                                height: 16,
                                child: Material(
                                  color: Colors.red,
                                  child: Text(
                                    "Тип занятия",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text:
                                "Занятие Занятие Занятие Занятие Занятие Занятие Занятие ",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        spacing: 2,
                        children: [Icon(Icons.person), Text("Имя препода")],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Кабинет"),
                            Icon(Icons.door_back_door_outlined),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 2,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text("Еще 40 минут"),
                    ),
                    LinearProgressIndicatorM3E(
                      value: 0.6,
                      size: LinearProgressM3ESize.s,
                      shape: ProgressM3EShape.wavy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
