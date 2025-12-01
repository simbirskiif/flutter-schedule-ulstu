import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/manual_group_select.dart';
import 'package:timetable/widgets/segmented_buttons.dart';

void showFirstSetupDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      // SessionManager manager = Provider.of<SessionManager>(context);
      // bool isLoading = manager.fetchingData;
      // bool isError = !manager.isLoggin;
      // manager.fetchUserData();
      return FirstSetupDialog();
    },
  );
}

class FirstSetupDialog extends StatefulWidget {
  const FirstSetupDialog({super.key});

  @override
  State<FirstSetupDialog> createState() => _FirstSetupDialogState();
}

class _FirstSetupDialogState extends State<FirstSetupDialog> {
  bool isFirstLoad = true;
  bool isLoading = true;
  bool isError = false;
  String? group;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    SessionManager manager = Provider.of<SessionManager>(
      context,
      listen: false,
    );
    await Future.delayed(Duration(microseconds: 5));
    isLoading = manager.fetchingData;
    isError = !manager.loggedIn;
    if (isFirstLoad) {
      await manager.fetchUserData();
      isFirstLoad = false;
      group = manager.group;
    }
  }

  @override
  Widget build(BuildContext context) {
    SessionManager manager = Provider.of<SessionManager>(context);
    return AlertDialog(
      title: Text(
        manager.name != null
            ? "${manager.name!.split(" ")[1]} ${manager.name!.split(" ")[0][0]}."
            : 'Почти готово',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorScheme.of(context).onSurface,
        ),
      ),
      content: AnimatedSize(
        duration: Duration(milliseconds: 200),
        child: SingleChildScrollView(
          child: manager.fetchingData
              ? Center(
                  child: Container(
                    color: ColorScheme.of(context).surfaceContainerHigh,
                    child: Center(child: LoadingIndicatorM3E()),
                  ),
                )
              : !manager.loggedIn
              ? Center(
                  child: Container(
                    color: ColorScheme.of(context).surfaceContainerHigh,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: Icon(Icons.error)),
                          Text(
                            "Произошла ошибка",
                            style: TextStyle(
                              color: ColorScheme.of(context).onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: ColorScheme.of(context).surfaceVariant,
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Column(
                                spacing: 8,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              group ?? "Группа не определена",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorScheme.of(
                                                  context,
                                                ).onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ButtonM3E(
                                          onPressed: () async {
                                            String? thisGroup =
                                                await showManualGroupSelectDialog(
                                                  context,
                                                  currentSelect: group,
                                                );
                                            setState(() {
                                              if (thisGroup != null) {
                                                group = thisGroup;
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.edit),
                                          label: Text("Изменить"),
                                          style: ButtonM3EStyle.outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Выбрать подгруппу:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: ColorScheme.of(
                                            context,
                                          ).onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    return SegmentedButtons(
                                      items: ["1", "2", "3"],
                                      onSelected: (value) {
                                        debugPrint(value.toString());
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text("Закрыть")),
        !manager.fetchingData && manager.loggedIn
            ? TextButton(onPressed: () {}, child: Text("Готово"))
            : Text(""),
        !manager.loggedIn
            ? TextButton(
                onPressed: () {
                  isFirstLoad = true;
                },
                child: Text("Повторить"),
              )
            : Text(""),
      ],
    );
  }
}
