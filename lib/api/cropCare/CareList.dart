import 'package:appmovilesfrontendflutter/api/cropCare/Care.dart';

class CareList {
  static List<Care> listCare(List<dynamic> JsonList) {
    List<Care> listCares = [];
    if (JsonList != null) {
      for (var item in JsonList) {
        final care = Care.fromJson(item);
        listCares.add(care);
      }
    }
    return listCares;
  }
}