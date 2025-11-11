import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';

class OpenContainerTest extends StatelessWidget {
  const OpenContainerTest({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 500),
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      closedColor: ColorScheme.of(context).surfaceVariant,
      closedBuilder: (context, action) {
        return GestureDetector(
          onTap: () {
            action();
          },
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: NewLessonWidget(lesson: null,),
          ),
        );
      },
      openBuilder: (context, action) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Hero(
              tag: "tag",
              child: Material(
                color: ColorScheme.of(context).surfaceVariant,
                child: SizedBox.expand(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "data",
                          style: TextStyle(color: Colors.black, fontSize: 48),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            action();
                          },
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}