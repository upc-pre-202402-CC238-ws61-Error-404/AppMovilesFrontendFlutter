import 'package:appmovilesfrontendflutter/api/crop/Crop.dart';

class CropList{
  static List<Crop> listCrop(List<dynamic> JsonList){
    List<Crop> listCrops = [];
    if(JsonList != null){
      for(var item in JsonList){
        final crop = Crop.fromJson(item);
        listCrops.add(crop);
      }
    }
    return listCrops;
  }
}