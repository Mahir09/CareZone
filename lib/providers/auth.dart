import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_exceptions.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String userName, String urlSeg) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSeg?key=AIzaSyDC3y3EnE-TJuyY6mDAN-TFpgAclses92c';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var _responseData = json.decode(response.body);
      if (_responseData['error'] != null)
        throw CustomExceptions(_responseData['error']['message']);

      _token = _responseData['idToken'];
      _userId = _responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            _responseData['expiresIn'],
          ),
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          'emailId': email,
          'userName': userName,
        },
      );
      prefs.setString('userData', userData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password, String userName) async {
    return _authenticate(email, password, userName, 'accounts:signUp');
  }

  Future<void> signIn(String email, String password, String userName) async {
    return _authenticate(
        email, password, userName, 'accounts:signInWithPassword');
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final userExpiryDate = DateTime.parse(extractedData['expiryDate']);
    if (userExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = DateTime.parse(extractedData['expiryDate']);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}
