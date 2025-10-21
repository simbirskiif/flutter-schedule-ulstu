// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:timetable/utils/lessons.dart';

class Filter {
  int? subgroup;
  DateTime? dateTime;
  Filter({this.subgroup, this.dateTime});
}

Filter f = Filter(subgroup: null);

bool isEqualDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

List<Lesson> getLessonsByFilter(Filter f, final target) {
  List<Lesson> lessons = List.empty(growable: true);
  lessons = getLessonsByDate(f.dateTime, target);
  lessons = getLessonsBySubgroup(f.subgroup, lessons);
  return lessons;
}

List<Lesson> getLessonsBySubgroup(int? s, final target) {
  List<Lesson> lessons = List.empty(growable: true);
  if (s == null) return target;
  if (s == 0) {
    for (Lesson l in target) {
      if (l.subgroup == 0) {
        lessons.add(l);
      }
    }
  } else if (s < 0) {
    for (Lesson l in target) {
      if (s.abs() == l.subgroup) {
        lessons.add(l);
      }
    }
  } else if (s > 0) {
    for (Lesson l in target) {
      if (s == l.subgroup || 0 == l.subgroup) {
        lessons.add(l);
      }
    }
  }
  return lessons;
}

List<Lesson> getLessonsByDate(DateTime? date, final target) {
  List<Lesson> lessons = List.empty(growable: true);
  if (date == null) return target;
  for (final l in target) {
    if (isEqualDay(l.dateTime, date)) {
      lessons.add(l);
    }
  }
  return lessons;
}
