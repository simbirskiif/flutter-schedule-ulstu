// ignore_for_file: use_build_context_synchronously

import 'package:button_m3e/button_m3e.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/api/session_manager.dart';
import 'package:timetable/dialog/manual_group_select.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';
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
  bool isErrorLoadGroups = false;
  bool isLoadingGroups = true;
  int subgroupsCount = 0;
  String? group;
  int subgroup = -1;
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
      await loadSubgroups();
    }
  }

  Future<void> saveAndLoad() async {
    GroupProcessor processor = Provider.of<GroupProcessor>(
      context,
      listen: false,
    );
    SessionManager manager = Provider.of<SessionManager>(
      context,
      listen: false,
    );
    final save = Provider.of<SaveSystem>(context, listen: false);

    // сохраняем выбор группы и подгруппы
    manager.group = group;
    save.saveGroupName(group);
    // сохраняем подгруппу в SaveSystem (и GroupProcessor тоже сохранит)
    if (subgroup != -1) {
      save.saveSubGroup(subgroup);
    }

    await processor.updateFromGroup();
    processor.setSubgroup(subgroup);
  }

  Future<void> loadSubgroups() async {
    if (mounted) {
      setState(() {
        isErrorLoadGroups = false;
        isLoadingGroups = true;
      });
    }
    GroupProcessor processor = Provider.of<GroupProcessor>(
      context,
      listen: false,
    );
    if (group != null) {
      final temp = await processor.getLessonsByGroup(group!);
      if (temp.item2 != null) {
        try {
          subgroupsCount = GroupProcessor.getSubgroupCount(temp.item2!);
          debugPrint(subgroupsCount.toString());
          if (mounted) {
            setState(() {
              subgroupsCount = subgroupsCount;
              isErrorLoadGroups = false;
              isLoadingGroups = false;
            });
          }
          return;
        } catch (_) {
          if (mounted) {
            setState(() {
              isErrorLoadGroups = true;
              isLoadingGroups = false;
            });
          }
        }
      }
    }
    isErrorLoadGroups = true;
    isLoadingGroups = false;
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
                                            if (thisGroup != null) {
                                              setState(() {
                                                group = thisGroup;
                                              });
                                              group = thisGroup;
                                              await loadSubgroups();
                                            }
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
                            child: isLoadingGroups
                                ? Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Column(
                                      children: [
                                        LoadingIndicatorM3E(),
                                        Text(
                                          "Подождите..",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ColorScheme.of(
                                              context,
                                            ).onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : isErrorLoadGroups
                                ? Container(
                                    color: ColorScheme.of(
                                      context,
                                    ).surfaceContainerHigh,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(child: Icon(Icons.error)),
                                          Text(
                                            "Произошла ошибка",
                                            style: TextStyle(
                                              color: ColorScheme.of(
                                                context,
                                              ).onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : subgroupsCount > 0
                                ? Builder(
                                    builder: (context) {
                                      subgroup = 1;
                                      return Column(
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
                                          SegmentedButtons(
                                            initialIndex: subgroup - 1,
                                            items: [
                                              for (
                                                var n = 1;
                                                n <= subgroupsCount;
                                                n++
                                              )
                                                n.toString(),
                                            ],
                                            onSelected: (value) {
                                              debugPrint(value.toString());
                                              subgroup = value + 1;
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 4,
                                      children: [
                                        Icon(Icons.info),
                                        Text(
                                          "У этой группы нет подгрупп",
                                          style: TextStyle(
                                            color: ColorScheme.of(
                                              context,
                                            ).onSurface,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
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
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Закрыть"),
        ),
        !manager.fetchingData && manager.loggedIn
            ? TextButton(
                onPressed: () {
                  if (subgroup != -1 && mounted) {
                    saveAndLoad();
                    Navigator.pop(context);
                  }
                },
                child: Text("Сохранить"),
              )
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
