import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/settings/tasks_settings.dart';

class SkipFirstWidget extends StatelessWidget {
  final int skip;
  const SkipFirstWidget({super.key, required this.skip});

  @override
  Widget build(BuildContext context) {
    TasksSettings settings = Provider.of<TasksSettings>(context);
    return skip > 0 && settings.firstSkipEnabled
        ? Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 650, minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Positioned(bottom: 0, child: Icon(Icons.arrow_downward)),
                      Center(
                        child: Text(
                          "Приходить к ${skip + 1}-й паре",
                          style: TextStyle(
                            color: ColorScheme.of(context).onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        )
        : SizedBox.shrink();
  }
}
