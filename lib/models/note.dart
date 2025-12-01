// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:timetable/models/lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';
import 'package:provider/src/provider.dart';

class Note {
  String title;
  String content;
  Note(this.title, this.content);

  Map<String, dynamic> toJson() => {'title': title, 'content': content};

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['title'], json['content']);
  }
}

class LessonNotes with ChangeNotifier {
  final Map<LessonID, Note> _notes;

  LessonNotes.empty() : _notes = {};
  LessonNotes(this._notes);

  int get length => _notes.length;

  Iterable<LessonID> get keys {
    return _notes.keys;
  }

  void add(LessonID id, BuildContext context) {
    _notes[id] = Note(id.name, "");
    notifyListeners();
    _save(context);
  }

  bool contains(LessonID id) {
    return _notes.containsKey(id);
  }

  Note? getNote(LessonID id) {
    return _notes[id];
  }

  void setTitle(LessonID id, String s, BuildContext context) {
    getNote(id)?.title = s;
    notifyListeners();
    _save(context);
  }

  void setContent(LessonID id, String s, BuildContext context) {
    getNote(id)?.content = s;
    notifyListeners();
    _save(context);
  }

  void delNote(LessonID id, BuildContext context) {
    _notes.remove(id);
    notifyListeners();
    _save(context);
  }

  void clear(BuildContext context) {
    final processor = context.read<GroupProcessor>();
    Set<LessonID> listLessonID = {};
    listLessonID.addAll(processor.lessons.map((e) => e.id));
    List<LessonID> currentID = [];
    currentID.addAll(_notes.keys);

    for (var id in currentID) {
      if (!listLessonID.contains(id)) _notes.remove(id);
    }

    notifyListeners();
    _save(context);
  }

  List<Map<String, dynamic>> toJson() {
    return _notes.entries
        .map(
          (entry) => {
            'lessonID': entry.key.toJson(),
            'note': entry.value.toJson(),
          },
        )
        .toList();
  }

  factory LessonNotes.fromJson(List<dynamic> json) {
    Map<LessonID, Note> notes = {};

    for (var entry in json) {
      var lessonid = LessonID.fromJson(entry['lessonID']);
      var note = Note.fromJson(entry['note']);

      notes[lessonid] = note;
    }

    return LessonNotes(notes);
  }

  void _save(BuildContext context) {
    final save = context.read<SaveSystem>();
    save.saveNotes(this);
  }
}
