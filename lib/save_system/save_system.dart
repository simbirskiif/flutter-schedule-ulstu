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
  final groupKey = 'GROUP_KEY'; // used for subgroup int
  final groupNameKey = 'GROUP_NAME_KEY'; // store group name string

  SaveSystem();

  Future<void> init() async {
    _secure = const FlutterSecureStorage();
    _prefs = await SharedPreferences.getInstance();
  }

  // make clear async and await secure deletion
  Future<void> clear() async {
    await _prefs.clear();
    await _secure.deleteAll();
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

  void saveGroupName(String? name) {
    if (name == null) {
      _prefs.remove(groupNameKey);
    } else {
      _prefs.setString(groupNameKey, name);
    }
  }

  String? loadGroupName() => _prefs.getString(groupNameKey);

  void saveLessons(String json) => _prefs.setString(lessonsKey, json);
  String? loadLessons() => _prefs.getString(lessonsKey);

  // explicit async wrappers for secure storage
  Future<String?> getPassword() => _secure.read(key: passwordKey);
  Future<String?> getLogin() => _secure.read(key: loginKey);

  Future<void> saveLoginPassword(String login, String password) async {
    await _secure.write(key: loginKey, value: login);
    await _secure.write(key: passwordKey, value: password);
  }
}
