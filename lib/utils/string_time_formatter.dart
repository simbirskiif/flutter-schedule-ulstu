import 'package:intl/intl.dart';
import 'package:timetable/utils/lesson_time.dart';

String formatRelativeDuration(Duration difference, LessonTimeStatus status) {
  final absDifference = difference.abs();
  final now = DateTime.now();

  if (status == LessonTimeStatus.notStart) {
    final targetDay = now.add(difference);
    final nowDay = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(targetDay.year, targetDay.month, targetDay.day);
    final dayDifference = eventDay.difference(nowDay).inDays;

    if (dayDifference == 1) {
      return 'Завтра';
    }
    if (dayDifference == 2) {
      return 'Послезавтра';
    }
    if (dayDifference > 2) {
      return '';
    }
  }

  String prefix = '';
  String suffix = '';

  if (absDifference.inSeconds < 5) {
    if (status == LessonTimeStatus.notStart) return 'Начинается!';
    if (status == LessonTimeStatus.inProgress) return 'Заканчивается!';
    if (status == LessonTimeStatus.complete) return 'Только что закончился';
    return '';
  }

  switch (status) {
    case LessonTimeStatus.notStart:
      prefix = 'Через ';
      break;
    case LessonTimeStatus.inProgress:
      prefix = 'До конца: ';
      break;
    case LessonTimeStatus.complete:
      suffix = ' назад';
      break;
  }

  String timeString;

  if (absDifference.inHours > 0) {
    int hours = absDifference.inHours;
    int minutes = absDifference.inMinutes % 60;

    String hoursText = Intl.plural(
      hours,
      one: 'час',
      few: 'часа',
      many: 'часов',
      other: 'часов',
      locale: 'ru',
    );

    if (minutes > 0) {
      String minutesText = Intl.plural(
        minutes,
        one: 'минуту',
        few: 'минуты',
        many: 'минут',
        other: 'минут',
        locale: 'ru',
      );
      timeString = '$hours $hoursText $minutes $minutesText';
    } else {
      timeString = '$hours $hoursText';
    }
  } else if (absDifference.inMinutes > 0) {
    int minutes = absDifference.inMinutes;
    timeString = Intl.plural(
      minutes,
      one: '$minutes минуту',
      few: '$minutes минуты',
      many: '$minutes минут',
      other: '$minutes минут',
      locale: 'ru',
    );
  } else {
    int seconds = absDifference.inSeconds;
    timeString = Intl.plural(
      seconds,
      one: '$seconds секунду',
      few: '$seconds секунды',
      many: '$seconds секунд',
      other: '$seconds секунд',
      locale: 'ru',
    );
  }

  return '$prefix$timeString$suffix';
}

String dayFormat(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow =today.add(Duration(days: 1));
  final yesterday = today.subtract(Duration(days: 1));
  final afterTomorrow = today.add(Duration(days: 2));
  DateTime d = DateTime(date.year, date.month, date.day);

  if (d == today) {
    return 'Сегодня';
  } else if (d == tomorrow) {
    return 'Завтра';
  } else if (d == afterTomorrow) {
    return 'Послезавтра';
  } else if (d == yesterday) {
    return 'Вчера';
  } else {
    return DateFormat("EEEE, d.MM", "ru").format(date);
  }
}
