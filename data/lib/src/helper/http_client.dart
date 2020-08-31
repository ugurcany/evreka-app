import 'dart:convert';

import 'package:dio/dio.dart';

class HTTPClient {
  Dio _dio;

  HTTPClient() {
    _dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
        },
      ),
    );
  }

  HTTPClient basicAuth(String username, String password) {
    String basicAuth =
        "Basic " + base64Encode(utf8.encode("$username:$password"));
    _dio.options.headers["Authorization"] = basicAuth;
    return this;
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic> queryParams,
  }) async {
    Response<T> response = await _dio.get<T>(
      url,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<T> post<T>(
    String url, {
    Map<String, dynamic> data,
    Map<String, dynamic> queryParams,
  }) async {
    Response<T> response = await _dio.post<T>(
      url,
      data: data,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<T> delete<T>(
    String url, {
    Map<String, dynamic> data,
    Map<String, dynamic> queryParams,
  }) async {
    Response<T> response = await _dio.delete<T>(
      url,
      data: data,
      queryParameters: queryParams,
    );
    return response.data;
  }
}
