// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'package:animations/animations.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/material.dart';
import 'package:timetable/main.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/screens/schedule_screen.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';
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
                itemBuilder: (_, index) => OpenContainerTest(id: keys[index]),
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
              notes.add(
                LessonID(0, 0, 0, ""),
                Note('Заметка #${notes.length}', ""),
              );
              /*showDialog(
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
                          notes.add(
                            LessonID(week, day, index, name),
                            Note('$name/$week/$day', ""),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('Принять'),
                      ),
                    ],
                  );
                },
              );*/
            },
          ),
        ),
      ],
    );
  }
}

class TextContainer extends StatelessWidget {
  final LessonID id;
  const TextContainer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Selector<LessonNotes, Note?>(
      selector: (_, provider) => provider.getNote(id),
      builder: (context, note, child) {
        return Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(fontSize: 44, color: Colors.white),
                initialValue: note?.title ?? "",
                onChanged: (value) => note?.setTitle(value),
              ),
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  initialValue: note?.content ?? "",
                  onChanged: (value) => note?.setContent(value),
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
      },
    );
  }
}

class OpenContainerTest extends StatelessWidget {
  final LessonID id;
  //Color(0x442D9CFF);
  const OpenContainerTest({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Color shapeColor = Theme.of(context).colorScheme.primaryContainer;
    final model = Provider.of<LessonNotes>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 0),
      child: OpenContainer(
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
        closedColor: shapeColor,
        closedBuilder: (context, action) {
          return GestureDetector(
            onTap: () {
              action();
            },
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                //child: Material(
                //borderRadius: BorderRadius.circular(16),
                //color: fig_col,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Selector<LessonNotes, String>(
                        selector: (_, provider) =>
                            provider.getNote(id)?.title ?? "",
                        builder: (context, value, child) {
                          return Text(
                            value,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //),
              ),
            ),
          );
        },
        openBuilder: (context, action) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Hero(
                tag: "tag",
                child: Material(
                  color: shapeColor, //ColorScheme.of(context).surfaceVariant,
                  child: SizedBox.expand(
                    child: Center(
                      child: Stack(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextContainer(id: id),
                          SizedBox(height: 20),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.all(30),
                            child: ElevatedButton(
                              onPressed: () {
                                action();
                              },
                              child: Text("Закрыть"),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: EdgeInsets.all(30),
                            child: ElevatedButton(
                              onPressed: () {
                                action();
                                model.delNote(id);
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
        },
      ),
    );
  }
}
