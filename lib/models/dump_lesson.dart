// ignore_for_file: public_member_api_docs, sort_constructors_first

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
