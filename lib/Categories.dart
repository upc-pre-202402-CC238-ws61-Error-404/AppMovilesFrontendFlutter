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
  Category? _selectedCategory;

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

  Future<void> _createOrUpdateCategory() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      final request = CategoryRequest(name: name);
      bool success;
      if (_selectedCategory == null) {
        success = await CategoryService().createCategory(request);
      } else {
        success = await CategoryService().updateCategory(_selectedCategory!.categoryId, request);
      }
      if (success) {
        _nameController.clear();
        _selectedCategory = null;
        setState(() {
          _futureCategories = _fetchCategories();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save category')),
        );
      }
    }
  }

  void _editCategory(Category category) {
    setState(() {
      _nameController.text = category.name;
      _selectedCategory = category;
    });
  }

  Future<void> _deleteCategory(int categoryId) async {
    final success = await CategoryService().deleteCategory(categoryId);
    if (success) {
      setState(() {
        _futureCategories = _fetchCategories();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005F40),
        foregroundColor: Colors.white,
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createOrUpdateCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9A5D4E),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save', style: TextStyle(fontSize: 20)),
              ),
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
                        return Dismissible(
                          key: Key(category.categoryId.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteCategory(category.categoryId);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text('Id: ${category.categoryId}'),
                              subtitle: Text('Name: ${category.name}'),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editCategory(category),
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