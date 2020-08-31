import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static Future<T> get<T>(String key, {T Function(Map) deserializer}) async {
    String encodedValue =
        (await SharedPreferences.getInstance()).getString(key);
    if (T is String) return encodedValue as T;
    if (T is int) return int.parse(encodedValue) as T;
    if (T is double) return double.parse(encodedValue) as T;
    if (T is bool) return (encodedValue.toLowerCase() == "true") as T;
    if (encodedValue != null && deserializer != null)
      return deserializer(jsonDecode(encodedValue));
    if (encodedValue != null) return jsonDecode(encodedValue);
    return null;
  }

  static Future<bool> put<T>(String key, T value) async {
    String encodedValue = jsonEncode(value);
    return (await SharedPreferences.getInstance()).setString(key, encodedValue);
  }

  static Future<bool> delete(String key) async {
    return (await SharedPreferences.getInstance()).remove(key);
  }
}
