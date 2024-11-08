class Care {
  int id;
  String suggestion;
  String date;

  Care({required this.id, required this.suggestion, required this.date});

  factory Care.fromJson(Map<String, dynamic> json) {
    return Care(
      id: json['id'],
      suggestion: json['suggestion'],
      date: json['date'],
    );
  }

  @override
  String toString() {
    return 'Suggestion: $suggestion';
  }
}