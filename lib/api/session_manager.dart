import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timetable/api/login_manager.dart';
import 'package:timetable/api/user_data_fetch.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/models/login_state.dart';
import 'package:timetable/processors/group_processor.dart';
import 'package:timetable/save_system/save_system.dart';

class SessionManager with ChangeNotifier {
  String? userName; //! login
  String? password;
  String? ams;
  String? group;
  String? name;
  bool loggedIn = false;
  bool offline = false;
  bool fetchingData = false;
  bool isLoggining = false;
  SessionManager();

  Future<void> logout() async {
    if (ams == null) {
      userName = null;
      password = null;
      return;
    }
    await LoginManager.logoutIgnoreSessionErrors(ams!);
    ams = null;
    loggedIn = false;
    notifyListeners();
  }

  Future<void> logoutAndDropData(
    GroupProcessor processor,
    SaveSystem save,
  ) async {
    await logout();
    userName = null;
    password = null;
    name = null;
    group = null;
    loggedIn = false;
    processor.clear();
    save.clear();
    notifyListeners();
  }

  Future<OnlineStatus> updateAms() async {
    if (userName == null && password == null) {
      return OnlineStatus.undefined;
    }
    await logout();
    var status = await login(userName!, password!);
    int iter = 5;
    while (iter >= 0 && status == OnlineStatus.connectionErr) {
      status = await login(userName!, password!);
      iter--;
    }
    return status;
  }

  Future<OnlineStatus> login(String login, String password) async {
    isLoggining = true;
    notifyListeners();
    int iters = 5;
    if (ams != null) {
      isLoggining = false;
      notifyListeners();
      return OnlineStatus.undefined;
    }
    LoginState state = await LoginManager.login(login, password);
    while (iters >= 0 && state.loginStates == OnlineStatus.connectionErr) {
      debugPrint("No connection, retry left: $iters");
      state = await LoginManager.login(login, password);
      iters--;
    }
    if (state.loginStates == OnlineStatus.ok) {
      loggedIn = true;
      userName = login;
      this.password = password;
      ams = state.ams;
    }
    isLoggining = false;
    notifyListeners();
    return state.loginStates;
  }

  Future<OnlineStatus> fetchUserData() async {
    fetchingData = true;
    // notifyListeners();
    var iters = 5;
    var status = await _fetchUserData();
    if (status == OnlineStatus.ok) {
      notifyListeners();
      fetchingData = false;
      return status;
    } else if (status == OnlineStatus.sessionErr &&
        userName != null &&
        password != null) {
      await logout();
      while (iters >= 0) {
        status = await login(userName!, password!);
        if (status == OnlineStatus.ok) {
          break;
        }
        if (status != OnlineStatus.connectionErr) {
          break;
        }
        iters--;
      }
    }
    if (status != OnlineStatus.ok) {
      fetchingData = false;
      notifyListeners();
      return status;
    } else {
      OnlineStatus s = await _fetchUserData();
      fetchingData = false;
      notifyListeners();
      return s;
    }
  }

  Future<OnlineStatus> _fetchUserData() async {
    if (ams == null) {
      return OnlineStatus.sessionErr;
    }
    UserData data = await UserDataFetch.getUserData(ams!);
    if (data.status == OnlineStatus.ok) {
      name = data.fullName;
      group = data.group;
    }
    return data.status;
  }
}
