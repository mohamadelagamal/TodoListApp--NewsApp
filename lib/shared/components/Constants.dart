
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveThemeMode(ThemeMode mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeMode', mode == ThemeMode.dark ? 1 : 0);
}

Future<ThemeMode> loadThemeMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int mode = prefs.getInt('themeMode') ?? 0;
  return mode == 1 ? ThemeMode.dark : ThemeMode.light;
}
// make method return theme mode value from shared prefrences
