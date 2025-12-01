import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/widgets/selectable_card.dart';
import 'package:tuple/tuple.dart';

Future<String?> showManualGroupSelectDialog(
  BuildContext context, {
  String? currentSelect,
}) async {
  String? selected;
  bool isLoading = true;
  bool isError = false;
  bool isFirst = true;
  bool isFirstListOpen = true;
  int selectedIndex = -1;
  Tuple2 obj;
  List<String>? groups;
  GroupProcessor processor = Provider.of<GroupProcessor>(
    context,
    listen: false,
  );
  final result = await showDialog(
    context: context,
    builder: (context) {
      ScrollController controller = ScrollController();
      return StatefulBuilder(
        builder: (context, setState) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!isFirst) return;
            obj = await processor.getAllGroups();
            isFirst = false;
            if (obj.item1 == OnlineStatus.ok) {
              if (context.mounted) {
                groups = obj.item2;
                setState(() {
                  isError = false;
                  isLoading = false;
                });
              }
            } else {
              if (context.mounted) {
                setState(() {
                  isError = true;
                  isLoading = false;
                });
              }
            }
          });
          return AlertDialog(
            title: Text(
              "Выбрать группу",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorScheme.of(context).onSurface,
              ),
            ),
            content: AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Container(
                child: isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [Center(child: LoadingIndicatorM3E())],
                      )
                    : isError
                    ? Center(
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
                      )
                    : SizedBox(
                        width: 250,
                        height: 400,
                        child: Builder(
                          builder: (context) {
                            if (isFirstListOpen) {
                              isFirstListOpen = false;
                              if (groups != null) {
                                int selIndex = groups!.indexWhere(
                                  (str) => str == currentSelect,
                                );
                                if (selIndex != -1) {
                                  selectedIndex = selIndex;
                                  selected = groups![selIndex];
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (context.mounted && selIndex != -1) {
                                      controller.jumpTo(selIndex * 53.4);
                                    }
                                  });
                                }
                              }
                            }
                            return ListView.builder(
                              controller: controller,
                              itemCount: groups != null ? groups!.length : 0,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      selected = groups![i];
                                      setState(() {
                                        selectedIndex = i;
                                      });
                                    },
                                    child: SelectableCard(
                                      title: groups![i],
                                      isSelected: selectedIndex == i,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  selected = null;
                  Navigator.pop(context);
                },
                child: Text("Закрыть"),
              ),
              !isError && !isLoading
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("Оk"),
                    )
                  : Text(""),
            ],
          );
        },
      );
    },
  );
  if (result == null) {
    return null;
  }
  return selected;
}
