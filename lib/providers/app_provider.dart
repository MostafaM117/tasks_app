import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool isDark = false;
  void setIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    await prefs.setBool('isDark', !isDark);
    this.isDark = isDark;
    notifyListeners();
  }

  void getisDark() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    this.isDark = isDark;
    notifyListeners();
  }
}
