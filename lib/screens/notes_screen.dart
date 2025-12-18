import 'package:flutter/material.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/widgets/note_widgets.dart';
import 'package:provider/provider.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GroupProcessor, int>(
      selector: (_, processor) => processor.notesCount,
      builder: (context, notesCount, child) {
        if (notesCount > 0) {
          return NotesFromLesson();
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
          final filteredLessons = context
              .read<GroupProcessor>()
              .lessons
              .where((lesson) => lesson.note != null)
              .toList();
          final pendingNotesList = context.read<PendingNotes>().getList();
          return ListView.builder(
            itemCount: filteredLessons.length + pendingNotesList.length,
            itemBuilder: (_, index) {
              if (index < filteredLessons.length) {
                final lesson = filteredLessons[index];
                return Align(
                  child: LessonNoteWidget(
                    lesson: lesson,
                    closedBuilder: () => ScreenNoteView.construct(
                      note: lesson.note ?? Note(title: "", content: ""),
                      label: lesson.label,
                    ),
                  ),
                );
              } else {
                return Align(
                  child: PendingNoteWidget(
                    pendingNote:
                        pendingNotesList[index - filteredLessons.length],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
