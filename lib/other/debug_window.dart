import 'package:flutter/material.dart';
import 'package:navigation_bar_m3e/navigation_bar_m3e.dart';
import 'package:timetable/api/login_manager.dart';
import 'package:timetable/dialog/login_dialog.dart';
import 'package:timetable/enum/login_states.dart';
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                      final cookie = await LoginManager().login(
                        login,
                        password,
                      );
                      setState(() {
                        ams = cookie.loginStates == LoginStates.ok
                            ? cookie.ams ?? "ERR NULL[OK]"
                            : "ERR";
                      });
                    },
                    child: Text("Login"),
                  ),
                ),
                Center(child: Text(ams)),
              ],
            );
          },
        );
      },
    );
  }
}
