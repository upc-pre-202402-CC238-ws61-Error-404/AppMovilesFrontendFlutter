class Disease {
  int id;
  String name;
  String description;
  String solution;

  Disease({required this.id, required this.name, required this.description, required this.solution});

  factory Disease.fromJson(Map<String, dynamic> json){
    return Disease(
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
