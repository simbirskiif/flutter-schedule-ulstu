// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:html/parser.dart' show parse;

import 'package:timetable/api/fetch_final_response.dart';
import 'package:timetable/enum/online_status.dart';

class UserData {
  final String? fullName;
  final String? group;
  final OnlineStatus status;
  UserData({this.fullName, this.group, this.status = OnlineStatus.undefined});

  @override
  String toString() => 'UserData(name: $fullName, group: $group, status: $status)';
}

class UserDataFetch {
  static final String _targetUrl = "https://lk.ulstu.ru/?q=user/profile";

  static Future<UserData> getUserData(String ams) async {
    final response = await FetchFinalResponse.fetchFinalResponse(
      _targetUrl,
      ams,
    );
    if (response == null) {
      return UserData(status: OnlineStatus.connectionErr);
    }
    if (response.request!.url.toString().startsWith(
      "https://lk.ulstu.ru/?q=auth",
    )) {
      return UserData(status: OnlineStatus.sessionErr);
    }
    // debugPrint(response.request!.url.toString());
    // debugPrint(response.request!.headers["location"]);
    return UserData(
      status: OnlineStatus.ok,
      fullName: _processProfileName(response.body),
      group: _processProfileGroup(response.body),
    );
    // debugPrint(response.body);
    // debugPrint(response.headers["location"]);

    // debugPrint(ams);
    // Uri uri = Uri.parse(loginUrl);
    // var response = await _client
    //     .get(
    //       uri,
    //       headers: {
    // "Cookie": "AMS_SESSION_ID=$ams",
    // "User-Agent":
    //     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    //     "AppleWebKit/537.36 (KHTML, like Gecko) "
    //     "Chrome/121.0.0.0 Safari/537.36",
    // "Accept": "text/html",
    // "Accept-Language": "ru-RU,ru;q=0.9",
    // "Referer": "https://lk.ulstu.ru/",
    //       },
    //     )
    //     .timeout(Duration(seconds: 7));
    // // final location = response.headers["location"];
    // final cookies = response.headers["set-cookie"];
    // debugPrint(response.request.toString());
    // debugPrint(cookies);
    // // debugPrint(response.body);
  }

  static String? _processProfileName(String raw) {
    final document = parse(raw);

    final elements = document.querySelectorAll(
      'div.row.align-items-center > div',
    );

    for (int i = 0; i < elements.length - 1; i += 2) {
      final label = elements[i].text.trim();
      final value = elements[i + 1].text.trim();

      if (label.contains("Ф.И.О.")) {
        return value;
      }
    }
    return null;
  }

  static String? _processProfileGroup(String raw) {
    final document = parse(raw);

    final elements = document.querySelectorAll(
      'div.row.align-items-center > div',
    );

    for (int i = 0; i < elements.length - 1; i += 2) {
      final label = elements[i].text.trim();
      final value = elements[i + 1].text.trim();

      if (label.contains("Группа")) {
        return value;
      }
    }
    return null;
  }
}
