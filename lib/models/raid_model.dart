import 'course_model.dart';

class RaidModel {
  final String title;
  final String clubName;
  final String location;
  final String date;
  final String status;
  final String raidState;
  final String? imageUrl;
  final List<CourseModel> courses;

  RaidModel({
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
