// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:timetable/utils/lesson_time.dart';

class RelativeTime {
  final LessonTimeStatus status;
  final Duration? timeLeft;
  RelativeTime({required this.status, this.timeLeft});

  @override
  String toString() => 'RelativeTime(status: $status, timeLeft: $timeLeft)';
}
