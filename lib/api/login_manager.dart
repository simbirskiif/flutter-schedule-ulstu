import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:timetable/enum/login_states.dart';
import 'package:timetable/models/login_state.dart';

class LoginManager {
  final http.Client _client = http.Client();
  final String loginUrl = "https://lk.ulstu.ru/?q=auth/login";

  Future<LoginState> login(String login, String password) async {
    final uri = Uri.parse(loginUrl);

    try {
      final response = await _client
          .post(
            uri,
            body: {"login": login, "password": password},
            headers: {"Connection": "keep-alive"},
          )
          .timeout(Duration(seconds: 7));
      if (response.statusCode != 302) {
        return LoginState(ams: null, loginStates: LoginStates.undefined);
      }
      final location = response.headers["location"];
      if (location == null) {
        return LoginState(ams: null, loginStates: LoginStates.undefined);
      }
      debugPrint(location);
      if (location != "/?q=account" && location != "/?") {
        return LoginState(ams: null, loginStates: LoginStates.wrongPassword);
      }
      final cookies = response.headers["set-cookie"];
      if (cookies == null) {
        return LoginState(ams: null, loginStates: LoginStates.undefined);
      }
      final match = RegExp(r'AMS_SESSION_ID=([^;]+)').firstMatch(cookies);
      if (match == null) {
        return LoginState(ams: null, loginStates: LoginStates.undefined);
      }
      return LoginState(ams: match.group(1), loginStates: LoginStates.ok);
    } on SocketException {
      return LoginState(ams: null, loginStates: LoginStates.connectionErr);
    } on TimeoutException {
      return LoginState(ams: null, loginStates: LoginStates.connectionErr);
    } catch (e) {
      LoginState(ams: null, loginStates: LoginStates.undefined);
    }
    return LoginState(ams: null, loginStates: LoginStates.undefined);
  }
}
