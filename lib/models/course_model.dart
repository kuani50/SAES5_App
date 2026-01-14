class CourseModel {
  final String name;
  final String distance;
  final String teamSize;
  final String difficulty;
  final bool isRegistrationOpen;
  final int? remainingTeams;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? priceJunior;
  final double? priceAdult;
  final double? priceReduced;
  final double? priceMeal;
  final int? minAge;
  final int? autonomousAge;
  final int? supervisorAge;
  final bool? chipRequired;
  final String? organizer;
  final String? category;
  final int? maxTeams;

  CourseModel({
    required this.name,
    required this.distance,
    required this.teamSize,
    required this.difficulty,
    this.isRegistrationOpen = true,
    this.remainingTeams,
    this.startDate,
    this.endDate,
    this.priceJunior,
    this.priceAdult,
    this.priceReduced,
    this.priceMeal,
    this.minAge,
    this.autonomousAge,
    this.supervisorAge,
    this.chipRequired,
    this.organizer,
    this.category,
    this.maxTeams,
  });
}
