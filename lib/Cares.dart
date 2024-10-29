import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/cropCare/CareService.dart';
import 'package:appmovilesfrontendflutter/api/cropCare/CareRequest.dart';

class Cares extends StatefulWidget {
  const Cares({super.key});

  @override
  _CaresState createState() => _CaresState();
}

class _CaresState extends State<Cares> {
  final TextEditingController _suggestionController = TextEditingController();
  final CareService _careService = CareService();

  void _createCare() async {
    final suggestion = _suggestionController.text;
    if (suggestion.isNotEmpty) {
      final careRequest = CareRequest(suggestion: suggestion);
      final success = await _careService.createCare(careRequest);
      if (success) {
        _suggestionController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Care created successfully')),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create care')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Suggestion cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Care'),
      ),
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
          ],
        ),
      ),
    );
  }
}