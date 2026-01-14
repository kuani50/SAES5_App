class CourseModel {
  final String name; // Ex: Parcours Aventure
  final String distance; // Ex: 45km
  final String teamSize; // Ex: Équipe de 2 à 4
  final String difficulty; // Ex: Expert
  final bool isRegistrationOpen;

  CourseModel({
    required this.name,
    required this.distance,
    required this.teamSize,
    required this.difficulty,
    this.isRegistrationOpen = true,
  });
}
