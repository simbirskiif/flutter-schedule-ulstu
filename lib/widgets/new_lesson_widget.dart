import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/relative_time.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/utils/lesson_time.dart';
import 'package:timetable/utils/string_time_formatter.dart';
import 'package:timetable/widgets/new_lesson_type_widget.dart';
import 'note_widgets.dart';

class NewLessonWidget extends StatefulWidget {
  final Lesson lesson;
  const NewLessonWidget({super.key, required this.lesson});

  @override
  State<NewLessonWidget> createState() => _NewLessonWidgetState();
}

class _NewLessonWidgetState extends State<NewLessonWidget> {
  double valueProgressBar = 0.0;
  late String textDifference;
  late Timer _timer;

  RelativeTime get relativeTime =>
      widget.lesson.getRelativeTime(DateTime.now());

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      _updateTime();
    });
  }

  void _updateTime() {
    final time = relativeTime;
    setState(() {
      textDifference = time.status != LessonTimeStatus.complete
          ? formatRelativeDuration(time.timeLeft ?? Duration.zero, time.status)
          : '';
      valueProgressBar = time.status == LessonTimeStatus.inProgress
          ? 1 - (time.timeLeft!.inSeconds / Duration(minutes: 80).inSeconds)
          : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<LessonNotes>(context, listen: false);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: Selector<LessonNotes, Note?>(
          selector: (_, provider) => provider.getNote(widget.lesson.id),
          builder: (context, note, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                borderRadius: BorderRadius.circular(16),
                color: ColorScheme.of(context).surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 2,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: NewLessonTypeWidget(
                                  lessonType: widget.lesson.lessonType,
                                  subgroup: widget.lesson.subgroup,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: widget.lesson.nameOfLesson,
                              style: TextStyle(
                                color: textColorForContainer(
                                  context,
                                  ColorScheme.of(context).surfaceVariant,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.lesson.teacher,
                              style: TextStyle(
                                color: textColorForContainer(
                                  context,
                                  ColorScheme.of(context).surfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.lesson.room,
                            style: TextStyle(
                              color: textColorForContainer(
                                context,
                                ColorScheme.of(context).surfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.door_back_door_outlined, size: 16),
                        ],
                      ),
                      if (relativeTime.status != LessonTimeStatus.complete)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            textDifference,
                            style: TextStyle(
                              color: textColorForContainer(
                                context,
                                ColorScheme.of(context).surfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      if (relativeTime.status == LessonTimeStatus.inProgress)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: SizedBox(
                            height: 6,
                            child: LinearProgressIndicatorM3E(
                              value: valueProgressBar,
                              size: LinearProgressM3ESize.s,
                              shape: ProgressM3EShape.wavy,
                            ),
                          ),
                        ),
                      if (note == null)
                        GestureDetector(
                          onTap: () => notes.add(widget.lesson.id, context),
                          child: Column(
                            children: [
                              const Divider(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 4),
                                  Text(
                                    "Добавьте задачу для этого занятия",
                                    style: TextStyle(
                                      color: ColorScheme.of(context).onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (note != null)
                NoteWidget(
                  closedBuilder: ScheduleNoteView(id: widget.lesson.id),
                  id: widget.lesson.id,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
