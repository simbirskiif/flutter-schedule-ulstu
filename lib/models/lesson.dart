import 'package:timetable/widgets/lesson_type_widget.dart';
import 'package:timetable/models/note.dart';

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
  Note? note;
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

  String get id {
    return '${subgroup}_${group}_${nameOfLesson}_$lessonType';
  }

  @override
  int get hashCode {
    return Object.hash(
      week,
      day,
      index,
      subgroup,
      group,
      dateTime,
      teacher,
      room,
      nameOfLesson,
      isRemote,
      lessonType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Lesson &&
        week == other.week &&
        day == other.day &&
        index == other.index &&
        subgroup == other.subgroup &&
        group == other.group &&
        dateTime == other.dateTime &&
        teacher == other.teacher &&
        room == other.room &&
        nameOfLesson == other.nameOfLesson &&
        isRemote == other.isRemote &&
        lessonType == other.lessonType;
  }
}
