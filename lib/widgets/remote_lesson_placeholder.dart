import 'package:flutter/material.dart';

class RemoteLessonPlaceholder extends StatelessWidget {
  const RemoteLessonPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: ColorScheme.of(context).surfaceVariant),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        child: Text(
          "УДАЛЕННО",
          style: TextStyle(color: ColorScheme.of(context).onSurfaceVariant, fontSize: 12),
        ),
      ),
    );
  }
}
