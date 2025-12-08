import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  bool loadTasksEnabled() => _prefs.getBool('TASKS_ENABLED_KEY') ?? true;
  void saveTasksEnabled(bool enabled) =>
      _prefs.setBool('TASKS_ENABLED_KEY', enabled);

  void saveSubGroup(int n) => _prefs.setInt(groupKey, n);
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
  get prefs => _prefs;
}
