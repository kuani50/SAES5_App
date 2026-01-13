import 'course_model.dart';

class EventModel {
  final String title;
  final String clubName;
  final String location;
  final String date;
  final String status;
  final String? imageUrl;
  final List<CourseModel> courses; // Ajout de la liste des courses

  EventModel({
    required this.title,
    required this.clubName,
    required this.location,
    required this.date,
    this.status = "Inscriptions ouvertes",
    this.imageUrl,
    this.courses = const [], // Par défaut, liste vide
  });
}
