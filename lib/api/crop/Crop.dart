class Crop {
  int id;
  String name;
  String imageUrl;
  String description;
  List<int> diseases;
  List<int> pests;
  List<int> cares;

  Crop({required this.id, required this.name, required this.imageUrl, required this.description, required this.diseases, required this.pests, required this.cares});

  factory Crop.fromJson(Map<String, dynamic> json){
    return Crop(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      diseases: json['diseases'],
      pests: json['pests'],
      cares: json['cares'],
    );
  }
}
