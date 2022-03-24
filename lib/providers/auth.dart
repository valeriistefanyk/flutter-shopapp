import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';
import '../secrets.dart';

const errors = {
  'EMAIL_EXISTS': 'The email address already exists',
  'OPERATION_NOT_ALLOWED': 'Operation not allowed',
  'TOO_MANY_ATTEMPTS_TRY_LATER': 'Too many attempts. Try again later',
  'EMAIL_NOT_FOUND': 'Email not found',
  'INVALID_PASSWORD': 'Email or password is invalid',
  'USER_DISABLED': 'The user account has been disabled',
  'UNKNOWN_ERROR': 'Unknown error',
};

class Auth with ChangeNotifier {
  //String _token;
  //DateTime _expiryDate;
  //String _userId;
  static const _domain = 'https://identitytoolkit.googleapis.com';

  Future<dynamic> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final rawResponse = await http.post(
          Uri.parse('$_domain/v1/accounts:$urlSegment?key=$FIREBASE_API_KEY'),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      if (rawResponse.statusCode >= 400) {
        final response = json.decode(rawResponse.body);
        if (errors.containsKey(response['error']['message'])) {
          throw HttpException(
              errors[response['error']['message']] ?? 'Unknown error');
        } else {
          throw HttpException('Unknown error');
        }
      }
      return json.decode(rawResponse.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }
}
