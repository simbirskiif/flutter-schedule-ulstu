import 'package:flutter/material.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/widgets/lesson_type_widget.dart';

class NewLessonTypeWidget extends StatefulWidget {
  final int subgroup;
  final LessonTypes lessonType;
  const NewLessonTypeWidget({
    super.key,
    required this.lessonType,
    required this.subgroup,
  });

  @override
  State<NewLessonTypeWidget> createState() => _NewLessonTypeWidgetState();
}

class _NewLessonTypeWidgetState extends State<NewLessonTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 0,
      children: [
        ClipPath(
          clipper: widget.subgroup > 0 ? BeveledRightClipper(bevel: 7) : null,
          child: Container(
            padding: EdgeInsets.only(
              top: 1,
              bottom: 1,
              right: widget.subgroup > 0 ? 8 : 3,
              left: 3,
            ),
            color: lessonTypeColor(context, widget.lessonType),
            child: Text(
              widget.lessonType == LessonTypes.lecture
                  ? "Лекция"
                  : widget.lessonType == LessonTypes.practice
                  ? "Практика"
                  : widget.lessonType == LessonTypes.seminar
                  ? "Лабораторная"
                  : "?",
              style: TextStyle(
                fontSize: 12,
                color: textColorForContainer(
                  context,
                  lessonTypeColor(context, widget.lessonType),
                ),
              ),
            ),
          ),
        ),
        widget.subgroup <= 0
            ? Text("")
            : ClipPath(
                clipper: BeveledLeftClipper(bevel: 7),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 1,
                    bottom: 1,
                    right: 3,
                    left: 8,
                  ),
                  color: subgroupByLessonTypeColor(
                    context,
                    widget.lessonType,
                    widget.subgroup,
                  ),
                  child: Text(
                    "${widget.subgroup}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, widget.lessonType),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class BeveledRightClipper extends CustomClipper<Path> {
  final double bevel;
  BeveledRightClipper({this.bevel = 20});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - bevel, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BeveledRightClipper oldClipper) {
    return oldClipper.bevel != bevel;
  }
}

class BeveledLeftClipper extends CustomClipper<Path> {
  final double bevel;
  BeveledLeftClipper({this.bevel = 20});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(bevel, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant BeveledLeftClipper oldClipper) {
    return oldClipper.bevel != bevel;
  }
}
