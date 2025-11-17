// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timetable/models/filter.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/other/debug_window.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/widgets/lesson_widget.dart';
import 'package:timetable/screens/notes_screen.dart';
import 'package:timetable/screens/schedule_screen.dart';
import 'package:timetable/utils/filter.dart';
import 'package:timetable/utils/lessons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;
  // PlatformDispatcher.instance.onReportTimings = (timings) {
  //   debugPrint('Frame timings: ${timings.length}');
  // };
  runApp(
    ChangeNotifierProvider(
      create: (context) => GroupProcessor(),
      child: DynamicColorBuilder(
        builder: (ColorScheme? light, ColorScheme? dark) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale("en", ""), Locale("ru", "")],
            locale: Locale("ru"),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            darkTheme: ThemeData(
              textTheme: GoogleFonts.openSansTextTheme(),
              colorScheme: dark,
              useMaterial3: true,
              useSystemColors: true,
            ),
            theme: ThemeData(
              textTheme: GoogleFonts.openSansTextTheme(),
              colorScheme: light,
              useSystemColors: true,
              useMaterial3: true,
            ),
            home: Main(),
          );
        },
      ),
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
              // ExpressiveLoadingIndicator(),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DebugWindow();
                      },
                    ),
                  );
                },
                child: Icon(Icons.bug_report),
              ),
              MaterialButton(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(
                    context: innerContext,
                    builder: (context) => AlertDialog(
                      title: Text("JSON"),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: "JSON полный"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Отмена"),
                        ),
                        TextButton(
                          onPressed: () {
                            // final d = decodeJSON(controller.text);
                            // List<Lesson> less = converDumpToLessons(d);
                            // less = getLessonsByFilter(Filter(), less);
                            // for (final l in less) {
                            //   debugPrint(l.toString());
                            // }
                            final processor = context.read<GroupProcessor>();
                            processor.updateFromRaw(controller.text);
                            processor.setSubgroup(2);
                          },
                          child: Text("Принять"),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.code),
              ),
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
                  labelBehavior: Platform.isAndroid || Platform.isIOS
                      ? NavigationDestinationLabelBehavior.alwaysShow
                      : NavigationDestinationLabelBehavior.alwaysHide,
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

  // double value = 0;
  // void plus() {
  //   setState(() {
  //     value += 0.1;
  //     if (value > 1) {
  //       value = 0;
  //       debugPrint(">0");
  //     }
  //   });
  // }

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
                // CircularProgressIndicatorM3E(value: 0.6),
                // ElevatedButton(
                //   onPressed: () {
                //     debugPrint("plus");
                //     plus();
                //   },
                //   child: Text("data"),
                // ),
                // LinearProgressIndicatorM3E(value: value),
              ],
            ),
          ),
        );
      },
    );
  }
}
