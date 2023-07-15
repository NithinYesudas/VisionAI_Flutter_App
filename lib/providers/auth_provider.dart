import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool? isAuthenticated;

  Future<void> checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("accessToken");
    if (accessToken != null) {
      isAuthenticated = true;
    } else {
      isAuthenticated = false;
    }
    notifyListeners();

  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("accessToken");
    prefs.remove("refreshToken");
    isAuthenticated = false;
    notifyListeners();
  }
}
