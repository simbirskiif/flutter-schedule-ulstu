import 'package:http/http.dart' as http;

class FetchFinalResponse {
  static Future<http.Response?> fetchFinalResponse(String url, String ams) async {
    try {
      return await _fetchFinalResponse(url, ams);
    } catch (_) {
      return null;
    }
  }

  static Future<http.Response> _fetchFinalResponse(String url, String ams) async {
    final client = http.Client();
    Uri currentUrl = Uri.parse(url);
    Map<String, String> baseHeaders = {
      "Cookie": "AMS_SESSION_ID=$ams",
      "User-Agent": "Mozilla/5.0",
    };
    http.Response response;

    while (true) {
      final request = http.Request("GET", currentUrl);
      request.followRedirects = false;
      request.headers.addAll(baseHeaders);

      final streamed = await client.send(request);
      response = await http.Response.fromStream(streamed);

      if (!_isRedirect(response.statusCode)) {
        break;
      }
      final location = response.headers["location"];
      if (location == null) break;
      currentUrl = currentUrl.resolve(location);
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
}
