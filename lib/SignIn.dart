import 'package:appmovilesfrontendflutter/api/AuthManager.dart';
import 'package:appmovilesfrontendflutter/api/SignInRequest.dart';
import 'package:appmovilesfrontendflutter/api/SignInService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignInService _signInService = SignInService();

  void _signIn() async {
    final request = SignInRequest(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    final response = await _signInService.signIn(request);

    if (response != null) {
      // Store the SignInResponse instance
      AuthManager().signInResponse = response;
      // Handle successful sign-in
      if (kDebugMode) {
        print('Sign-in successful: ${response.token}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in successful: ${response.username}')),
      );
    } else {
      // Handle sign-in error
      if (kDebugMode) {
        print('Sign-in failed');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}