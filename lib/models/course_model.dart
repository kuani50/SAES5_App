class CourseModel {
  final int id;
  final String name;
  final int raidId;
  final int managerId;
  final String type;
  final String difficulty;
  final String gender;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final int maxTeams;
  final int maxPersonsPerTeam;
  final int minParticipants;
  final int minTeams;
  final double minPrice;
  final double majPrice;
  final double reducedPrice;
  final double? mealPrice;
  final bool isChipMandatory;
  final int minAge;
  final int independentAge;
  final int supervisorAge;
  final int? remainingTeams;

  CourseModel({
    required this.id,
    required this.name,
    required this.raidId,
    required this.managerId,
    required this.type,
    required this.difficulty,
    required this.gender,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.maxTeams,
    required this.maxPersonsPerTeam,
    required this.minParticipants,
    required this.minTeams,
    required this.minPrice,
    required this.majPrice,
    required this.reducedPrice,
    this.mealPrice,
    required this.isChipMandatory,
    required this.minAge,
    required this.independentAge,
    required this.supervisorAge,
    this.remainingTeams,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse numbers that may come as String or num
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return CourseModel(
      id: parseInt(json['id']),
      name: json['name'] as String,
      raidId: parseInt(json['raid_id']),
      managerId: parseInt(json['manager_id']),
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      gender: json['gender'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      maxParticipants: parseInt(json['max_participants']),
      maxTeams: parseInt(json['max_teams']),
      maxPersonsPerTeam: parseInt(json['max_persons_per_team']),
      minParticipants: parseInt(json['min_participants']),
      minTeams: parseInt(json['min_teams']),
      minPrice: parseDouble(json['min_price']),
      majPrice: parseDouble(json['maj_price']),
      reducedPrice: parseDouble(json['reduced_price']),
      mealPrice: json['meal_price'] != null
          ? parseDouble(json['meal_price'])
          : null,
      isChipMandatory:
          json['is_chip_mandatory'] == true || json['is_chip_mandatory'] == 1,
      minAge: parseInt(json['min_age']),
      independentAge: parseInt(json['independent_age']),
      supervisorAge: parseInt(json['supervisor_age']),
      remainingTeams: json['remaining_teams'] != null
          ? parseInt(json['remaining_teams'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'raid_id': raidId,
      'manager_id': managerId,
      'type': type,
      'difficulty': difficulty,
      'gender': gender,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'max_participants': maxParticipants,
      'max_teams': maxTeams,
      'max_persons_per_team': maxPersonsPerTeam,
      'min_participants': minParticipants,
      'min_teams': minTeams,
      'min_price': minPrice,
      'maj_price': majPrice,
      'reduced_price': reducedPrice,
      'meal_price': mealPrice,
      'is_chip_mandatory': isChipMandatory ? 1 : 0,
      'min_age': minAge,
      'independent_age': independentAge,
      'supervisor_age': supervisorAge,
      'remaining_teams': remainingTeams,
    };
  }
}
