import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/models/note.dart';
import 'dart:convert';

class SaveSystem {
  late SharedPreferences _prefs;
  final lessonsKey = 'LESSON_KEY';
  final notesKey = 'NOTES_KEY';

  SaveSystem();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveNotes(LessonNotes notes) {
    String json = jsonEncode(notes);
    _prefs.setString(notesKey, json);
  }

  LessonNotes loadNotes() {
    String? json = _prefs.getString(notesKey);
    if (json == null) return LessonNotes.empty();
    var lst = jsonDecode(json);
    return LessonNotes.fromJson(lst);
  }

  void saveLessons(String json) => _prefs.setString(lessonsKey, json);
  String? loadLessons() => _prefs.getString(lessonsKey);
}
