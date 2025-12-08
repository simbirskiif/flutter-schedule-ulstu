// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'dart:ui';
import 'package:button_m3e/button_m3e.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';
import 'package:timetable/dialog/login_dialog.dart';
import 'package:timetable/main.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/utils/lessons.dart';
import 'package:timetable/utils/string_time_formatter.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // GlobalKey<ExpressiveRefreshIndicatorState> _key = GlobalKey();
  final GlobalKey<ExpressiveRefreshIndicatorState> refreshKey = GlobalKey();
  PageController _pageController = PageController();
  // late final List<DateTime> _days;
  int _currentPage = 0;
  bool _isPageControllerInitialized = false;
  // DateTime a = DateTime(2024);

  // DateTime _focusedDay = DateTime.now();
  DateTime today = DateTime.now();
  // DateTime _selectedDay = DateTime.now();

  // ValueNotifier<DateTime> selectedDayNotifier = ValueNotifier(DateTime.now());
  // ValueNotifier<DateTime> focusedDayNotifier = ValueNotifier(DateTime.now());

  Future<void> _onRefresh() async {
    await context.read<GroupProcessor>().updateFromGroup();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final processor = context.read<GroupProcessor>();
    //   final days = processor.days;
    //   int initialPage = days.indexWhere(
    //     (day) =>
    //         day.year == DateTime.now().year &&
    //         day.month == DateTime.now().month &&
    //         day.day == DateTime.now().day,
    //   );

    //   _pageController = PageController(
    //     initialPage: initialPage != -1 ? initialPage : 0,
    //   );

    //   setState(() {});
    // });
    // final processor = context.read<GroupProcessor>();

    // int initialPage = processor.getInitialDayIndex(today: DateTime.now());

    // if (initialPage != -1) {
    //   setState(() {
    //     _pageController = PageController(initialPage: initialPage);
    //   });
    // } else {
    //   _pageController = PageController(initialPage: 0);
    // }

    // _days = List.generate(29, (i) {
    //   return DateTime.now().subtract(Duration(days: 14)).add(Duration(days: i));
    // });
    // int initialPage = _days.indexWhere(
    //   (day) =>
    //       day.year == today.year &&
    //       day.month == today.month &&
    //       day.day == today.day,
    // );
    // if (initialPage != -1) {
    //   _pageController = PageController(initialPage: initialPage);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final processor = context.watch<GroupProcessor>();
    // final manager = context.watch<SessionManager>();
    final selectedDay = processor.selectedDay ?? today;
    final days = processor.days;
    if (!days.isNotEmpty) {
      return Center(
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.login, size: 48),
            Text(
              "Войдите в аккаунт",
              style: TextStyle(color: ColorScheme.of(context).onSurface),
            ),
            ButtonM3E(
              onPressed: () {
                showLoginDialogSecure(context);
              },
              label: Text("Войти"),
              style: ButtonM3EStyle.outlined,
              icon: Icon(Icons.key_rounded),
            ),
          ],
        ),
      );
    }
    if (context.read<SessionManager>().isLoggining &&
        context.read<GroupProcessor>().lessons.isEmpty) {
      return Center(child: LoadingIndicatorM3E());
    }
    if (context.read<GroupProcessor>().isLoading &&
        context.read<GroupProcessor>().lessons.isEmpty) {
      return Center(child: LoadingIndicatorM3E());
    }
    if (days.isEmpty &&
        !context.read<SessionManager>().isLoggining &&
        context.read<GroupProcessor>().lessons.isEmpty) {
      return const Center(child: Text("Нет данных"));
    }
    if (!_isPageControllerInitialized) {
      int initialPage = days.indexWhere(
        (day) =>
            day.year == today.year &&
            day.month == today.month &&
            day.day == today.day,
      );
      initialPage = initialPage != -1 ? initialPage : 0;
      _pageController = PageController(initialPage: initialPage);
      _currentPage = initialPage;
      _isPageControllerInitialized = true;
      if (initialPage != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          processor.setSelectedDay(days[initialPage]);
        });
      }
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  int week = getWeekFromDate(selectedDay);
                  // for (var lesson in processor.lessons) {
                  //   if (lesson.dateTime.day == selectedDay.day &&
                  //       lesson.dateTime.month == selectedDay.month &&
                  //       lesson.dateTime.year == selectedDay.year) {
                  //     week = lesson.week;
                  //   }
                  // }
                  return Text(
                    "$week-я неделя",
                    style: TextStyle(
                      color: ColorScheme.of(context).onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              Spacer(),
              Text(
                dayFormat(selectedDay),
                style: TextStyle(color: ColorScheme.of(context).onSurface),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: TableCalendar(
            focusedDay: selectedDay,
            selectedDayPredicate: (day) {
              return day.year == selectedDay.year &&
                  day.month == selectedDay.month &&
                  day.day == selectedDay.day;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final weekDay = DateFormat("E", "ru").format(day);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        weekDay,
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorScheme.of(context).onSecondaryContainer,
                        ),
                      ),
                      SizedBox(height: 0),
                      Text(
                        "${day.day}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorScheme.of(context).onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final weekDay = DateFormat("E", "ru").format(day);
                return SizedBox(
                  width: 45,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Text(
                          weekDay,
                          style: TextStyle(
                            fontSize: 10,
                            color: ColorScheme.of(context).onSecondary,
                          ),
                        ),
                        SizedBox(height: 0),
                        Text(
                          "${day.day}",
                          style: TextStyle(
                            color: ColorScheme.of(context).onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                final weekDay = DateFormat("E", "ru").format(day);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Text(
                        weekDay,
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorScheme.of(context).onSecondaryContainer,
                        ),
                      ),
                      SizedBox(height: 0),
                      Text(
                        "${day.day}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorScheme.of(context).onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              disabledDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              withinRangeDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              outsideDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                // border: Border.all(width: 10, ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                // border: Border.all(width: 10, ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            firstDay: days.first,
            lastDay: days.last,
            calendarFormat: CalendarFormat.week,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            daysOfWeekVisible: false,
            locale: Localizations.localeOf(context).languageCode,
            onDaySelected: (newSelectedDay, focusedDay) {
              processor.setSelectedDay(newSelectedDay);
              int pageIndex = days.indexWhere((day) {
                return day.year == newSelectedDay.year &&
                    day.month == newSelectedDay.month &&
                    day.day == newSelectedDay.day;
              });
              if (pageIndex != -1) {
                _pageController.animateToPage(
                  pageIndex,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ),
        // MaterialButton(
        //   child: Icon(Icons.update),
        //   onPressed: () {
        //     refreshKey.currentState?.show();
        //   },
        // ),
        Expanded(
          child: PageView.builder(
            itemCount: days.length,
            pageSnapping: true,
            key: PageStorageKey("1"),
            controller: _pageController,
            onPageChanged: (value) {
              final processor = context.read<GroupProcessor>();
              setState(() {
                _currentPage = value;
              });
              // selectedDayNotifier.value = _days[value];
              // focusedDayNotifier.value = _days[value];
              processor.setSelectedDay(processor.days[value]);
            },
            itemBuilder: (context, index) {
              DateTime pageDay = days[index];
              final lessons = processor.getLessonsForDay(pageDay);
              return ExpressiveRefreshIndicator.contained(
                edgeOffset: 0.5,
                backgroundColor: ColorScheme.of(context).primaryContainer,
                color: ColorScheme.of(context).onPrimaryContainer,
                key: index == _currentPage ? refreshKey : null,
                onRefresh: _onRefresh,
                child: lessons.isEmpty
                    ? Center(
                        child: Text(
                          "Нет данных для этого дня",
                          style: TextStyle(
                            color: ColorScheme.of(context).onBackground,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: NewLessonWidget(lesson: lessons[index]),
                          );
                        },
                      ),
                // child: ListView.builder(
                //   physics: BouncingScrollPhysics(
                //     decelerationRate: ScrollDecelerationRate.normal,
                //   ),
                //   itemCount: 20,
                //   itemBuilder: (_, i) {
                //     return ListTile(title: Text("Page: $index,Element: $i"));
                //   },
                // ),
              );
            },
          ),
        ),
      ],
    );
  }
}
