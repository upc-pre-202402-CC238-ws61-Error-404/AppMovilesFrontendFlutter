import 'package:appmovilesfrontendflutter/api/category/Category.dart';

class CategoryList {
  static List<Category> listCategory(List<dynamic> JsonList) {
    List<Category> listCategories = [];
    if (JsonList != null) {
      for (var item in JsonList) {
        final category = Category.fromJson(item);
        listCategories.add(category);
      }
    }
    return listCategories;
  }
}