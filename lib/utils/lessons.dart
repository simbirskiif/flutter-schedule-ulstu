// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:timetable/lesson_type_widget.dart';

class Lesson {
  final int subgroup;
  final String group;
  final DateTime dateTime;
  final String teacher;
  final String room;
  final String nameOfLesson;
  final bool isRemove;
  final LessonTypes lessonType;
  Lesson({
    required this.subgroup,
    required this.group,
    required this.dateTime,
    required this.teacher,
    required this.room,
    required this.nameOfLesson,
    required this.isRemove,
    required this.lessonType,
  });
}

class DumpLesson {
  final int week;
  final int day;
  final int index;
  final String group;
  final String nameOfLesson;
  final String teacher;
  final String room;

  DumpLesson({
    required this.week,
    required this.day,
    required this.index,
    required this.group,
    required this.nameOfLesson,
    required this.teacher,
    required this.room,
  });
  @override
  String toString() {
    return "week: $week, day: $day, index: $index, group: $group, name: $nameOfLesson, teacher: $teacher, room: $room";
  }
}

List<DumpLesson> decodeJSON(String raw) {
  final decoded = jsonDecode(raw);
  final weeks = decoded["response"]?["weeks"] as Map? ?? {};
  final dumpLessons = <DumpLesson>[];
  weeks.forEach((weekKey, weekData) {
    int week = int.tryParse(weekKey) ?? 0;
    List days = weekData["days"] as List? ?? [];
    for (final dayData in days) {
      int day = dayData["day"] ?? -1;
      List lessonSlots = dayData["lessons"] as List? ?? [];
      for (int i = 0; i < lessonSlots.length; i++) {
        final slot = lessonSlots[i];
        if (slot is List) {
          for (final lessonInfo in slot) {
            if (lessonInfo is Map) {
              dumpLessons.add(
                DumpLesson(
                  week: week,
                  day: day,
                  index: i,
                  group: lessonInfo["group"] ?? "",
                  nameOfLesson: lessonInfo["nameOfLesson"] ?? "",
                  teacher: lessonInfo["teacher"] ?? "",
                  room: lessonInfo["room"] ?? "",
                ),
              );
            }
          }
        }
      }
    }
  });
  return dumpLessons;
}
