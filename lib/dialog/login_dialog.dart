import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/save_system/save_system.dart';

void showLoginDialogSecure(BuildContext context) {
  String login = "";
  String password = "";
  String? errorText;
  final passwordController = TextEditingController();
  bool isLock = false;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              spacing: 4,
              children: [
                Icon(Icons.login),
                Text(
                  "Войти",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).onSurface,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    spacing: 10,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Text(
                            "Подключение к сервису lk.ulstu.ru",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorScheme.of(context).onSurface,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          color: ColorScheme.of(context).onSurface,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Логин",
                          hintText: "Введите логин",
                          hoverColor: ColorScheme.of(context).onSurface,
                        ),
                        onChanged: (value) {
                          setState(() {
                            errorText = null;
                          });
                          login = value;
                        },
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: ColorScheme.of(context).onSurface,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Пароль",
                          hintText: "Введите пароль",
                          errorText: errorText,
                          counterStyle: TextStyle(
                            color: ColorScheme.of(context).onSurface,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            errorText = null;
                          });
                          password = value;
                        },
                      ),
                    ],
                  ),
                  isLock
                      ? Positioned.fill(
                          child: Stack(
                            children: [
                              Center(child: LoadingIndicatorM3E()),
                              Container(
                                color: ColorScheme.of(
                                  context,
                                ).onBackground.withOpacity(0.1),
                              ),
                            ],
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Отмена"),
              ),
              isLock
                  ? Text('')
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          errorText = null;
                          isLock = true;
                        });
                        final SessionManager manager =
                            Provider.of<SessionManager>(context, listen: false);
                        final SaveSystem saveSystem = Provider.of<SaveSystem>(
                          context,
                          listen: false,
                        );
                        OnlineStatus status = await manager.login(
                          login,
                          password,
                        );
                        setState(() {
                          switch (status) {
                            case OnlineStatus.ok:
                              errorText = null;
                              break;
                            case OnlineStatus.connectionErr:
                              errorText = "Нет интернета";
                              break;
                            case OnlineStatus.wrongPassword:
                              errorText = "Неверный пароль";
                              break;
                            default:
                              errorText = "Произошла ошибка";
                          }
                        });
                        isLock = false;
                        passwordController.clear();
                        if (status == OnlineStatus.ok) {
                          await saveSystem.saveLoginPassword(
                            login,
                            password,
                          ); // <- обязательно await
                          if (context.mounted) {
                            Navigator.pop(context);
                            showFirstSetupDialog(context);
                          }
                        }
                        // LoginState state = await LoginManager.login(
                        //   login,
                        //   password,
                        // );
                        // setState(() {
                        //   errorText = state.loginStates != OnlineStatus.ok
                        //       ? state.loginStates == OnlineStatus.wrongPassword
                        //             ? "Неверный пароль"
                        //             : state.loginStates ==
                        //                   OnlineStatus.connectionErr
                        //             ? "Нет интернета"
                        //             : "Произошла ошибка"
                        //       : null;
                        //   isLock = false;
                        // });
                        // passwordController.clear();
                      },
                      child: Text("Войти"),
                    ),
            ],
          );
        },
      );
    },
  );
}
