import 'package:flutter/material.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/widgets/note_widgets.dart';
import 'package:provider/provider.dart';
import 'package:timetable/processors/group_processor.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GroupProcessor, int>(
      selector: (_, processor) => processor.notesCount,
      builder: (context, notesCount, child) {
        if (notesCount > 0) {
          return Column(children: [NotesFromLesson()]);
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list_off, size: 64),
                Text(
                  "Задач нет",
                  style: TextStyle(color: ColorScheme.of(context).onSurface),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

/*class PendingNotesView extends StatelessWidget {
  const PendingNotesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<PendingNotes, List<Note>>(
        selector: (_, provider) => provider.listOfNotes,
        builder: (context, notes, children) {
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, index) {
                  NoteWidget(
                    : notes[index],
                    closedBuilder: LessonNoteView.construct,
              );
            },
          );
        },
      ),
    );
  }
}*/

class NotesFromLesson extends StatelessWidget {
  const NotesFromLesson({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<GroupProcessor, int>(
        selector: (_, provider) => provider.notesCount,
        builder: (context, _, children) {
          final lessons = context.read<GroupProcessor>().lessons;
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (_, index) {
              return Visibility(
                visible: lessons[index].note != null,
                // Если виджет не видно, то ListView.builder не вызовет конструктор. Поэтому ошибки не будет, даже если у lessons[index] нет note
                child: Align(
                  child: NoteWidget(
                    lesson: lessons[index],
                    closedBuilder: ScreenNoteView.construct,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
