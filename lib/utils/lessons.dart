// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:timetable/widgets/lesson_type_widget.dart';

class Lesson {
  final int week;
  final int day;
  final int index;
  final int subgroup;
  final String group;
  final DateTime dateTime;
  final String teacher;
  final String room;
  final String nameOfLesson;
  final bool isRemote;
  final LessonTypes lessonType;
  Lesson({
    required this.week,
    required this.day,
    required this.index,
    required this.subgroup,
    required this.group,
    required this.dateTime,
    required this.teacher,
    required this.room,
    required this.nameOfLesson,
    required this.isRemote,
    required this.lessonType,
  });
  @override
  String toString() {
    return "Date: $dateTime, type: $lessonType, subgroup: $subgroup, group: $group, name: $nameOfLesson, teacher: $teacher, room: $room, remote: $isRemote";
  }
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

List<Lesson> converDumpToLessons(List<DumpLesson> dumps) {
  final lessons = <Lesson>[];
  for (final dump in dumps) {
    String name = dump.nameOfLesson;
    String teacher = dump.teacher;
    String room = dump.room;
    final subgroupMatch = RegExp(
      r'(\d)\s*п/г',
    ).firstMatch('$name $teacher $room');
    int subgroup = subgroupMatch != null
        ? int.tryParse(subgroupMatch.group(1) ?? "0") ?? 0
        : 0;
    name = name.replaceAll(RegExp(r'\d\s*п/г'), '').trim();
    teacher = teacher.replaceAll(RegExp(r'\d\s*п/г'), '').trim();
    final lowerName = name.toLowerCase();
    LessonTypes lessonType;
    if (lowerName.startsWith("лек")) {
      lessonType = LessonTypes.lecture;
      name = name
          .replaceFirst(RegExp(r'^лек\.?', caseSensitive: false), '')
          .trim();
    } else if (lowerName.startsWith("пр")) {
      lessonType = LessonTypes.practice;
      name = name
          .replaceFirst(RegExp(r'^пр\.?', caseSensitive: false), '')
          .trim();
    } else if (lowerName.startsWith("лаб")) {
      lessonType = LessonTypes.seminar;
      name = name
          .replaceFirst(RegExp(r'^лаб\.?', caseSensitive: false), '')
          .trim();
    } else {
      lessonType = LessonTypes.seminar;
    }

    bool isRemote = room.toUpperCase().contains("ДОТ");
    if (isRemote) room = "";
    DateTime dateTime = lessonDateTime(dump.week, dump.day, dump.index);
    lessons.add(
      Lesson(
        week: dump.week,
        day: dump.day,
        index: dump.index,
        subgroup: subgroup,
        group: dump.group,
        dateTime: dateTime,
        teacher: teacher,
        room: room,
        nameOfLesson: name,
        isRemote: isRemote,
        lessonType: lessonType,
      ),
    );
  }
  return lessons;
}

DateTime lessonDateTime(int week, int day, int index) {
  week++;
  final now = DateTime.now();
  final int startYear = now.month >= 9 ? now.year : now.year - 1;
  final weekStart = DateTime(startYear, 9, 1);
  final daysFromStart = (week - 1) * 7 + day;
  var date = weekStart.add(Duration(days: daysFromStart));

  final pairTimes = [
    Duration(hours: 8, minutes: 30),
    Duration(hours: 10, minutes: 0),
    Duration(hours: 11, minutes: 30),
    Duration(hours: 13, minutes: 30),
    Duration(hours: 15, minutes: 0),
    Duration(hours: 16, minutes: 30),
    Duration(hours: 18, minutes: 00),
    Duration(hours: 19, minutes: 30),
  ];

  final time = index < pairTimes.length ? pairTimes[index] : Duration(hours: 0);

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.inHours,
    time.inMinutes % 60,
  );
}
