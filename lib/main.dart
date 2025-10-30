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
import 'package:system_theme/system_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timetable/chill_widget.dart' hide Colors;
import 'package:timetable/lesson_widget.dart';
import 'package:timetable/utils/filter.dart';
import 'package:timetable/utils/lessons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;
  runApp(
    DynamicColorBuilder(
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
              // ExpressiveLoadingIndicator(),
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
                            final d = decodeJSON(controller.text);
                            List<Lesson> less = converDumpToLessons(d);
                            less = getLessonsByFilter(
                              Filter(),
                              less,
                            );
                            for (final l in less) {
                              debugPrint(l.toString());
                            }
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
  // GlobalKey<ExpressiveRefreshIndicatorState> _key = GlobalKey();
  final GlobalKey<ExpressiveRefreshIndicatorState> refreshKey = GlobalKey();
  PageController _pageController = PageController(initialPage: 0);
  late final List<DateTime> _days;
  int _currentPage = 0;
  // DateTime a = DateTime(2024);

  // DateTime _focusedDay = DateTime.now();
  DateTime today = DateTime.now();
  // DateTime _selectedDay = DateTime.now();

  ValueNotifier<DateTime> selectedDayNotifier = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> focusedDayNotifier = ValueNotifier(DateTime.now());

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: Random().nextInt(10)));
  }

  @override
  void initState() {
    super.initState();
    _days = List.generate(29, (i) {
      return DateTime.now().subtract(Duration(days: 14)).add(Duration(days: i));
    });
    int initialPage = _days.indexWhere(
      (day) =>
          day.year == today.year &&
          day.month == today.month &&
          day.day == today.day,
    );
    if (initialPage != -1) {
      _pageController = PageController(initialPage: initialPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<DateTime>(
          valueListenable: selectedDayNotifier,
          builder: (context, selectedDay, _) {
            return TableCalendar(
              focusedDay: focusedDayNotifier.value,
              selectedDayPredicate: (day) {
                return day.year == selectedDay.year &&
                    day.month == selectedDay.month &&
                    day.day == selectedDay.day;
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              firstDay: _days.first,
              lastDay: _days.last,
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerVisible: false,
              locale: Localizations.localeOf(context).languageCode,
              onDaySelected: (selectedDay, focusedDay) {
                selectedDayNotifier.value = selectedDay;
                focusedDayNotifier.value = focusedDay;
                int pageIndex = _days.indexWhere((day) {
                  return day.year == selectedDay.year &&
                      day.month == selectedDay.month &&
                      day.day == selectedDay.day;
                });
                if (pageIndex != -1) {
                  _pageController.animateToPage(
                    pageIndex,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
                }
              },
            );
          },
        ),
        MaterialButton(
          child: Icon(Icons.update),
          onPressed: () {
            refreshKey.currentState?.show();
          },
        ),
        Expanded(
          child: PageView.builder(
            itemCount: _days.length,
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
              selectedDayNotifier.value = _days[value];
              focusedDayNotifier.value = _days[value];
            },
            itemBuilder: (context, index) {
              return ExpressiveRefreshIndicator(
                key: index == _currentPage ? refreshKey : GlobalKey(),
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 20,
                  itemBuilder: (_, i) {
                    return ListTile(
                      title: Text("Page: $_currentPage,Element: $i"),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Note {
  String title;
  String content;
  Note(this.title, this.content);
}

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
        MaterialButton(
          child: Icon(Icons.update),
          onPressed: () {
            _key.currentState?.show();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          onPressed: () {
            setState(() {
              String text = (notes.length + 1).toString();
              notes.add(Note(text, ""));
            });
          },
          child: Text('Добавить заметку'),
        ),
        Expanded(
          child: ExpressiveRefreshIndicator(
            key: _key,
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (_, i) => ListTile(
                title: TextFormField(
                  initialValue: notes[i].title,
                  onChanged: (text) {
                    notes[i].title = text;
                  },
                ),
                subtitle: TextFormField(
                  initialValue: notes[i].content,
                  onChanged: (text) {
                    notes[i].content = text;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
