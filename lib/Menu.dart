import 'package:appmovilesfrontendflutter/api/memes/Meme.dart';
import 'package:flutter/material.dart';
import 'Categories.dart';
import 'Cares.dart';
import 'Diseases.dart';
import 'Pests.dart';
import 'Crops.dart'; // Import the Crops screen
import 'SignIn.dart';
import 'api/memes/MemeService.dart'; // Assuming you have a Login screen


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MemeService memeService = MemeService();
  Future<Meme>? meme;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    meme = _fetchMeme();
  }

  Future<Meme>? _fetchMeme() async {
    try{
      return await MemeService().getMeme();
    } catch (e) {
      print('Error fetching meme: $e');
      throw Exception('Failed to load meme');
    }
  }
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
        backgroundColor: Color(0xFF005F40),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.category_outlined, size: 50),
                      SizedBox(width: 16),
                      Text('Create Category',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Popins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cares()),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, size: 50),
                      SizedBox(width: 16),
                      Text('Create Care',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Popins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Diseases()),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.bug_report_outlined, size: 50),
                      SizedBox(width: 16),
                      Text('Create Disease',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Popins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pests()),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.bug_report_outlined, size: 50),
                      SizedBox(width: 16),
                      Text('Create Pest',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Popins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Crops()),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(Icons.park_outlined, size: 50),
                      SizedBox(width: 16),
                      Text('Create Crop',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Popins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Comentado por la funa
            /*FutureBuilder<Meme>(
              future: meme,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load meme'));
                } else if (snapshot.hasData) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 350,
                        child: snapshot.data!.preview.isNotEmpty
                            ? Image.network(
                          snapshot.data!.preview.last,
                          fit: BoxFit.cover, // Ajusta la imagen para cubrir el tamaño del contenedor
                        )
                            : Text('No preview available'),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No meme available'));
                }
              },
            )*/



          ],
        ),
      ),
    );
  }
}
