import 'package:intl/intl.dart';

class CareRequest {
  String suggestion;
  String date;

  CareRequest({required this.suggestion}) : date = _generateCurrentDate();

  static String _generateCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'");
    return formatter.format(now);
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestion': suggestion,
      'date': date,
    };
  }
}