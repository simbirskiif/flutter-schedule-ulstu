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

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<ExpressiveRefreshIndicatorState> _key = GlobalKey();
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: Random().nextInt(10)));
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<LessonNotes>(context, listen: false);
    return Stack(
      children: [
        SizedBox(
          child: Selector<LessonNotes, List<LessonID>>(
            selector: (_, provider) => provider.keys.toList(),
            builder: (context, keys, children) {
              return ListView.builder(
                itemCount: keys.length,
                itemBuilder: (_, index) => NoteWidget(
                  id: keys[index],
                  closedBuilder: GeneralNoteView(id: keys[index]),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(30),
          alignment: Alignment.bottomRight,
          child: TextButton(
            child: Text('+', style: TextStyle(fontSize: 50)),
            onPressed: () {
              /*notes.add(LessonID(0, 0, 0, ""));*/
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  int week = 0;
                  int day = 0;
                  int index = 0;
                  String name = "";
                  return AlertDialog(
                    title: Text('Введите заметку'),
                    content: Column(
                      children: [
                        TextField(
                          onChanged: (value) => week = int.tryParse(value) ?? 0,
                          decoration: InputDecoration(hintText: "Неделя"),
                        ),
                        TextField(
                          onChanged: (value) => day = int.tryParse(value) ?? 0,
                          decoration: InputDecoration(hintText: "День недели"),
                        ),
                        TextField(
                          onChanged: (value) =>
                              index = int.tryParse(value) ?? 0,
                          decoration: InputDecoration(hintText: "Номер пары"),
                        ),
                        TextField(
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(
                            hintText: "Название предмета",
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          notes.add(LessonID(week, day, index, name));
                          Navigator.of(context).pop();
                        },
                        child: Text('Принять'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
