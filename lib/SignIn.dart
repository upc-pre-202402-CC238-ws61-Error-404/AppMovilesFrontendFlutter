import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:appmovilesfrontendflutter/api/iam/SignInRequest.dart';
import 'package:appmovilesfrontendflutter/api/iam/SignInService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Menu.dart';

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
      // Navigate to Menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
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
      body: Container(
        color: Color(0xFF7C7C7C),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Sign In',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Popins',
                        )
                    ),

                    Icon(Icons.person_outline, size: 130),


                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child:ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF005F40),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Sign In',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}