// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use, use_build_context_synchronously
import 'dart:convert';
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
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:progress_indicator_m3e/progress_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';
import 'package:timetable/dialog/login_dialog.dart';
import 'package:timetable/dialog/setup_dialog.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/models/filter.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/other/debug_window.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';
import 'package:timetable/settings/tasks_settings.dart';
import 'package:timetable/widgets/lesson_widget.dart';
import 'package:timetable/screens/notes_screen.dart';
import 'package:timetable/screens/schedule_screen.dart';
import 'package:timetable/utils/filter.dart';
import 'package:timetable/utils/lessons.dart';
import 'package:timetable/models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final saveSystem = SaveSystem();
  await saveSystem.init();

  final groupProcessor = GroupProcessor();
  groupProcessor.getSaveSystem(saveSystem);

  SessionManager sessionManager = SessionManager();
  TasksSettings tasksSettings = TasksSettings(saveSystem.prefs);

  //Provider.debugCheckInvalidValueType = null;
  // debugPaintSizeEnabled = true;
  // PlatformDispatcher.instance.onReportTimings = (timings) {
  //   debugPrint('Frame timings: ${timings.length}');
  // };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sessionManager),
        ChangeNotifierProvider(create: (_) => tasksSettings),
        ChangeNotifierProxyProvider<SessionManager, GroupProcessor>(
          create: (_) => groupProcessor,
          update: (context, session, group) => group!..updateSession(session),
        ),
        // ListenableProvider<GroupProcessor>.value(value: GroupProcessor()),
        Provider<SaveSystem>.value(value: saveSystem),
        // ListenableProvider<SessionManager>.value(value: SessionManager()),
      ],
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
            home: SplashScreen(),
          );
        },
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final save = context.read<SaveSystem>();
    final session = context.read<SessionManager>();
    final processor = context.read<GroupProcessor>();

    // Попытаемся загрузить локальные уроки сразу
    final savedLessons = save.loadLessons();
    if (savedLessons != null && savedLessons.isNotEmpty) {
      // Загрузить локальную копию расписания и подгруппу
      processor.updateFromRaw(savedLessons);
      final savedSub = save.loadSubGroup() ?? 1;
      processor.setSubgroup(savedSub);
      // Восстановить сохранённую группу в сессии (если есть)
      final savedGroup = save.loadGroupName();
      if (savedGroup != null) {
        session.group = savedGroup;
      }

      // Открываем приложение — не дожидаясь логина (логин будет происходить фоном)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Main()),
      );

      // Фоновая попытка логина/обновления данных
      final login = await save.getLogin();
      final password = await save.getPassword();
      if (login != null && password != null) {
        final status = await session.login(login, password);
        if (status == OnlineStatus.ok) {
          await session.fetchUserData();
          // Обновим расписание с сервера при успешном логине
          await processor.updateFromGroup();
          // восстановим сохранённую подгруппу после обновления
          final sub = save.loadSubGroup() ?? savedSub;
          processor.setSubgroup(sub);
        } else {
          session.offline = true;
        }
      }
      return;
    }

    // Если локальных уроков нет — старое поведение: пробуем из secure storage получить логин/пароль и логинимся
    final login = await save.getLogin();
    final password = await save.getPassword();

    if (login != null && password != null) {
      final status = await session.login(login, password);

      if (!mounted) return;

      if (status == OnlineStatus.ok) {
        await session.fetchUserData();
        await processor.updateFromGroup();
        processor.setSubgroup(save.loadSubGroup() ?? 1);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Main()),
        );

        return;
      } else {
        processor.updateFromRaw(save.loadLessons() ?? "");
        processor.setSubgroup(save.loadSubGroup() ?? 1);
        session.offline = true;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Main()),
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Main()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: LoadingIndicatorM3E()));
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() {
    return _MainState();
  }
}

