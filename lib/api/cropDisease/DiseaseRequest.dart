class DiseaseRequest {
  String name;
  String description;
  String solution;

  DiseaseRequest({required this.name, required this.description, required this.solution});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'solution': solution,
    };
  }
}
