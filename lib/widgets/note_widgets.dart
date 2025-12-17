import 'package:flutter/material.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/lesson.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/utils/day_of_week_table.dart';
import 'package:timetable/save_system/save_system.dart';

class NoteWidget extends StatelessWidget {
  final Lesson lesson;
  final Function closedBuilder;
  const NoteWidget({
    super.key,
    required this.lesson,
    required this.closedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        closedColor: ColorScheme.of(context).surfaceVariant,
        closedBuilder: (context, action) => GestureDetector(
          onTap: action,
          child: closedBuilder(lesson: lesson),
        ),
        openBuilder: (context, action) =>
            FullScreenView(action: action, lesson: lesson),
      ),
    );
  }
}

class LessonNoteView extends StatelessWidget {
  final Lesson lesson;
  const LessonNoteView.construct({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 650),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 26, right: 26, top: 10, bottom: 10),
          child: Column(
            children: [
              Selector<GroupProcessor, Note?>(
                selector: (_, provider) => provider.getNote(lesson),
                builder: (context, note, child) {
                  return Text(
                    note?.title ?? "",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        ColorScheme.of(context).surfaceVariant,
                      ),
                      fontSize: 16,
                    ),
                  );
                },
              ),
              Text(
                '${DayOfWeekTable.get(lesson.day + 1)} | ${lesson.index + 1} пара',
                style: TextStyle(
                  fontSize: 16,
                  color: textColorForContainer(
                    context,
                    ColorScheme.of(context).surfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleNoteView extends StatelessWidget {
  final Lesson lesson;
  const ScheduleNoteView.construct({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        height: 30,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: ColorScheme.of(context).surfaceVariant,
          child: Padding(
            padding: EdgeInsets.only(left: 6, bottom: 6, right: 2),
            child: Selector<GroupProcessor, Note?>(
              selector: (context, provider) => provider.getNote(lesson),
              builder: (context, note, child) => Text(
                note?.content ?? "",
                style: TextStyle(
                  color: textColorForContainer(
                    context,
                    ColorScheme.of(context).surfaceVariant,
                  ),
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenView extends StatefulWidget {
  final Function action;
  final Lesson lesson;
  const FullScreenView({super.key, required this.action, required this.lesson});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  @override
  Widget build(BuildContext context) {
    GroupProcessor processor = context.read<GroupProcessor>();
    SaveSystem save = context.read<SaveSystem>();
    Note newNote = Note(
      title: widget.lesson.note?.title ?? "",
      content: widget.lesson.note?.content ?? "",
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: "tag",
          child: Material(
            color: ColorScheme.of(context).surfaceVariant,
            child: SizedBox.expand(
              child: Center(
                child: Stack(
                  children: [
                    _TextContainers(newNote, widget.lesson),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          processor.setNote(widget.lesson, newNote);
                          save.saveNotes(processor.lessons);
                          widget.action();
                        },
                        child: Text("Сохранить"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          processor.deleteNote(widget.lesson);
                          save.saveNotes(processor.lessons);
                          widget.action();
                        },
                        child: Text("Удалить"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextContainers extends StatelessWidget {
  final Note newNote;
  final Lesson? lesson;

  const _TextContainers(this.newNote, this.lesson);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(
              fontSize: 30,
              color: textColorForContainer(
                context,
                ColorScheme.of(context).surfaceVariant,
              ),
            ),
            decoration: InputDecoration(border: InputBorder.none),
            initialValue: newNote.title,
            onChanged: (value) => newNote.title = value,
            textAlign: TextAlign.center,
          ),
          Text(
            lesson != null
                ? '${DayOfWeekTable.get(lesson!.day + 1)} | ${lesson!.index + 1} пара'
                : 'Неизвестная дата',
            style: TextStyle(
              fontSize: 20,
              color: textColorForContainer(
                context,
                ColorScheme.of(context).surfaceVariant,
              ),
            ),
          ),
          Divider(
            color: textColorForContainer(
              context,
              ColorScheme.of(context).surfaceVariant,
            ),
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                color: textColorForContainer(
                  context,
                  ColorScheme.of(context).surfaceVariant,
                ),
              ),
              initialValue: newNote.content,
              onChanged: (value) => newNote.content = value,
              expands: true,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Введите текст заметки',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenNoteEditor extends StatefulWidget {
  final Note initialNote;
  final Function(Note) onSave;
  const FullScreenNoteEditor({
    super.key,
    required this.initialNote,
    required this.onSave,
  });

  @override
  State<FullScreenNoteEditor> createState() => _FullScreenNoteEditorState();
}

class _FullScreenNoteEditorState extends State<FullScreenNoteEditor> {
  late Note editedNote;

  @override
  void initState() {
    super.initState();
    editedNote = Note(
      title: widget.initialNote.title,
      content: widget.initialNote.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: "next_note_tag",
          child: Material(
            color: ColorScheme.of(context).surfaceVariant,
            child: SizedBox.expand(
              child: Center(
                child: Stack(
                  children: [
                    _TextContainers(editedNote, null),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSave(editedNote);
                          Navigator.pop(context);
                        },
                        child: Text("Сохранить"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
