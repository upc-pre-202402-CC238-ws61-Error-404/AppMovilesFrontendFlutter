import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestService.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestRequest.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/Pest.dart';

class Pests extends StatefulWidget {
  const Pests({super.key});

  @override
  _PestsState createState() => _PestsState();
}

class _PestsState extends State<Pests> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();
  Future<List<Pest>?>? _futurePests;

  @override
  void initState() {
    super.initState();
    _futurePests = _fetchPests();
  }

  Future<List<Pest>?> _fetchPests() async {
    try {
      return await PestService.getPests();
    } catch (e) {
      print('Error fetching pests: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load pests: $e')),
      );
      return [];
    }
  }

  Future<void> _createPest() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final solution = _solutionController.text;
    if (name.isNotEmpty && description.isNotEmpty && solution.isNotEmpty) {
      final request = PestRequest(name: name, description: description, solution: solution);
      final success = await PestService().createPest(request);
      if (success) {
        _nameController.clear();
        _descriptionController.clear();
        _solutionController.clear();
        setState(() {
          _futurePests = _fetchPests();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create pest')),
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
        title: Text('Pests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Pest Name',
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
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child:ElevatedButton(
                onPressed: _createPest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Create', style: TextStyle(fontSize: 20)),
              ),
            ),

            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Pest>?>(
                future: _futurePests,
                builder: (context, AsyncSnapshot<List<Pest>?> snapshot) {
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
                        var pest = snapshot.data![index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Name: ${pest.name}'),
                              subtitle: Text('Description: ${pest.description}\n\nSolution: ${pest.solution}'),
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
    );
  }
}