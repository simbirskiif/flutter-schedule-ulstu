import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksSettings extends ChangeNotifier {
  static const String _key = "TASKS_ENABLED_KEY";
  static const String _key2 = "FIRST_SKIP_ENABLED_KEY";
  static const String _key3 = "SKIP_ENABLED_KEY";
  final SharedPreferences _prefs;
  bool _tasksEnabled = true;
  bool _firstSkipEnabled = true;
  bool _skipEnabled = true;
  TasksSettings(this._prefs) {
    _tasksEnabled = _prefs.getBool(_key) ?? true;
    _firstSkipEnabled = _prefs.getBool(_key2) ?? true;
    _skipEnabled = _prefs.getBool(_key3) ?? true;
  }
  // static Future<TasksSettings> init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return TasksSettings._(prefs);
  // }
  set firstSkipEnabled(bool value) {
    _firstSkipEnabled = value;
    _prefs.setBool(_key2, value);
    notifyListeners();
  }

  get firstSkipEnabled => _firstSkipEnabled;

  set skipEnabled(bool value) {
    _skipEnabled = value;
    _prefs.setBool(_key3, value);
    notifyListeners();
  }

  get skipEnabled => _skipEnabled;

  set tasksEnabled(bool value) {
    _tasksEnabled = value;
    _prefs.setBool(_key, value);
    notifyListeners();
  }

  get tasksEnabled => _tasksEnabled;
}
