class Pest {
  int id;
  String name;
  String description;
  String solution;

  Pest({required this.id, required this.name, required this.description, required this.solution});

  factory Pest.fromJson(Map<String, dynamic> json){
    return Pest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      solution: json['solution'],
    );
  }
  @override
  String toString() {
    return 'Name: $name';
  }
}
