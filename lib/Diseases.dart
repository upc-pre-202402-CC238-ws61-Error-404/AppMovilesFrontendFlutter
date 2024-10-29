import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseService.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/Disease.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseRequest.dart';

class Diseases extends StatefulWidget {
  const Diseases({super.key});

  @override
  _DiseasesState createState() => _DiseasesState();
}

class _DiseasesState extends State<Diseases> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  late Future<List<Disease>?> _futureDiseases;

  @override
  void initState() {
    super.initState();
    _futureDiseases = DiseaseService.getDiseases();
  }

  Future<void> _createDisease() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final solution = _solutionController.text;
    if (name.isNotEmpty && description.isNotEmpty && solution.isNotEmpty) {
      final request = DiseaseRequest(
        name: name,
        description: description,
        solution: solution,
      );
      final success = await DiseaseService().createDisease(request);
      if (success) {
        _nameController.clear();
        _descriptionController.clear();
        _solutionController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disease created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create disease')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diseases'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Disease Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _solutionController,
              decoration: InputDecoration(labelText: 'Solution'),
            ),
            FutureBuilder<List<Disease>?>(
              future: _futureDiseases,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No diseases available');
                } else {
                  return DropdownButton<int>(
                    hint: Text('Select Disease'),
                    items: snapshot.data!.map((disease) {
                      return DropdownMenuItem<int>(
                        value: disease.id,
                        child: Text(disease.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        // Handle disease selection
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createDisease,
              child: Text('Create Disease'),
            ),
          ],
        ),
      ),
    );
  }
}