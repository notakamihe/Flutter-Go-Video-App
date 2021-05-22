import 'dart:convert';

import 'package:frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  static User user;
  static bool isLoggedIn = false;

  static bool isAuthenticated(User other) {
    return user?.id == other.id;
  }

  static bool isAuthenticatedJSON(dynamic other) {
    return user?.id == other["_id"];
  }

  static Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove("token");
    user = null;
    isLoggedIn = false;
  }

  static Future<void> setUser() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var response = await http.get(Uri.http("localhost:8000", "/api/user"), headers: {"x-access-token": token});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      user = User.fromJson(json);
      isLoggedIn = true;
    } else {
      user = null;
      isLoggedIn = false;
    }
  }
}