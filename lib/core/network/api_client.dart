import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get_json(
    String url, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: query);

    final res = await _client.get(uri, headers: {'Accept': 'application/json'});

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid JSON shape');
    }

    return decoded;
  }

  Future<Map<String, dynamic>> post_json(
    String url, {
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse(url);

    final res = await _client.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid JSON shape');
    }
    return decoded;
  }
}
