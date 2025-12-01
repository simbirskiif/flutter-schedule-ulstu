import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timetable/models/note.dart';
import 'dart:convert';

class SaveSystem {
  late FlutterSecureStorage _secure;
  late SharedPreferences _prefs;
  final lessonsKey = 'LESSON_KEY';
  final notesKey = 'NOTES_KEY';
  final loginKey = 'LOGIN_KEY';
  final passwordKey = 'PASSWORD_KEY';
  final groupKey = 'GROUP_KEY';

  SaveSystem();

  Future<void> init() async {
    _secure = FlutterSecureStorage();
    _prefs = await SharedPreferences.getInstance();
  }

  void clear() {
    _prefs.clear();
    _secure.deleteAll();
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

  void saveGroup(int n) => _prefs.setInt(groupKey, n);
  int? loadSubGroup() => _prefs.getInt(groupKey);

  void saveLessons(String json) => _prefs.setString(lessonsKey, json);
  String? loadLessons() => _prefs.getString(lessonsKey);

  Future<String?> getPassword() => _secure.read(key: passwordKey);
  //_prefs.getString(passwordKey);
  Future<String?> getLogin() async => _secure.read(key: loginKey);
  //_prefs.getString(loginKey);

  void saveLoginPassword(String login, String password) {
    _secure.write(key: loginKey, value: login);
    _secure.write(key: passwordKey, value: password);
    //_prefs.setString(loginKey, login);
    //_prefs.setString(passwordKey, password);
  }
}
