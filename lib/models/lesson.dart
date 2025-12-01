import 'package:timetable/widgets/lesson_type_widget.dart';

class LessonID {
  final int week;
  final int day;
  final int index;
  final String name;
  LessonID(this.week, this.day, this.index, this.name);

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(week, day, index, name);

  Map<String, dynamic> toJson() => {
    'week': week.toString(),
    'day': day.toString(),
    'index': index.toString(),
    'name': name,
  };

  factory LessonID.fromJson(Map<String, dynamic> json) {
    return LessonID(
      int.parse(json['week']),
      int.parse(json['day']),
      int.parse(json['index']),
      json['name'],
    );
  }
}

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

  LessonID get id => LessonID(week + 1, day + 1, index + 1, nameOfLesson);
}
