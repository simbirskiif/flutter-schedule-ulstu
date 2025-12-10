import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/settings/tasks_settings.dart';
import 'package:timetable/utils/string_time_formatter.dart';

class SkipWidget extends StatelessWidget {
  final int skip;
  const SkipWidget({super.key, required this.skip});

  @override
  Widget build(BuildContext context) {
    TasksSettings settings = Provider.of<TasksSettings>(context);

    if (skip <= 0 || !settings.skipEnabled) return SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650, minHeight: 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward), // стрелка слева
              SizedBox(width: 8), // отступ между стрелкой и текстом
              Expanded(
                child: Text(
                  skipLessonsFormatter(skip),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
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
