class CropRequest {
  String name;
  String imageUrl;
  String description;
  List<int> diseases;
  List<int> pests;
  List<int> cares;

  CropRequest({required this.name, required this.imageUrl, required this.description, required this.diseases, required this.pests, required this.cares});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'diseases': diseases,
      'pests': pests,
      'cares': cares,
    };
  }
}
