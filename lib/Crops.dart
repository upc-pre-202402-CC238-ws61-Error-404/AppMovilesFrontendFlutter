import 'package:appmovilesfrontendflutter/api/crop/Crop.dart';
import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropService.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropRequest.dart';
import 'package:appmovilesfrontendflutter/api/cropDisease/DiseaseService.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestService.dart';
import 'package:appmovilesfrontendflutter/api/cropCare/CareService.dart';
import 'package:appmovilesfrontendflutter/api/CropDisease/Disease.dart' as CropDisease;
import 'package:appmovilesfrontendflutter/api/cropPest/Pest.dart';
import 'package:appmovilesfrontendflutter/api/cropCare/Care.dart';

class Crops extends StatefulWidget {
  const Crops({super.key});

  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<int> _selectedDiseases = [];
  List<int> _selectedPests = [];
  List<int> _selectedCares = [];
  Future<List<Crop>>? _futureCrops;
  Crop? _selectedCrop;


  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  void _loadCrops() {
    setState(() {
      _futureCrops = CropService().getCrops();
    });
  }

  Future<void> _createOrUpdateCrop() async {
    final name = _nameController.text;
    final imageUrl = _imageUrlController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && imageUrl.isNotEmpty && description.isNotEmpty) {
      final request = CropRequest(
        name: name,
        imageUrl: imageUrl,
        description: description,
        diseases: _selectedDiseases,
        pests: _selectedPests,
        cares: _selectedCares,
      );

      bool success;
      if (_selectedCrop == null) {
        success = await CropService().createCrop(request);
      } else {
        success = await CropService().updateCrop(_selectedCrop!.id, request);
      }

      if (success) {
        _nameController.clear();
        _imageUrlController.clear();
        _descriptionController.clear();
        _selectedCrop = null;
        setState(() {
          _selectedDiseases = [];
          _selectedPests = [];
          _selectedCares = [];
          _futureCrops = CropService().getCrops();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Crop saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save crop')),
        );
      }
    }
  }

  void _editCrop(Crop crop) {
    setState(() {
      _nameController.text = crop.name;
      _imageUrlController.text = crop.imageUrl;
      _descriptionController.text = crop.description;
      _selectedDiseases = crop.diseases;
      _selectedPests = crop.pests;
      _selectedCares = crop.cares;
      _selectedCrop = crop;
    });
  }

  Future<void> _deleteCrop(int cropId) async {
    final success = await CropService().deleteCrop(cropId);
    if (success) {
      setState(() {
        _futureCrops = CropService().getCrops();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete crop')),
      );
    }
  }

  Future<void> _selectDiseases() async {
    final diseases = await DiseaseService.getDiseases();
    if (diseases != null) {
      final selected = await showDialog<List<int>>(
        context: context,
        builder: (context) {
          return MultiSelectDialog<CropDisease.Disease>(
            items: diseases,
            title: 'Select Diseases',
            selectedItems: _selectedDiseases,
          );
        },
      );
      if (selected != null) {
        setState(() {
          _selectedDiseases = selected;
        });
      }
    }
  }

  Future<void> _selectPests() async {
    final pests = await PestService.getPests();
    if (pests != null) {
      final selected = await showDialog<List<int>>(
        context: context,
        builder: (context) {
          return MultiSelectDialog<Pest>(
            items: pests,
            title: 'Select Pests',
            selectedItems: _selectedPests,
          );
        },
      );
      if (selected != null) {
        setState(() {
          _selectedPests = selected;
        });
      }
    }
  }

  Future<void> _selectCares() async {
    final cares = await CareService.getCares();
    if (cares != null) {
      final selected = await showDialog<List<int>>(
        context: context,
        builder: (context) {
          return MultiSelectDialog<Care>(
            items: cares,
            title: 'Select Cares',
            selectedItems: _selectedCares,
          );
        },
      );
      if (selected != null) {
        setState(() {
          _selectedCares = selected;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005F40),
        foregroundColor: Colors.white,
        title: Text('Create Crop'),
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
            SizedBox(height: 10),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child:ElevatedButton(
                onPressed: _selectDiseases,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Select Diseases', style: TextStyle(fontSize: 20)),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectPests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Select Pests', style: TextStyle(fontSize: 20)),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectCares,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Select Cares', style: TextStyle(fontSize: 20)),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createOrUpdateCrop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Create', style: TextStyle(fontSize: 20)),
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Crop>>(
                future: _futureCrops,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No crops available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var crop = snapshot.data![index];
                        return Dismissible(
                          key: Key(crop.id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteCrop(crop.id);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text('Id: ${crop.id}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${crop.name}'),
                                  Text('Description: ${crop.description}'),
                                  Text('Cares: ${crop.cares}'),
                                  Text('Diseases: ${crop.diseases}'),
                                  Text('Pests: ${crop.pests}'),
                                  Text('Image: ${crop.imageUrl.length > 20 ? crop.imageUrl.substring(0, 20) + '...' : crop.imageUrl}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editCrop(crop),
                              ),
                            ),
                          ),
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
    );
  }
}

class MultiSelectDialog<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final List<int> selectedItems;

  MultiSelectDialog({required this.items, required this.title, required this.selectedItems});

  @override
  _MultiSelectDialogState<T> createState() => _MultiSelectDialogState<T>();
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  late List<int> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            final index = widget.items.indexOf(item);
            return CheckboxListTile(
              title: Text(item.toString()),
              value: _selectedItems.contains(index),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedItems.add(index);
                  } else {
                    _selectedItems.remove(index);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, _selectedItems);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}