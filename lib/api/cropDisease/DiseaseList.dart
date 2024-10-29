import 'package:appmovilesfrontendflutter/api/CropDisease/Disease.dart';

class DiseaseList {
  static List<Disease> listDisease(List<dynamic> JsonList) {
    List<Disease> listDiseases = [];
    if (JsonList != null) {
      for (var item in JsonList) {
        final disease = Disease.fromJson(item);
        listDiseases.add(disease);
      }
    }
    return listDiseases;
  }
}