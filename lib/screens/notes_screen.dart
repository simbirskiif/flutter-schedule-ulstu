// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'package:animations/animations.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/material.dart';
import 'package:timetable/main.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/screens/schedule_screen.dart';

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

  List<Note> notes = [Note("12", "12")];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MaterialButton(
        //   child: Icon(Icons.update),
        //   onPressed: () {
        //     _key.currentState?.show();
        //   },
        // ),
        // TextButton(
        //   style: TextButton.styleFrom(foregroundColor: Colors.blue),
        //   onPressed: () {
        //     setState(() {
        //       String text = (notes.length + 1).toString();
        //       notes.add(Note(text, ""));
        //     });
        //   },
        //   child: Text('Добавить заметку'),
        // ),
        // Expanded(
        //   child: ExpressiveRefreshIndicator.contained(
        //     backgroundColor: ColorScheme.of(context).primaryContainer,
        //     color: ColorScheme.of(context).onPrimaryContainer,
        //     key: _key,
        //     onRefresh: _onRefresh,
        //     child: ListView.builder(
        //       physics: BouncingScrollPhysics(),
        //       itemCount: notes.length,
        //       itemBuilder: (_, i) => ListTile(
        //         title: TextFormField(
        //           initialValue: notes[i].title,
        //           onChanged: (text) {
        //             notes[i].title = text;
        //           },
        //         ),
        //         subtitle: TextFormField(
        //           initialValue: notes[i].content,
        //           onChanged: (text) {
        //             notes[i].content = text;
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: InitialCard(),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: OpenContainerTest(),
        ),
      ],
    );
  }
}

class InitialCard extends StatelessWidget {
  const InitialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, _createRoute());
      },
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 150,
          // color: ColorScheme.of(context).surfaceContainer,
          child: Padding(
            padding: EdgeInsetsGeometry.all(0),
            child: Hero(
              tag: "tag",
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: ColorScheme.of(context).surfaceVariant,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "data",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenView extends StatelessWidget {
  const FullScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: "tag",
          child: Material(
            color: ColorScheme.of(context).surfaceVariant,
            child: SizedBox.expand(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "data",
                      style: TextStyle(color: Colors.black, fontSize: 48),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close"),
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

PageRouteBuilder _createRoute() {
  return PageRouteBuilder(
    // Целевой виджет
    pageBuilder: (context, animation, secondaryAnimation) =>
        const FullScreenView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    opaque: false,
    fullscreenDialog: true,
    transitionDuration: const Duration(milliseconds: 500),
  );
}

class OpenContainerTest extends StatelessWidget {
  const OpenContainerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      closedColor: ColorScheme.of(context).surfaceVariant,
      closedBuilder: (context, action) {
        return GestureDetector(
          onTap: () {
            action();
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: ColorScheme.of(context).surfaceVariant,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "data",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
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
                color: ColorScheme.of(context).surfaceVariant,
                child: SizedBox.expand(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "data",
                          style: TextStyle(color: Colors.black, fontSize: 48),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            action();
                          },
                          child: Text("Close"),
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
    );
  }
}
