// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'package:animations/animations.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/material.dart';
import 'package:timetable/main.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/widgets/note_widgets.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LessonNotes, List<LessonID>>(
      selector: (_, provider) => provider.keys.toList(),
      builder: (context, keys, children) {
        return ListView.builder(
          itemCount: keys.length,
          itemBuilder: (_, index) => Align(
            child: NoteWidget(
              id: keys[index],
              closedBuilder: LessonNoteView(id: keys[index]),
            ),
          ),
        );
      },
    );
  }
}
