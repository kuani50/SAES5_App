import 'course_model.dart';

class EventModel {
  final String title;
  final String clubName;
  final String location;
  final String date;
  final String status; // État de l'inscription (Ouverte, Complet, etc.)
  final String raidState; // État du raid (À venir, En cours, Terminé)
  final String? imageUrl;
  final List<CourseModel> courses;

  EventModel({
    required this.title,
    required this.clubName,
    required this.location,
    required this.date,
    this.status = "Inscription ouverte",
    this.raidState = "Raid à venir",
    this.imageUrl,
    this.courses = const [],
  });
}
