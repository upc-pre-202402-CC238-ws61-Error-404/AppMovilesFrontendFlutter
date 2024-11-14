import 'dart:convert';

import 'package:appmovilesfrontendflutter/api/cropPest/Pest.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestList.dart';
import 'package:appmovilesfrontendflutter/api/cropPest/PestRequest.dart';
import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:http/http.dart' as http;

class PestService {
  static Future<List<Pest>?> getPests() async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5138/api/v1/crops-management/crops/pests'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return PestList.listPest(responseJson);
    } else {
      print('Failed to get pests. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<bool> createPest(PestRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5138/api/v1/crops-management/crops/pests'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create pest. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}