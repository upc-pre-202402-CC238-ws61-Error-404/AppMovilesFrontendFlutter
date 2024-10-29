class Category {
  int categoryId;
  String name;

  Category({required this.categoryId, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
    );
  }
}
