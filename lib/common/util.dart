import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static void execAfterBinding(Function fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn();
    });
  }

  static Future<bool> isSharedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<T> getSharedData<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    T result;

    switch (T) {
      case bool:
        result = prefs.getBool(key) as T;
        break;
      case String:
        result = prefs.getString(key) as T;
        break;
      case int:
        result = prefs.getInt(key) as T;
        break;
      case double:
        result = prefs.getDouble(key) as T;
        break;
      case List<String>:
        result = prefs.getStringList(key) as T;
        break;
      default:
        result = prefs.get(key) as T;
    }
    return result;
  }

  static Future setSharedData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case List<String>:
        prefs.setStringList(key, value as List<String>);
        break;
    }
  }
}
