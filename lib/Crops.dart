import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropService.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropRequest.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseService.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestService.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/Disease.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/Pest.dart';

class Crops extends StatefulWidget {
  const Crops({super.key});

  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _careIdController = TextEditingController();
  List<int> _selectedDiseases = [];
  List<int> _selectedPests = [];
  List<int> _selectedCares = [];
  late Future<List<Disease>?> _futureDiseases;
  late Future<List<Pest>?> _futurePests;

  @override
  void initState() {
    super.initState();
    _futurePests = PestService.getPests();
  }

  Future<void> _createCrop() async {
    final name = _nameController.text;
    final imageUrl = _imageUrlController.text;
    final description = _descriptionController.text;
    final careId = int.tryParse(_careIdController.text);
    if (name.isNotEmpty && imageUrl.isNotEmpty && description.isNotEmpty && careId != null) {
      _selectedCares.add(careId);
      final request = CropRequest(
        name: name,
        imageUrl: imageUrl,
        description: description,
        diseases: _selectedDiseases,
        pests: _selectedPests,
        cares: _selectedCares,
      );
      final success = await CropService().createCrop(request);
      if (success) {
        _nameController.clear();
        _imageUrlController.clear();
        _descriptionController.clear();
        _careIdController.clear();
        setState(() {
          _selectedDiseases.clear();
          _selectedPests.clear();
          _selectedCares.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crop created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create crop')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crops'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Crop Name'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
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
                        if (value != null && !_selectedDiseases.contains(value)) {
                          _selectedDiseases.add(value);
                        }
                      });
                    },
                  );
                }
              },
            ),
            FutureBuilder<List<Pest>?>(
              future: _futurePests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No pests available');
                } else {
                  return DropdownButton<int>(
                    hint: Text('Select Pest'),
                    items: snapshot.data!.map((pest) {
                      return DropdownMenuItem<int>(
                        value: pest.id,
                        child: Text(pest.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value != null && !_selectedPests.contains(value)) {
                          _selectedPests.add(value);
                        }
                      });
                    },
                  );
                }
              },
            ),
            TextField(
              controller: _careIdController,
              decoration: InputDecoration(labelText: 'Care ID'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createCrop,
              child: Text('Create Crop'),
            ),
          ],
        ),
      ),
    );
  }
}