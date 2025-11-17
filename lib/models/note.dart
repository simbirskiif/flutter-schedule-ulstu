// ignore_for_file: unused_import, prefer_typing_uninitialized_variables, unnecessary_import, deprecated_member_use
import 'dart:collection';

import 'package:flutter/foundation.dart';

class LessonID {
  final int week;
  final int day;
  final int index;
  final String name;

  LessonID(this.week, this.day, this.index, this.name);
}

class Note {
  String _title;
  String _content;

  // Вынес в отдельные функции, в будущем возможно там будет какая-то логика сохранения и т.п.
  void setTitle(String t) => _title = t;
  String get title => _title;

  void setContent(String c) => _content = c;
  String get content => _content;

  Note(this._title, this._content);
}

class LessonNotes with ChangeNotifier {
  final Map<LessonID, Note> _notes = {};

  Iterable<LessonID> get keys {
    return _notes.keys;
  }

  int get length => _notes.length;

  void add(LessonID id, Note n) {
    _notes[id] = n;
    notifyListeners();
  }

  Note? getNote(LessonID id) {
    return _notes[id];
  }

  void setNote(LessonID id, Note n) {
    _notes[id] = n;
    notifyListeners();
  }

  void delNote(LessonID id) {
    _notes.remove(id);
    notifyListeners();
  }
}
