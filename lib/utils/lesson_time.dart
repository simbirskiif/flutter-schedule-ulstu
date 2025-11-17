// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:timetable/models/lesson.dart';
import 'package:timetable/models/relative_time.dart';

extension LessonTiming on Lesson {
  static const _lessonDuration = Duration(minutes: 80);
  RelativeTime getRelativeTime(DateTime currebtTime) {
    final start = dateTime;
    final end = start.add(_lessonDuration);
    if (currebtTime.isAfter(end)) {
      return RelativeTime(status: LessonTimeStatus.complete);
    }
    if (currebtTime.isBefore(start)) {
      return RelativeTime(
        status: LessonTimeStatus.notStart,
        timeLeft: start.difference(currebtTime),
      );
    }
    return RelativeTime(
      status: LessonTimeStatus.inProgress,
      timeLeft: end.difference(currebtTime),
    );
  }
}

enum LessonTimeStatus { notStart, inProgress, complete }
