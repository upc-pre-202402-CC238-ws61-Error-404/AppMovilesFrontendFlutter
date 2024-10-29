import 'package:appmovilesfrontendflutter/api/cropPest/Pest.dart';

class PestList {
  static List<Pest> listPest(List<dynamic> JsonList) {
    List<Pest> listPests = [];
    if (JsonList != null) {
      for (var item in JsonList) {
        final pest = Pest.fromJson(item);
        listPests.add(pest);
      }
    }
    return listPests;
  }
}