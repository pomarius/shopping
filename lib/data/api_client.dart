import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../constants/network/keys.dart';
import 'api_exception.dart';

class ApiClient {
  final Client _httpClient = Client();
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    try {
      final Uri uri = Uri.https(baseUrl, path, params);
      final Response response = await _httpClient.get(uri, headers: headers);
      return _response(response);
    } on SocketException {
      throw ApiException('No Internet connection');
    }
  }

  dynamic _response(Response response) {
    final Map<String, dynamic> decodedJson = json.decode(
      utf8.decode(response.bodyBytes),
    );

    if (response.statusCode >= 300) {
      final StringBuffer stringBuffer = StringBuffer();
      final List<String> errorKeys = decodedJson.keys.toList();

      for (int i = 0; i < errorKeys.length; i++) {
        final String key = errorKeys[i];
        stringBuffer.write(
          i == errorKeys.length - 1
              ? '${decodedJson[key]}'
              : '${decodedJson[key]}\n',
        );
      }

      throw ApiException(
        stringBuffer.toString(),
        response.statusCode,
      );
    }

    final String? statusCode = decodedJson[Keys.apiClientResponseStatusCode];
    if (statusCode != null && statusCode != 'ok') {
      throw decodedJson[Keys.apiClientResponseDescription];
    }

    return decodedJson;
  }
}
