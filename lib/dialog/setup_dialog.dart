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
        title: Text(
          "Управление",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorScheme.of(context).onSurface,
          ),
        ),
        content: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showFirstSetupDialog(context);
              },
              icon: Icon(Icons.edit),
              label: Text("Изменить группу и подгруппу"),
            ),
            OutlinedButton.icon(
              onPressed: () {
                final manager = Provider.of<SessionManager>(
                  context,
                  listen: false,
                );
                final processor = Provider.of<GroupProcessor>(
                  context,
                  listen: false,
                );
                final save = Provider.of<SaveSystem>(context, listen: false);
                manager.logoutAndDropData(processor, save);
                Navigator.pop(context);
              },
              icon: Icon(Icons.logout),
              label: Text("Выйти и удалить данные"),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: ButtonM3E(
            //         onPressed: () {
            //           Navigator.pop(context);
            //           showFirstSetupDialog(context);
            //         },
            //         label: Row(
            //           children: [
            //             Text(
            //               "Изменить группу и подгруппу",
            //               softWrap: true,
            //               maxLines: 2,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ],
            //         ),
            //         icon: Icon(Icons.edit),
            //         style: ButtonM3EStyle.filled,
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: MaterialButton(
            //         onPressed: () {
            //           final manager = Provider.of<SessionManager>(
            //             context,
            //             listen: false,
            //           );
            //           final processor = Provider.of<GroupProcessor>(
            //             context,
            //             listen: false,
            //           );
            //           final save = Provider.of<SaveSystem>(
            //             context,
            //             listen: false,
            //           );
            //           manager.logoutAndDropData(processor, save);
            //           Navigator.pop(context);
            //         },
            //         child: Row(
            //           // mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text("Выйти и удалить данные"),
            //             Icon(Icons.logout),
            //           ],
            //         ),
            //         // label: Expanded(child: Text("Выйти и удалить данные")),
            //         // icon: Icon(Icons.logout),
            //         // style: ButtonM3EStyle.outlined,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Закрыть"),
          ),
        ],
      );
    },
  );
}
