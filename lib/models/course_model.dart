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
  final int? remainingTeams; // Added

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
    return CourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      raidId: json['raid_id'] as int,
      managerId: json['manager_id'] as int,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      gender: json['gender'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      maxParticipants: json['max_participants'] as int,
      maxTeams: json['max_teams'] as int,
      maxPersonsPerTeam: json['max_persons_per_team'] as int,
      minParticipants: json['min_participants'] as int,
      minTeams: json['min_teams'] as int,
      minPrice: (json['min_price'] as num).toDouble(),
      majPrice: (json['maj_price'] as num).toDouble(),
      reducedPrice: (json['reduced_price'] as num).toDouble(),
      mealPrice: json['meal_price'] != null
          ? (json['meal_price'] as num).toDouble()
          : null,
      isChipMandatory: (json['is_chip_mandatory'] as int) == 1,
      minAge: json['min_age'] as int,
      independentAge: json['independent_age'] as int,
      supervisorAge: json['supervisor_age'] as int,
      remainingTeams: json['remaining_teams'] as int?,
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
