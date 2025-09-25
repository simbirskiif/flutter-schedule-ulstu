// ignore_for_file: file_names, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:timetable/lesson_type_widget.dart';

class LessonWidget extends StatelessWidget {
  final double maxWidth = 650;
  final String mainText;
  final Color testColor;
  final String testTime;
  final String testAud;
  final double testProgress;
  final String testPrepod;
  final String testType;
  const LessonWidget({
    super.key,
    required this.mainText,
    required this.testColor,
    required this.testTime,
    required this.testAud,
    required this.testProgress,
    required this.testPrepod,
    required this.testType,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = ColorScheme.of(context).onPrimaryContainer;
    Color foregroundColor = ColorScheme.of(context).secondaryContainer;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(right: 0),
                        child: Column(
                          children: [
                            Align(
                              alignment: AlignmentGeometry.centerLeft,
                              child: SizedBox(
                                height: 48,
                                // width: double.infinity,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.top,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 2,
                                          ),
                                          child: LessonTypeWidget(
                                            type: LessonTypes.lecture,
                                            testColor: testColor,
                                            testType: testType,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: mainText,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              spacing: 2,
                              children: [
                                Icon(Icons.person, size: 20, color: textColor),
                                SizedBox(
                                  child: Align(
                                    alignment: AlignmentGeometry.centerLeft,
                                    child: SizedBox(
                                      height: 24,
                                      child: Align(
                                        alignment: AlignmentGeometry.centerLeft,
                                        child: Text(
                                          testPrepod,
                                          style: TextStyle(color: textColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.door_back_door_outlined,
                                  size: 20,
                                  color: textColor,
                                ),
                                SizedBox(
                                  child: Align(
                                    alignment: AlignmentGeometry.centerLeft,
                                    child: SizedBox(
                                      height: 24,
                                      child: Align(
                                        alignment: AlignmentGeometry.centerLeft,
                                        child: Text(
                                          testAud,
                                          style: TextStyle(color: textColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: textColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  height: 24,
                                  child: Align(
                                    alignment: AlignmentGeometry.centerRight,
                                    child: Text(
                                      testTime,
                                      style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: LinearProgressIndicator(
                                year2023: false,
                                value: testProgress != -1 ? testProgress : 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: AlignmentGeometry.bottomRight,
                    //   child: Row(
                    //     spacing: 2,
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Icon(Icons.access_time, color: textColor, size: 20),
                    //       SizedBox(
                    //         height: 24,
                    //         child: Align(
                    //           alignment: AlignmentGeometry.centerRight,
                    //           child: Text(
                    //             "datadatadata",
                    //             style: TextStyle(color: textColor),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
