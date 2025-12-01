import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';

void showSetupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Управление"),
        content: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonM3E(
              onPressed: () {
                Navigator.pop(context);
                showFirstSetupDialog(context);
              },
              label: Text(
                "Перейти к выбору группы и подгруппы",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              icon: Icon(Icons.edit),
              style: ButtonM3EStyle.filled,
            ),
            ButtonM3E(
              onPressed: () {
                final manager = Provider.of<SessionManager>(
                  context,
                  listen: false,
                );
                manager.logoutAndDropData();
                Navigator.pop(context);
              },
              label: Text("Выйти и удалить данные"),
              icon: Icon(Icons.logout),
              style: ButtonM3EStyle.outlined,
            ),
          ],
        ),
      );
    },
  );
}
