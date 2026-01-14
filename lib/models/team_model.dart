class TeamModel {
  final int id;
  final String name;
  final int managerId;
  final int raceId;
  final String? imageUrl;
  final int points;
  final int ranking;
  final bool hasPaid;
  final bool hasValidated;

  TeamModel({
    required this.id,
    required this.name,
    required this.managerId,
    required this.raceId,
    this.imageUrl,
    required this.points,
    required this.ranking,
    required this.hasPaid,
    required this.hasValidated,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as int,
      name: json['name'] as String,
      managerId: json['manager_id'] as int,
      raceId: json['race_id'] as int,
      imageUrl: json['image_url'] as String?,
      points: json['points'] as int,
      ranking: json['ranking'] as int,
      hasPaid: (json['has_paid'] as int) == 1,
      hasValidated: (json['has_validated'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manager_id': managerId,
      'race_id': raceId,
      'image_url': imageUrl,
      'points': points,
      'ranking': ranking,
      'has_paid': hasPaid ? 1 : 0,
      'has_validated': hasValidated ? 1 : 0,
    };
  }
}
