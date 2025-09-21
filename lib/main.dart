// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import

import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:system_theme/system_theme.dart';
import 'package:timetable/chill_widget.dart' hide Colors;
import 'package:timetable/lesson_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  SystemTheme.accentColor.accent;
  final accentColor = SystemTheme.accentColor.accent;
  // debugPaintSizeEnabled = true;
  runApp(Main(accentColor: accentColor,));
}

class Main extends StatefulWidget {
  final Color accentColor;
  const Main({super.key, required this.accentColor});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        useSystemColors: true,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
        ),
        useSystemColors: true,
        useMaterial3: true,
      ),
      home: Builder(
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
                LessonWidget(mainText: "data"),
                ChillWidget(height: 80),
                LessonWidget(mainText: "data 2"),
              ],
            ),
          );
        },
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
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
                  padding: const EdgeInsets.all(16),
                  child: Card.filled(
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
