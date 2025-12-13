import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:timetable/dialog/login_dialog.dart';
import 'package:timetable/widgets/animate_icon.dart';

class HomeLoginWidget extends StatelessWidget {
  const HomeLoginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 650,
              minWidth: 40,
              maxHeight: double.infinity,
            ),
            child: Stack(
              children: [
                Positioned(right: 0, top: 0, child: AnimateIcon()),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSize(
                            duration: Duration(milliseconds: 200),
                            child: Text(
                              "Добро пожаловать!",
                              style: TextStyle(
                                color: ColorScheme.of(context).onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 48,
                              ),
                            ),
                          ),
                          Text(
                            "Для начала надо зайти в аккаунт",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorScheme.of(context).onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ButtonM3E(
                        onPressed: () {
                          showLoginDialogSecure(context);
                        },
                        label: Center(
                          child: Row(
                            children: [
                              Text(
                                "Войти в аккаунт",
                                style: TextStyle(fontSize: 14),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward, size: 18,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
