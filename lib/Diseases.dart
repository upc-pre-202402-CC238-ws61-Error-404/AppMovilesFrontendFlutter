import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/CropDisease/Disease.dart' as CropDisease;
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseRequest.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseService.dart';

class Diseases extends StatefulWidget {
  const Diseases({super.key});

  @override
  _DiseasesState createState() => _DiseasesState();
}

class _DiseasesState extends State<Diseases> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  Future<List<CropDisease.Disease>?>? _futureDiseases;

  @override
  void initState() {
    super.initState();
    _futureDiseases = _fetchDiseases();
  }

  Future<List<CropDisease.Disease>?> _fetchDiseases() async {
    try {
      return await DiseaseService.getDiseases();
    } catch (e) {
      print('Error fetching diseases: $e'); // Log the exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load diseases: $e')),
      );
      return [];
    }
  }

  Future<void> _createDisease() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final solution = _solutionController.text;
    if (name.isNotEmpty && description.isNotEmpty && solution.isNotEmpty) {
      final request = DiseaseRequest(name: name, description: description, solution: solution);
      final success = await DiseaseService().createDisease(request);
      if (success) {
        _nameController.clear();
        _descriptionController.clear();
        _solutionController.clear();
        setState(() {
          _futureDiseases = _fetchDiseases();
        });
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
        backgroundColor: Color(0xFF005F40),
        foregroundColor: Colors.white,
        title: Text('Diseases'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _solutionController,
              decoration: InputDecoration(
                labelText: 'Solution',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createDisease,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Create', style: TextStyle(fontSize: 20)),
              ),
            ),

            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<CropDisease.Disease>?>(
                future: _futureDiseases,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var disease = snapshot.data![index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Name: ${disease.name}'),
                              subtitle: Text('Description: ${disease.description}\n\nSolution: ${disease.solution}'),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      /*
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _suggestionController,
              decoration: InputDecoration(labelText: 'Suggestion'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createCare,
              child: Text('Create Care'),
            ),
            SizedBox(height: 16),

            Expanded(child: FutureBuilder<List<Care>?>(
              future: CareService.getCares(),
              builder: (context, AsyncSnapshot<List<Care>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var care = snapshot.data![index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text('Id: ${care.id}'),
                            subtitle: Text('Suggestion: ${care.suggestion}'),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
      * */
    );
  }
}