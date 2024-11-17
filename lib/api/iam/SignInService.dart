import 'dart:convert';
import 'package:appmovilesfrontendflutter/api/iam/SignInResponse.dart';
import 'package:http/http.dart' as http;
import 'SignInRequest.dart';

class SignInService {
  final String _baseUrl = 'http://10.0.2.2:5138/api/v1/authentication/sign-in';

  Future<SignInResponse?> signIn(SignInRequest request) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': request.username,
        'password': request.password,
      }),
    );

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(jsonDecode(response.body));
    } else {
      // Handle error
      return null;
    }
  }
}