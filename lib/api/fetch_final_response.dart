import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:timetable/enum/online_status.dart';

class FetchFinalResponse {
  static Future<http.Response?> fetchFinalResponse(
    String url,
    String ams,
  ) async {
    try {
      return await _fetchFinalResponse(url, ams);
    } catch (_) {
      return null;
    }
  }

  static Future<http.Response> _fetchFinalResponse(
    String url,
    String ams,
  ) async {
    final client = http.Client();
    Uri currentUrl = Uri.parse(url);
    Map<String, String> cookies = {"AMS_SESSION_ID": ams};

    http.Response response;

    while (true) {
      final request = http.Request("GET", currentUrl);
      request.followRedirects = false;
      request.headers.addAll({
        "User-Agent": "Mozilla/5.0",
        "Cookie": cookies.entries.map((e) => "${e.key}=${e.value}").join("; "),
      });

      final streamed = await client.send(request);
      response = await http.Response.fromStream(streamed);
      final setCookies = response.headers['set-cookie'];
      if (setCookies != null) {
        for (var cookie in setCookies.split(',')) {
          var parts = cookie.split(';')[0].split('=');
          if (parts.length == 2) {
            cookies[parts[0]] = parts[1];
          }
        }
      }
      if (!_isRedirect(response.statusCode)) break;
      final location = response.headers['location'];
      if (location == null) break;
      currentUrl = currentUrl.resolve(location);
      debugPrint("redirect $location");
      debugPrint("cookies now: $cookies");
    }

    return response;
  }

  static bool _isRedirect(int statusCode) {
    return statusCode == 301 ||
        statusCode == 302 ||
        statusCode == 303 ||
        statusCode == 307 ||
        statusCode == 308;
  }

  static OnlineStatus getOnlineStatusByResponse(http.Response? response) {
    if (response == null) {
      return OnlineStatus.connectionErr;
    }
    if (response.request!.url.toString().startsWith("/?q=auth%2Flogin")) {
      return OnlineStatus.wrongPassword;
    }
    if (response.request!.url.toString().startsWith(
      "https://lk.ulstu.ru/?q=auth",
    )) {
      return OnlineStatus.sessionErr;
    }
    return OnlineStatus.ok;
  }
}
