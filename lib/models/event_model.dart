import 'course_model.dart';

class EventModel {
  final String title;
  final String clubName;
  final String location;
  final String date;
  final String status; // Registration status (Open, Full, etc.)
  final String raidState; // Raid status (Coming, Ongoing, Finished)
  final int? remainingTeams;
  final String? imageUrl;
  final List<CourseModel> courses;

  EventModel({
    required this.title,
    required this.clubName,
    required this.location,
    required this.date,
    this.status = "Inscription ouverte",
    this.raidState = "Raid à venir",
    this.remainingTeams,
    this.imageUrl,
    this.courses = const [],
  });
}
