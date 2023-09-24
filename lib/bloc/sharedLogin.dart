// ignore_for_file: file_names, non_constant_identifier_names
// import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

// int id_user = 1;
// String role = 'fathorrahman2357@gmail.com';
// String token = '1|BoSFqq5hocHfMKS7a2fWN4PVAwHBSs19NQoB99R2';
class SharedLogin {
  int id_user;
  String role;
  String email_verified_at;
  String token;

  SharedLogin(
      {required this.id_user,
      required this.role,
      required this.email_verified_at,
      required this.token});

  static saveSharedPref(
      int id_user, String role, String email_verified_at, String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('id_user', id_user);
    pref.setString('role', role);
    pref.setString('email_verified_at', email_verified_at);
    pref.setString('token', token);
  }

  static Future<int> getIdUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('id_user') ?? 0;
  }

  static Future<String> getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('role') ?? "null";
  }

  static Future<String> getEmailVerified() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('email_verified_at') ?? "null";
  }

  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? "null";
  }

  static removeSharedPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('id_user', 0);
    pref.setString('role', '');
    pref.setString('email_verified_at', '');
    pref.setString('token', '');
  }
}
