// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use
import 'dart:collection';
import 'package:flutter/material.dart';

import 'lesson.dart';
import 'package:flutter/foundation.dart';

class Note {
  String title;
  String content;
  Note(this.title, this.content);
}

class LessonNotes with ChangeNotifier {
  final Map<LessonID, Note> _notes = {};
  Iterable<LessonID> get keys {
    return _notes.keys;
  }

  int get length => _notes.length;

  void add(LessonID id) {
    _notes[id] = Note('${id.name}/${id.week}/${id.day}/${id.index}', '');
    notifyListeners();
  }

  bool contains(LessonID id) {
    return _notes.containsKey(id);
  }

  Note? getNote(LessonID id) {
    return _notes[id];
  }

  void setTitle(LessonID id, String s) {
    getNote(id)?.title = s;
    notifyListeners();
  }

  void setContent(LessonID id, String s) {
    getNote(id)?.content = s;
    notifyListeners();
  }

  void delNote(LessonID id) {
    _notes.remove(id);
    notifyListeners();
  }

  void clear() => _notes.clear();
}
