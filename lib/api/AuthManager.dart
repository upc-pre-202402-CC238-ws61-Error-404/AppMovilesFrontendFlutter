import 'package:appmovilesfrontendflutter/api/SignInResponse.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  SignInResponse? _signInResponse;

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  SignInResponse? get signInResponse => _signInResponse;

  set signInResponse(SignInResponse? value) {
    _signInResponse = value;
  }
}