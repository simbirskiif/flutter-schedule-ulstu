import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:timetable/api/fetch_final_response.dart';
import 'package:timetable/enum/online_status.dart';
import 'package:timetable/models/login_state.dart';

enum LogoutState { ok, sessionErr, connectionErr }

class LoginManager {
  static final http.Client _client = http.Client();
  static final String loginUrl = "https://lk.ulstu.ru/?q=auth/login";
  static final String logoutUrl = "https://lk.ulstu.ru/?q=auth/logout";

  static Future<LoginState> login(String login, String password) async {
    final uri = Uri.parse(loginUrl);

    try {
      final response = await _client
          .post(
            uri,
            body: {"login": login, "password": password},
            headers: {
              "Connection": "keep-alive",
              "User-Agent":
                  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                  "AppleWebKit/537.36 (KHTML, like Gecko) "
                  "Chrome/121.0.0.0 Safari/537.36",
              "Accept": "text/html",
              "Accept-Language": "ru-RU,ru;q=0.9",
              "Referer": "https://lk.ulstu.ru/",
            },
          )
          .timeout(Duration(seconds: 7));
      if (response.statusCode != 302) {
        return LoginState(ams: null, loginStates: OnlineStatus.undefined);
      }
      final location = response.headers["location"];
      if (location == null) {
        return LoginState(ams: null, loginStates: OnlineStatus.undefined);
      }
      debugPrint(location);
      if (location.startsWith("/?q=auth%2Flogin")) {
        return LoginState(ams: null, loginStates: OnlineStatus.wrongPassword);
      }
      if (location != "/?q=account" && location != "/?") {
        return LoginState(ams: null, loginStates: OnlineStatus.sessionErr);
      }
      final cookies = response.headers["set-cookie"];
      if (cookies == null) {
        return LoginState(ams: null, loginStates: OnlineStatus.undefined);
      }
      final match = RegExp(r'AMS_SESSION_ID=([^;]+)').firstMatch(cookies);
      if (match == null) {
        return LoginState(ams: null, loginStates: OnlineStatus.undefined);
      }
      debugPrint(match.group(1));
      return LoginState(ams: match.group(1), loginStates: OnlineStatus.ok);
    } on SocketException {
      return LoginState(ams: null, loginStates: OnlineStatus.connectionErr);
    } on TimeoutException {
      return LoginState(ams: null, loginStates: OnlineStatus.connectionErr);
    } catch (e) {
      LoginState(ams: null, loginStates: OnlineStatus.undefined);
    }
    return LoginState(ams: null, loginStates: OnlineStatus.undefined);
  }

  static Future<LogoutState> logoutIgnoreSessionErrors(String ams) async {
    final response = await FetchFinalResponse.fetchFinalResponse(
      logoutUrl,
      ams,
    );
    if (response == null) return LogoutState.connectionErr;
    if (response.request!.url.toString().startsWith(
      "https://lk.ulstu.ru/?q=auth/logout",
    )) {
      return LogoutState.ok;
    }
    return LogoutState.sessionErr;
  }
}
