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
  @override
  Widget build(BuildContext context) {
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
          body: Column(
            spacing: 10,
            children: [
              LessonWidget(
                mainText: "Основы алгоритмизации и программирование",
              ),
              ChillWidget(height: 80),
              LessonWidget(mainText: "data 2"),
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
