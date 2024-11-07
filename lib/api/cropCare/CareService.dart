import 'dart:convert';


import 'package:appmovilesfrontendflutter/api/cropCare/Care.dart';
import 'package:appmovilesfrontendflutter/api/cropCare/CareRequest.dart';
import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:http/http.dart' as http;

import 'CareList.dart';

class CareService {
  static Future<List<Care>?> getCares() async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.get(
      Uri.parse('https://appmovileschaquiservertacllamaximum.azurewebsites.net/api/v1/crops-management/crops/cares'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return CareList.listCare(responseJson);
    } else {
      print('Failed to get cares. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  }

  Future<bool> createCare(CareRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.post(
      Uri.parse('https://appmovileschaquiservertacllamaximum.azurewebsites.net/api/v1/crops-management/crops/cares'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create care. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
