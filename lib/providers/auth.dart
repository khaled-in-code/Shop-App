import 'dart:async';

import 'package:Shop_App/model/http_delete_exiption.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _autherTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authinticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAR_9jn-cFRxMZO0Jx8G2BezEcuxSzVooc";

    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            "password": password,
            "returnSecureToken": true
          }));

      var decodedResponse = json.decode(response.body);
      print(decodedResponse);

      if (decodedResponse['error'] != null) {
        throw HttpExeption(decodedResponse['error']['message']);
      }
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodedResponse['expiresIn'])));
      _userId = decodedResponse['localId'];
      _token = decodedResponse['idToken'];
      _autoLogOut();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authinticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) {
    return _authinticate(email, password, "signInWithPassword");
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_autherTimer != null) {
      _autherTimer.cancel();
      _autherTimer = null;
    }
    notifyListeners();
  }

  void _autoLogOut() {
    if (_autherTimer != null) {
      _autherTimer.cancel();
    }
    final timeToExpiary = _expiryDate.difference(DateTime.now()).inSeconds;

    _autherTimer = Timer(Duration(seconds: timeToExpiary), logOut);
  }
}
