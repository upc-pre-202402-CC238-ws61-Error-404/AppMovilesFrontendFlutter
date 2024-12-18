import 'dart:convert';
import 'package:appmovilesfrontendflutter/api/category/Category.dart';
import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:http/http.dart' as http;
import 'CategoryRequest.dart';
import 'CategoryList.dart';

class CategoryService {
  static Future<List<Category>?> getCategories() async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.get(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/forum/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return CategoryList.listCategory(responseJson);
    } else {
      print('Failed to get categories. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<bool> createCategory(CategoryRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.post(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/forum/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create category. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> updateCategory(int categoryId, CategoryRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.put(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/forum/categories/$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update category. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteCategory(int categoryId) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.delete(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/forum/categories/$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Failed to delete category. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

}