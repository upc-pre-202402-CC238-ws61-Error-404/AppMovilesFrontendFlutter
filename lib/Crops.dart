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

  Future<void> _createCrop() async {
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

      final success = await CropService().createCrop(request);
      if (success) {
        _nameController.clear();
        _imageUrlController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDiseases = [];
          _selectedPests = [];
          _selectedCares = [];
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
        title: Text('Create Crop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _selectDiseases,
              child: Text('Select Diseases'),
            ),
            ElevatedButton(
              onPressed: _selectPests,
              child: Text('Select Pests'),
            ),
            ElevatedButton(
              onPressed: _selectCares,
              child: Text('Select Cares'),
            ),
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