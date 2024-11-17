import 'package:appmovilesfrontendflutter/api/cropCare/Care.dart';
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
  Future<List<Care>?>? _futureCares;


  @override
  void initState() {
    super.initState();
    _loadCares();
  }

  void _loadCares() {
    setState(() {
      _futureCares = CareService.getCares();
    });
  }


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
        _loadCares();
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
        backgroundColor: Color(0xFF005F40),
        foregroundColor: Colors.white,
        title: Text('Create Care'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _suggestionController,
              decoration: InputDecoration(
                labelText: 'Suggestion',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createCare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Create', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
                child: FutureBuilder<List<Care>?>(
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
    );
  }
}
