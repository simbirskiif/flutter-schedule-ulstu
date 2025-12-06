import 'package:flutter/material.dart';
import 'package:timetable/widgets/note_widgets.dart';
import 'package:provider/provider.dart';
import 'package:timetable/processors/group_processor.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GroupProcessor, int>(
      selector: (_, provider) => provider.notesCount,
      builder: (context, _, children) {
        final lessons = context.watch<GroupProcessor>().lessons;
        return ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (_, index) {
            return Visibility(
              visible: lessons[index].note != null,
              // Если виджет не видно, то ListView.builder не вызовет конструктор. Поэтому ошибки не будет, даже если у lessons[index] нет note
              child: Align(
                child: NoteWidget(
                  lesson: lessons[index],
                  closedBuilder: LessonNoteView.construct,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
