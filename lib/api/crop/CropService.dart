import 'dart:convert';
import 'package:appmovilesfrontendflutter/api/crop/Crop.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropList.dart';
import 'package:appmovilesfrontendflutter/api/crop/CropRequest.dart';
import 'package:appmovilesfrontendflutter/api/iam/AuthManager.dart';
import 'package:http/http.dart' as http;

class CropService {

  Future<bool> createCrop(CropRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.post(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/crops-management/crops'),
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

  Future<List<Crop>> getCrops() async{
    final token = AuthManager().signInResponse?.token;
    final response = await http.get(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/crops-management/crops'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return CropList.listCrop(jsonList);
    } else {
      print('Failed to get crops. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return [];
    }
  }

  Future<bool> updateCrop(int cropId, CropRequest request) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.put(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/crops-management/crops/$cropId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update crop. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteCrop(int cropId) async {
    final token = AuthManager().signInResponse?.token;
    final response = await http.delete(
      Uri.parse('https://appfinalwowmovil.azurewebsites.net/api/v1/crops-management/crops/$cropId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Failed to delete crop. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }
}
