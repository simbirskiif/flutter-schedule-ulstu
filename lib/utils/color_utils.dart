import 'package:flutter/material.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/widgets/lesson_type_widget.dart';

Color lessonTypeColor(BuildContext context, LessonTypes type) {
  final baseColor = Theme.of(context).colorScheme.primary;

  final hsl = HSLColor.fromColor(baseColor);

  switch (type) {
    case LessonTypes.lecture:
      return hsl.withHue((hsl.hue + 0) % 360).toColor();
    case LessonTypes.practice:
      return hsl.withHue((hsl.hue + 60) % 360).toColor();
    case LessonTypes.seminar:
      return hsl.withHue((hsl.hue + 120) % 360).toColor();
    case LessonTypes.undefined:
      // return hsl.withHue((hsl.hue + 180) % 360).toColor();
      return ColorScheme.of(context).error;
  }
}

Color subgroupByLessonTypeColor(
  BuildContext context,
  LessonTypes type,
  int subgroup,
) {
  final safeSubgroup = subgroup.clamp(0, 2);
  final baseColor = lessonTypeColor(context, type);
  final hsl = HSLColor.fromColor(baseColor);
  final double lightnessOffset = safeSubgroup * 0.05;
  final newLightness = (hsl.lightness - lightnessOffset).clamp(0.0, 1.0);
  return hsl.withLightness(newLightness).toColor();
}

Color textColorForLesson(BuildContext context, Lesson lesson) {
  final blockColor = lessonTypeColor(context, lesson.lessonType);
  final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;

  final contrast =
      blockColor.computeLuminance() - backgroundColor.computeLuminance();

  if (contrast < 0.0) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color textColorForLessonType(BuildContext context, LessonTypes lesson) {
  final blockColor = lessonTypeColor(context, lesson);
  final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;

  final contrast =
      blockColor.computeLuminance() - backgroundColor.computeLuminance();

  if (contrast < 0.0) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color textColorForContainer(BuildContext context, Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : Colors.black;
}
