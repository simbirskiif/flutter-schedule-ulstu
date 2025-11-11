// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'package:animations/animations.dart';
import 'package:expressive_refresh/expressive_refresh.dart';
import 'package:flutter/material.dart';
import 'package:timetable/main.dart';
import 'package:timetable/models/note.dart';
import 'package:timetable/screens/schedule_screen.dart';
import 'package:timetable/widgets/new_lesson_widget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<ExpressiveRefreshIndicatorState> _key = GlobalKey();
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: Random().nextInt(10)));
  }

  List<Note> notes = [Note("12", "12")];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
      ],
    );
  }
}

