import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class AuthServices {
  static Future<bool> login(
      String email, String password, BuildContext context) async {
    bool isSuccessful = false;
    try {
      final url = Uri.parse("${Constants.baseUrl}auth/login/");
      final response = await http.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json'
      }, body: {
        "username": email,
        "password": password
      });

      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody["access_token"];
      final refreshToken = responseBody["refresh_token"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("accessToken", accessToken);
      prefs.setString("refreshToken", refreshToken);

      if (response.statusCode == 200) {
        isSuccessful = true;
      }
    } on HttpException  {

      isSuccessful = false;
    } catch (e) {
      isSuccessful = false;

    }
    return isSuccessful;
  }

  static Future<bool> register(
      String email, String password, BuildContext context) async {
    bool isSuccessful = false;
    try {
      final url = Uri.parse("${Constants.baseUrl}auth/register/");
      final response = await http.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json'
      }, body: {
        "username": email,
        "password": password,
        "name": "User"
      });

      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody["access_token"];
      final refreshToken = responseBody["refresh_token"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("accessToken", accessToken);
      prefs.setString("refreshToken", refreshToken);

      if (response.statusCode == 200) {
        isSuccessful = true;
      }
    } on HttpException {
      isSuccessful = false;
    } catch (e) {
      isSuccessful = false;
    }
    return isSuccessful;
  }
}
