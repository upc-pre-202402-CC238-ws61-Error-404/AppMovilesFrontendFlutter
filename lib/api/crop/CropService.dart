import 'dart:convert';
import 'package:appmovilesfrontendflutter/api/crop/CropRequest.dart';
import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:http/http.dart' as http;

class CropService {
  Future<bool> createCrop(CropRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.post(
      Uri.parse('https://appmovileschaquiservertacllamaximum.azurewebsites.net/api/v1/crops-management/crops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create crop. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
