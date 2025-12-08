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
        constraints: BoxConstraints(
          maxWidth: 650,
          minHeight: 40,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Positioned(bottom: 0, child: Icon(Icons.arrow_downward)),
                Text(
                  skipLessonsFormatter(skip),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
