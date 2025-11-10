// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'dart:ui';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: TableCalendar(
                focusedDay: focusedDayNotifier.value,
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
                              color: ColorScheme.of(
                                context,
                              ).onSecondaryContainer,
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            "${day.day}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorScheme.of(
                                context,
                              ).onSecondaryContainer,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
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
                              color: ColorScheme.of(
                                context,
                              ).onSecondaryContainer,
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            "${day.day}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorScheme.of(
                                context,
                              ).onSecondaryContainer,
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
                firstDay: _days.first,
                lastDay: _days.last,
                calendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                daysOfWeekVisible: false,
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
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            );
          },
        ),
        // MaterialButton(
        //   child: Icon(Icons.update),
        //   onPressed: () {
        //     refreshKey.currentState?.show();
        //   },
        // ),
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
              return ExpressiveRefreshIndicator.contained(
                edgeOffset: 0.5,
                backgroundColor: ColorScheme.of(context).primaryContainer,
                color: ColorScheme.of(context).onPrimaryContainer,
                key: index == _currentPage ? refreshKey : GlobalKey(),
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  itemCount: 20,
                  itemBuilder: (_, i) {
                    return ListTile(title: Text("Page: $index,Element: $i"));
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
