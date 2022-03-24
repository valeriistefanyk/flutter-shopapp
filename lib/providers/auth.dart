import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  //String _token;
  //DateTime _expiryDate;
  //String _userId;
  static const _key = 'AIzaSyD7EkpmzLdMZscVweDCDPJrVBZBbg8yJng';
  static const _domain = 'https://identitytoolkit.googleapis.com';

  Future<http.Response> _authenticate(
      String email, String password, String urlSegment) async {
    return await http.post(
        Uri.parse('$_domain/v1/accounts:$urlSegment?key=$_key'),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
  }

  Future<void> login(String email, String password) async {
    try {
      final rawResponse =
          await _authenticate(email, password, 'signInWithPassword');
      final response = json.decode(rawResponse.body);
      print(response);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      final rawResponse = await _authenticate(email, password, 'signUp');
      final response = json.decode(rawResponse.body);
      print(response);
    } catch (e) {
      print('error: ${e.toString()}');
    }
  }
}
