// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:ffi';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:system_theme/system_theme.dart';
import 'package:timetable/chill_widget.dart' hide Colors;
import 'package:timetable/lesson_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;
  runApp(
    DynamicColorBuilder(
      builder: (ColorScheme? light, ColorScheme? dark) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            colorScheme: dark,
            useMaterial3: true,
            useSystemColors: true,
          ),
          theme: ThemeData(
            colorScheme: light,
            useSystemColors: true,
            useMaterial3: true,
          ),
          home: Main(),
        );
      },
    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedScreen = 0;
  bool _smallScreen = true;
  final List<Widget> _screens = [ScheduleScreen(), NotesScreen()];
  @override
  Widget build(BuildContext context) {
    _smallScreen = MediaQuery.of(context).size.width < 650 ? true : false;
    return Builder(
      builder: (innerContext) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Test"),
            actions: [
              MaterialButton(
                onPressed: () {
                  showBottomSheet(innerContext);
                },
                child: Text("Change group"),
              ),
            ],
          ),
          bottomNavigationBar: !_smallScreen
              ? null
              : NavigationBar(
                  destinations: const <Widget>[
                    NavigationDestination(
                      icon: Icon(Icons.schedule),
                      label: "Расписание",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.notes),
                      label: "Заметки???",
                    ),
                  ],
                  selectedIndex: _selectedScreen,
                  onDestinationSelected: (value) => {
                    setState(() {
                      _selectedScreen = value;
                    }),
                  },
                ),
          body: Row(
            children: [
              _smallScreen
                  ? Text("")
                  : NavigationRail(
                      labelType: NavigationRailLabelType.all,
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.schedule),
                          label: Text("Расписание"),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.notes),
                          label: Text("Заметки????"),
                        ),
                      ],
                      selectedIndex: _selectedScreen,
                      onDestinationSelected: (value) {
                        setState(() {
                          _selectedScreen = value;
                        });
                      },
                    ),
              Expanded(
                child: IndexedStack(index: _selectedScreen, children: _screens),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(),
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Card.filled(
                    color: ColorScheme.of(context).surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text("data"),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Name"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            spacing: 10,
            children: [
              TextField(),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
              LessonWidget(
                mainText: "Основы ПИ",
                testColor: Colors.yellow,
                testAud: "3-419",
                testPrepod: "Ровенская А И",
                testProgress: 0.5,
                testTime: "Еще 40 минут",
                testType: "Лабораторная",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("data")]);
  }
}
