import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/models/note.dart';
import 'package:animations/animations.dart';
import 'package:timetable/utils/color_utils.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';

class LessonNoteWidget extends StatelessWidget {
  final Function closedBuilder;
  final Lesson lesson;

  const LessonNoteWidget({
    super.key,
    required this.lesson,
    required this.closedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final processor = context.read<GroupProcessor>();
    final saveSystem = context.read<SaveSystem>();
    return Selector<GroupProcessor, Note>(
      selector: (_, provider) =>
          provider.getNote(lesson) ?? Note(title: "", content: ""),
      builder: (_, note, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: OpenContainer(
            transitionDuration: Duration(milliseconds: 500),
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            closedColor: ColorScheme.of(context).surfaceVariant,
            closedBuilder: (context, action) {
              return GestureDetector(onTap: action, child: closedBuilder());
            },
            openBuilder: (context, action) => FullScreenView(
              action: action,
              note: lesson.note,
              onSave: (note) {
                processor.setNote(lesson, note!);
                saveSystem.saveNotes(processor.lessons);
              },
              onDelete: () {
                processor.deleteNote(lesson);
                saveSystem.saveNotes(processor.lessons);
              },
              label: lesson.label,
            ),
          ),
        );
      },
    );
  }
}

class PendingNoteWidget extends StatelessWidget {
  final PendingNote pendingNote;

  const PendingNoteWidget({super.key, required this.pendingNote});

  @override
  Widget build(BuildContext context) {
    final processor = context.read<GroupProcessor>();
    final saveSystem = context.read<SaveSystem>();
    final pendingNotes = context.read<PendingNotes>();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        closedColor: ColorScheme.of(context).surfaceVariant,
        closedBuilder: (context, action) {
          return GestureDetector(
            onTap: action,
            child: ScreenNoteView.construct(
              note: pendingNote.note ?? Note(title: "", content: ""),
              label: 'Неизвестная дата',
            ),
          );
        },
        openBuilder: (context, action) => FullScreenView(
          action: action,
          note: pendingNote.note ?? Note(title: "", content: ""),
          onSave: (note) {
            processor.setPendingNote(pendingNote, note!);
            saveSystem.savePendingNotes(pendingNotes);
          },
          onDelete: () {
            processor.deletePending(pendingNote);
            saveSystem.savePendingNotes(pendingNotes);
          },
          label: 'Неизвестная дата',
        ),
      ),
    );
  }
}

class ScreenNoteView extends StatelessWidget {
  final Note note;
  final String label;
  const ScreenNoteView.construct({
    super.key,
    required this.note,
    required this.label,
  });

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
              Text(
                note.title,
                style: TextStyle(
                  color: textColorForContainer(
                    context,
                    ColorScheme.of(context).surfaceVariant,
                  ),
                  fontSize: 16,
                ),
              ),
              Text(
                label,
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
  final Note note;
  const ScheduleNoteView.construct({super.key, required this.note});

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
            child: Text(
              note.content,
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
    );
  }
}

class FullScreenView extends StatefulWidget {
  final Note? note;
  final VoidCallback action;
  final ValueChanged<Note?> onSave;
  final VoidCallback onDelete;
  final String label;
  const FullScreenView({
    super.key,
    required this.action,
    required this.note,
    required this.onSave,
    required this.onDelete,
    required this.label,
  });

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  @override
  Widget build(BuildContext context) {
    Note newNote = Note(
      title: widget.note?.title ?? "",
      content: widget.note?.content ?? "",
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
                    _TextContainers(newNote, widget.label),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSave(newNote);
                          //processor.setNote(widget.lesson, newNote);
                          //save.saveNotes(processor.lessons);
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
                          widget.onDelete();
                          //processor.deleteNote(widget.lesson);
                          //save.saveNotes(processor.lessons);
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
  final String label;

  const _TextContainers(this.newNote, this.label);

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
            label,
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
  final String label;
  final Function(Note) onSave;
  const FullScreenNoteEditor({
    super.key,
    required this.initialNote,
    required this.onSave,
    required this.label,
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
                    _TextContainers(editedNote, widget.label),
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
