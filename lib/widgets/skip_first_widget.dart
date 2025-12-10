import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/settings/tasks_settings.dart';

class SkipFirstWidget extends StatelessWidget {
  final int skip;
  const SkipFirstWidget({super.key, required this.skip});

  @override
  Widget build(BuildContext context) {
    TasksSettings settings = Provider.of<TasksSettings>(context);

    if (skip <= 0 || !settings.firstSkipEnabled) return SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650, minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward), // слева стрелка
              SizedBox(width: 8), // небольшой отступ
              Expanded(
                child: Text(
                  "Приходить к ${skip + 1}-й паре",
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
