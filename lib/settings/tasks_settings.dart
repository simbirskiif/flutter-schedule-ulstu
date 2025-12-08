import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksSettings extends ChangeNotifier {
  static const String _key = "TASKS_ENABLED_KEY";
  final SharedPreferences _prefs;
  bool _tasksEnabled = true;
  TasksSettings(this._prefs) {
    _tasksEnabled = _prefs.getBool(_key) ?? true;
  }
  // static Future<TasksSettings> init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return TasksSettings._(prefs);
  // }

  set tasksEnabled(bool value) {
    _tasksEnabled = value;
    _prefs.setBool(_key, value);
    notifyListeners();
  }

  get tasksEnabled => _tasksEnabled;
}
