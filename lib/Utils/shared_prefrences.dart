import 'dart:convert';
import 'package:food_score/model/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static late SharedPreferences _preferences;

  //* Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //* Token Methods

  //^ Save Token
  static Future<void> saveToken(String token) async =>
      await _preferences.setString("Auth-Token", token);

  //^ Get Token
  static String? getToken() => _preferences.getString("Auth-Token");

  //^ Remove Token
  static Future<void> removeToken() async =>
      await _preferences.remove("Auth-Token");

  //* User Methods

  //^ Save User ID
  static Future<void> saveUser(UserModel user) async =>
      await _preferences.setString("User", jsonEncode(user.toJson()));

  //^ Get User ID
  static UserModel? getUser() {
    String? userPref = _preferences.getString("User");
    if (userPref == null || userPref.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(userPref));
  }

  //^ Remove User ID
  static Future<void> removeUser() async =>
      await _preferences.remove("User");
}
