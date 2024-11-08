import 'package:flutter/material.dart';
import 'package:appmovilesfrontendflutter/api/category/CategoryService.dart';
import 'package:appmovilesfrontendflutter/api/category/CategoryRequest.dart';
import 'package:appmovilesfrontendflutter/api/category/Category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final TextEditingController _nameController = TextEditingController();
  Future<List<Category>?>? _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _fetchCategories();
  }

  Future<List<Category>?> _fetchCategories() async {
    try {
      return await CategoryService.getCategories();
    } catch (e) {
      print('Error fetching categories: $e'); // Log the exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
      return [];
    }
  }

  Future<void> _createCategory() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      final request = CategoryRequest(name: name);
      final success = await CategoryService().createCategory(request);
      if (success) {
        _nameController.clear();
        setState(() {
          _futureCategories = _fetchCategories();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create category')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createCategory,
              child: Text('Create Category'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Category>?>(
                future: _futureCategories,
                builder: (context, AsyncSnapshot<List<Category>?> snapshot) {
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
                        var category = snapshot.data![index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Id: ${category.categoryId}'),
                              subtitle: Text('Name: ${category.name}'),
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