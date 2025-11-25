import 'package:flutter/material.dart';
import 'package:timetable/api/login_manager.dart';
import 'package:timetable/api/user_data_fetch.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';
import 'package:timetable/dialog/login_dialog.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/models/lesson.dart';
import 'package:timetable/widgets/lesson_type_widget.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';
import 'package:timetable/utils/color_utils.dart';

class DebugWindow extends StatelessWidget {
  const DebugWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.lecture),
                  child: Text(
                    "Лекция",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.lecture),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.practice),
                  child: Text(
                    "Практика",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.practice),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: lessonTypeColor(context, LessonTypes.seminar),
                  child: Text(
                    "Лабораторная",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        lessonTypeColor(context, LessonTypes.seminar),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                height: 25,
                child: Material(
                  color: ColorScheme.of(context).errorContainer,
                  child: Text(
                    "Неизвестно",
                    style: TextStyle(
                      color: textColorForContainer(
                        context,
                        ColorScheme.of(context).errorContainer,
                      ),
                    ),
                  ),
                ),
              ),
              NewLessonWidget(
                lesson: Lesson(
                  week: 12,
                  day: 1,
                  index: 0,
                  subgroup: 2,
                  group: "ПИбд-11",
                  dateTime: DateTime.now(),
                  teacher: "Чел ",
                  room: "3-123",
                  nameOfLesson: "Название занятия",
                  isRemote: false,
                  lessonType: LessonTypes.seminar,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  showLoginDebug(context);
                },
                child: Text("Show debug login"),
              ),
              MaterialButton(
                onPressed: () {
                  showLoginDialogSecure(context);
                },
                child: Text("Show release login"),
              ),
              MaterialButton(
                onPressed: () {
                  showFirstSetupDialog(context);
                },
                child: Text("Show setup dialog"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoginDebug(BuildContext context) {
    var login = "";
    var password = "";
    var ams = "";
    var dataText = "";
    showModalBottomSheet(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "login"),
                  onChanged: (value) {
                    login = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "password"),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                Center(
                  child: FilledButton(
                    onPressed: () async {
                      final cookie = await LoginManager.login(
                        login,
                        password,
                      );
                      setState(() {
                        ams = cookie.loginStates == OnlineStatus.ok
                            ? cookie.ams ?? "ERR NULL[OK]"
                            : "ERR";
                        dataText = cookie.toString();
                      });
                      controller.text = cookie.loginStates == OnlineStatus.ok
                          ? cookie.ams ?? "ERR NULL[OK]"
                          : "ERR";
                    },
                    child: Text("Login"),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        ams = value;
                      },
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      FilledButton(
                        onPressed: () async {
                          UserData data = await UserDataFetch.getUserData(
                            ams,
                          );
                          debugPrint(data.toString());
                          setState(() {
                            dataText = data.toString();
                          });
                        },
                        child: Text("Get profile state"),
                      ),
                      FilledButton(
                        onPressed: () async {
                          final LogoutState state = await LoginManager
                              .logoutIgnoreSessionErrors(ams);
                          setState(() {
                            dataText = state.toString();
                          });
                          debugPrint(state.toString());
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: Text(dataText),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
