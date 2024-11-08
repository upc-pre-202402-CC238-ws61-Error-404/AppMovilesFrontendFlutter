import 'package:flutter/material.dart';
import 'Categories.dart';
import 'Cares.dart';
import 'Diseases.dart';
import 'Pests.dart';
import 'Crops.dart'; // Import the Crops screen
import 'SignIn.dart'; // Assuming you have a Login screen

class Menu extends StatelessWidget {
  const Menu({super.key});

  void _logout(BuildContext context) {
    // Perform logout logic here, e.g., clearing tokens, etc.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Signin()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
              child: Text('Create Category'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cares()),
                );
              },
              child: Text('Create Care'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Diseases()),
                );
              },
              child: Text('Create Disease'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pests()),
                );
              },
              child: Text('Create Pest'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Crops()),
                );
              },
              child: Text('Create Crop'),
            ),
          ],
        ),
      ),
    );
  }
}