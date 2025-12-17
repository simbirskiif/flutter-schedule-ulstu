import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/relative_time.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/settings/tasks_settings.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/utils/lesson_time.dart';
import 'package:timetable/utils/string_time_formatter.dart';
import 'package:timetable/widgets/new_lesson_type_widget.dart';
import 'package:timetable/widgets/remote_lesson_placeholder.dart';
import 'package:timetable/save_system/save_system.dart';
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
    TasksSettings settings = Provider.of<TasksSettings>(context);
    final processor = context.read<GroupProcessor>();
    final save = context.read<SaveSystem>();
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: Column(
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
                        !widget.lesson.isRemote
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                  const Icon(
                                    Icons.door_back_door_outlined,
                                    size: 16,
                                  ),
                                ],
                              )
                            : RemoteLessonPlaceholder(),
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
                    settings.tasksEnabled
                        ? Column(
                            children: [
                              Selector<GroupProcessor, Note?>(
                                selector: (context, provider) =>
                                    provider.getNote(widget.lesson),
                                builder: (context, note, child) {
                                  if (note == null) {
                                    return GestureDetector(
                                      onTap: () async {
                                        processor.setNote(
                                          widget.lesson,
                                          Note(
                                            title: widget.lesson.nameOfLesson,
                                          ),
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenView(
                                                  lesson: widget.lesson,
                                                  action: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                          ),
                                        );
                                      },
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
                                                  color: ColorScheme.of(
                                                    context,
                                                  ).onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                              Selector<GroupProcessor, bool>(
                                selector: (context, provider) {
                                  return provider.nextLessonHasNote(
                                    widget.lesson,
                                  );
                                },
                                builder: (context, nextLessonHasNote, child) {
                                  if (!nextLessonHasNote) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Note initialNote = Note(
                                          title: widget.lesson.nameOfLesson,
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenNoteEditor(
                                                  initialNote: initialNote,
                                                  onSave: (editedNote) =>
                                                      processor.addNoteToNext(
                                                        widget.lesson,
                                                        editedNote,
                                                      ),
                                                ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          const Divider(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.note_add),
                                              SizedBox(width: 4),
                                              Text(
                                                "Добавьте задачу для следующего занятия",
                                                style: TextStyle(
                                                  color: ColorScheme.of(
                                                    context,
                                                  ).onSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            settings.tasksEnabled
                ? Selector<GroupProcessor, Note?>(
                    selector: (context, provider) =>
                        provider.getNote(widget.lesson),
                    builder: (context, note, child) {
                      if (note != null) {
                        return NoteWidget(
                          closedBuilder: ScheduleNoteView.construct,
                          lesson: widget.lesson,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                : SizedBox(),
          ],
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
