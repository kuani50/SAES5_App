class PpsModel {
  final int id;
  final int userId;
  final DateTime startDate;
  final bool isValid;

  PpsModel({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.isValid,
  });

  factory PpsModel.fromJson(Map<String, dynamic> json) {
    return PpsModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      isValid: (json['is_valid'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String(),
      'is_valid': isValid ? 1 : 0,
    };
  }
}
