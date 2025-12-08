import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timetable/models/note.dart';
import 'dart:convert';
import 'package:timetable/models/lesson.dart';

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

  void saveGroup(int n) => _prefs.setInt(groupKey, n);
  int? loadSubGroup() => _prefs.getInt(groupKey);

  void saveGroupName(String? name) {
    if (name == null) {
      _prefs.remove(groupNameKey);
    } else {
      _prefs.setString(groupNameKey, name);
    }
  }

  void saveNotes(List<Lesson> lessons) {
    Map<String, dynamic> map = {};
    for (var lesson in lessons) {
      if (lesson.note != null) {
        map[lesson.toString()] = {
          'title': lesson.note!.title,
          'content': lesson.note!.content,
        };
      }
    }

    String json = jsonEncode(map);
    _prefs.setString(notesKey, json);
  }

  Map<String, Note> loadNotes() {
    Map<String, Note> map = {};
    String? raw = _prefs.getString(notesKey);
    if (raw == null) return map;

    Map<String, dynamic> decoded = jsonDecode(raw);
    for (var entry in decoded.entries) {
      map[entry.key] = Note(
        title: entry.value['title'],
        content: entry.value['content'],
      );
    }
    return map;
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