class _MainState extends State<Main> {
  int _selectedScreen = 0;
  bool _smallScreen = true;
  final List<Widget> _screens = [ScheduleScreen(), NotesScreen()];

  @override
  Widget build(BuildContext context) {
    TasksSettings tasksSettings = Provider.of<TasksSettings>(context);
    if (_selectedScreen > 0 && tasksSettings.tasksEnabled == false) {
      setState(() {
        _selectedScreen = 0;
      });
    }
    _smallScreen = MediaQuery.of(context).size.width < 650 ? true : false;
    GroupProcessor processor = Provider.of<GroupProcessor>(context);
    SessionManager session = Provider.of<SessionManager>(context);
    return Builder(
      builder: (innerContext) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              processor.groupName != null ? session.group! : "Расписание",
            ),
            actions: [
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return DebugWindow();
              //         },
              //       ),
              //     );
              //   },
              //   child: Icon(Icons.bug_report),
              // ),
              // MaterialButton(
              //   onPressed: () {
              //     final controller = TextEditingController();
              //     showDialog(
              //       context: innerContext,
              //       builder: (context) => AlertDialog(
              //         title: Text("JSON"),
              //         content: TextField(
              //           controller: controller,
              //           decoration: InputDecoration(hintText: "JSON полный"),
              //         ),
              //         actions: [
              //           TextButton(
              //             onPressed: () => Navigator.pop(context),
              //             child: Text("Отмена"),
              //           ),
              //           TextButton(
              //             onPressed: () {
              //               // final d = decodeJSON(controller.text);
              //               // List<Lesson> less = converDumpToLessons(d);
              //               // less = getLessonsByFilter(Filter(), less);
              //               // for (final l in less) {
              //               //   debugPrint(l.toString());
              //               // }
              //               final save = context.read<SaveSystem>();
              //               final processor = context.read<GroupProcessor>();
              //               save.saveLessons(controller.text);
              //               processor.updateFromRaw(controller.text);
              //               processor.setSubgroup(2, context);
              //             },
              //             child: Text("Принять"),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              //   child: Icon(Icons.code),
              // ),
              IconButton(
                onPressed: () {
                  showBottomSheet(innerContext);
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
          bottomNavigationBar: _smallScreen && tasksSettings.tasksEnabled
              ? NavigationBar(
                  destinations: const <Widget>[
                    NavigationDestination(
                      icon: Icon(Icons.schedule),
                      label: "Расписание",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.notes),
                      label: "Задачи",
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
                )
              : null,
          body: Row(
            children: [
              _smallScreen || !tasksSettings.tasksEnabled
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
                          label: Text("Задачи"),
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
        SessionManager manager = Provider.of<SessionManager>(context);
        TasksSettings? tasksSettings = Provider.of<TasksSettings?>(
          context,
          listen: true,
        );
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
                              child: !manager.loggedIn && !manager.offline
                                  ? OutlinedButton(
                                      onPressed: () {
                                        showLoginDialogSecure(context);
                                      },
                                      child: Text("Войти"),
                                    )
                                  : manager.isLoggining
                                  ? CircularProgressIndicatorM3E()
                                  : FilledButton(
                                      onPressed: () {
                                        showSetupDialog(context);
                                      },
                                      child: Text("Управлять"),
                                    ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                manager.name != null
                                    ? "${manager.name!.split(" ")[1]} "
                                    : manager.userName ?? "Войдите в аккаунт",
                                style: TextStyle(
                                  color: ColorScheme.of(context).onSurface,
                                ),
                              ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListTile(
                    leading: Icon(Icons.task),
                    title: Text("Включить отображение меню задач"),
                    trailing: Switch(
                      value: tasksSettings?.tasksEnabled ?? true,
                      onChanged: (bool value) {
                        tasksSettings?.tasksEnabled = value;
                      },
                    ),
                    onTap: () {
                      tasksSettings?.tasksEnabled =
                          !(tasksSettings.tasksEnabled);
                    },
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
