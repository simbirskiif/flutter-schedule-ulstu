import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/widgets/home_login_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    GroupProcessor processor = Provider.of<GroupProcessor>(context);
    return processor.days.isNotEmpty
        // ignore: dead_code
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 650, minWidth: 40),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Приветствие",
                            style: TextStyle(
                              color: ColorScheme.of(context).onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            "Что сейчас",
                            style: TextStyle(
                              color: ColorScheme.of(context).onSurface,
                              fontWeight: FontWeight.normal,
                              fontSize: 24,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),  Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
                                          ),
                                        ),
                                        Text(
                                          "data",
                                          style: TextStyle(
                                            color: ColorScheme.of(context).onSurface,
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
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 5,
                      child: Center(child: Text("Bottom test text")),
                    ),
                  ],
                ),
              ),
            ),
          )
        : HomeLoginWidget();
  }
}
