// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/models/relative_time.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/utils/lesson_time.dart';
import 'package:timetable/utils/string_time_formatter.dart';
import 'package:timetable/widgets/new_lesson_type_widget.dart';
import 'package:provider/provider.dart';
import 'package:timetable/models/note.dart';
import 'note_widgets.dart';

class NewLessonWidget extends StatefulWidget {
  final Lesson lesson;
  const NewLessonWidget({super.key, required this.lesson});

  @override
  State<NewLessonWidget> createState() => _NewLessonWidgetState();
}

class _NewLessonWidgetState extends State<NewLessonWidget> {
  var valueProgressBar = 0.0;
  RelativeTime get relativeTime =>
      widget.lesson.getRelativeTime(DateTime.now());
  late String textDifference = relativeTime.status != LessonTimeStatus.complete
      ? formatRelativeDuration(relativeTime.timeLeft!, relativeTime.status)
      : '';
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (mounted) {
          textDifference = relativeTime.status != LessonTimeStatus.complete
              ? formatRelativeDuration(
                  relativeTime.timeLeft ?? Duration(seconds: 0),
                  relativeTime.status,
                )
              : '';
          if (relativeTime.status == LessonTimeStatus.inProgress) {
            valueProgressBar =
                1 -
                (relativeTime.timeLeft!.inSeconds /
                    Duration(minutes: 80).inSeconds);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<LessonNotes>(context, listen: false);
    return Selector<LessonNotes, Note?>(
      selector: (_, provider) => provider.getNote(widget.lesson.id),
      builder: (context, note, child) => Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 650),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: ColorScheme.of(context).surfaceVariant,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    spacing: 2,
                    children: [
                      Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: SizedBox(
                          child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.only(right: 2),
                                    child: NewLessonTypeWidget(
                                      lessonType: widget.lesson.lessonType,
                                      subgroup: widget.lesson.subgroup,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    color: textColorForContainer(
                                      context,
                                      ColorScheme.of(context).surfaceVariant,
                                    ),
                                  ),
                                  text: widget.lesson.nameOfLesson,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              spacing: 2,
                              children: [
                                Icon(Icons.person),
                                Text(
                                  widget.lesson.teacher,
                                  style: TextStyle(
                                    color: textColorForContainer(
                                      context,
                                      ColorScheme.of(context).surfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentGeometry.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (note == null)
                                  IconButton(
                                    onPressed: () {
                                      notes.add(widget.lesson.id, context);
                                    },
                                    icon: Icon(Icons.add),
                                  )
                                ,
                                // Opacity(
                                //   opacity: note == null ? 1.0 : 0.0,
                                //   child: ElevatedButton(
                                //     onPressed: note == null
                                //         ? () {
                                //             notes.add(
                                //               widget.lesson.id,
                                //               context,
                                //             );
                                //           }
                                //         : null,
                                //     style: ElevatedButton.styleFrom(
                                //       elevation: 0.0,
                                //       backgroundColor: ColorScheme.of(
                                //         context,
                                //       ).surfaceVariant,
                                //     ),
                                //     child: Text(
                                //       '+',
                                //       style: TextStyle(fontSize: 22),
                                //     ),
                                //   ),
                                // ),
                                Text(
                                  widget.lesson.room,
                                  style: TextStyle(
                                    color: textColorForContainer(
                                      context,
                                      ColorScheme.of(context).surfaceVariant,
                                    ),
                                  ),
                                ),
                                Icon(Icons.door_back_door_outlined),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 2,
                        children: [
                          Align(
                            alignment: AlignmentGeometry.centerLeft,
                            child:
                                relativeTime.status != LessonTimeStatus.complete
                                ? Text(
                                    textDifference,
                                    style: TextStyle(
                                      color: textColorForContainer(
                                        context,
                                        ColorScheme.of(context).surfaceVariant,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          relativeTime.status == LessonTimeStatus.inProgress
                              ? LinearProgressIndicatorM3E(
                                  value: valueProgressBar,
                                  size: LinearProgressM3ESize.s,
                                  shape: ProgressM3EShape.wavy,
                                )
                              : SizedBox(height: 1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          note != null
              ? NoteWidget(
                  closedBuilder: ScheduleNoteView(id: widget.lesson.id),
                  id: widget.lesson.id,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
