// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:timetable/models/lesson.dart';

class LessonTransfer {
  Lesson? lesson;
  int? skip;
  LessonTransfer({this.lesson, this.skip});

  @override
  String toString() => 'LessonTransfer(lesson: $lesson, skip: $skip)';
}

List<LessonTransfer> transferLessons(List<Lesson> lessons) {
  final transfers = <LessonTransfer>[];
  if(lessons.length > 1){
    transfers.add(LessonTransfer(lesson: null, skip: lessons[0].index));
  }
  for (int i = 0; i < lessons.length; i++) {
    final current = lessons[i];
    transfers.add(LessonTransfer(lesson: current, skip: null));
    if (i < lessons.length - 1) {
      final next = lessons[i + 1];
      final skip = next.index - current.index - 1;
      if (skip > 0) {
        transfers.add(LessonTransfer(lesson: null, skip: skip));
      }
    }
  }
  return transfers;
}
