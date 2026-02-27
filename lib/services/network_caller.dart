import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postapp/services/network_response.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {'Content-Type': 'application/json'};
      final http.Response response = await http.get(uri, headers: headers);
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: response.body,
          errorMessage: "Request failed....!",
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {'Content-Type': 'application/json'};
      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Request failed....!",
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> purRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {'Content-Type': 'application/json'};
      final http.Response response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Request failed....!",
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> deleteRequest({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      final headers = {'Content-Type': 'application/json'};
      final http.Response response = await http.delete(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Request failed....!",
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
