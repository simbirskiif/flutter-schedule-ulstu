import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/fitst_setup_dialog.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';

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
            Row(
              children: [
                Expanded(
                  child: ButtonM3E(
                    onPressed: () {
                      Navigator.pop(context);
                      showFirstSetupDialog(context);
                    },
                    label: Row(
                      children: [
                        Text(
                          "Перейти к выбору группы и подгруппы",
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    icon: Icon(Icons.edit),
                    style: ButtonM3EStyle.filled,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonM3E(
                    onPressed: () {
                      final manager = Provider.of<SessionManager>(
                        context,
                        listen: false,
                      );
                      final processor = Provider.of<GroupProcessor>(
                        context,
                        listen: false,
                      );
                      final save = Provider.of<SaveSystem>(
                        context,
                        listen: false,
                      );
                      manager.logoutAndDropData(processor, save);
                      Navigator.pop(context);
                    },
                    label: Text("Выйти и удалить данные"),
                    icon: Icon(Icons.logout),
                    style: ButtonM3EStyle.outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
