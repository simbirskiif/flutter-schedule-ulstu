// ignore_for_file: file_names
import 'package:flutter/material.dart';

class LessonWidget extends StatelessWidget {
  final double maxWidth = 650;
  final String mainText;

  const LessonWidget({super.key, required this.mainText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(right: 100),
                        child: Text(mainText),
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.topRight,
                      child: Row(
                        spacing: 2,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Icon(Icons.access_time), Text("data")],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
