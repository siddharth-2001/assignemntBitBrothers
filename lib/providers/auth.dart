import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String _userId = 'guest';
  String _token = 'null';

  Future<void> autoLogin() async {
    if (isAuth()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userId') != null) {
      _userId = prefs.getString('userId')!;
      _token = prefs.getString('token')!;
      notifyListeners();
    } else
      return;
  }

  bool isAuth() {
    if (_userId != 'guest') return true;
    return false;
  }

  String get userMail {
    return _userId.toString();
  }

  Future<void> login(email, pass) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAXYoj7ysIM2QIeB6A6lZ_K94kXaMy9IaE');
    final res = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': pass,
        }));
    final data = jsonDecode(res.body) as Map;
    if (data.containsKey('error')) {
      throw HttpException(data['error']['message']);
    }
    _userId = email;
    _token = data['idToken'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _userId);
    prefs.setString('token', _token);
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _userId = 'guest';
    _token = 'null';
  }

  Future<void> register(email, pass) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAXYoj7ysIM2QIeB6A6lZ_K94kXaMy9IaE');
    final res = await http.post(url,
        body: jsonEncode({
          'email': email,
          'password': pass,
        }));
    final data = jsonDecode(res.body) as Map;
    if (data.containsKey('error')) {
      throw HttpException(data['error']['message']);
    }
    _userId = email;
    _token = data['idToken'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', _userId);
    prefs.setString('token', _token);
    notifyListeners();
  }
}
