class CourseModel {
  final String name;
  final String distance;
  final String teamSize;
  final String difficulty;
  final bool isRegistrationOpen;
  final int? remainingTeams;

  CourseModel({
    required this.name,
    required this.distance,
    required this.teamSize,
    required this.difficulty,
    this.isRegistrationOpen = true,
    this.remainingTeams,
  });
}
