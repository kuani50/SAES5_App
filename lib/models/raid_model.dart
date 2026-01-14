import 'course_model.dart';

class RaidModel {
  final int id;
  final String name;
  final int clubId;
  final int addressId;
  final int managerId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationStartDate;
  final DateTime registrationEndDate;
  final String? imageUrl;
  final String? website;
  final List<CourseModel> courses;

  RaidModel({
    required this.id,
    required this.name,
    required this.clubId,
    required this.addressId,
    required this.managerId,
    required this.startDate,
    required this.endDate,
    required this.registrationStartDate,
    required this.registrationEndDate,
    this.imageUrl,
    this.website,
    this.courses = const [],
  });

  factory RaidModel.fromJson(Map<String, dynamic> json) {
    return RaidModel(
      id: json['id'] as int,
      name: json['name'] as String,
      clubId: json['club_id'] as int,
      addressId: json['address_id'] as int,
      managerId: json['manager_id'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      registrationStartDate: DateTime.parse(
        json['registration_start_date'] as String,
      ),
      registrationEndDate: DateTime.parse(
        json['registration_end_date'] as String,
      ),
      imageUrl: json['image_url'] as String?,
      website: json['website'] as String?,
      courses:
          (json['courses'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'club_id': clubId,
      'address_id': addressId,
      'manager_id': managerId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'registration_start_date': registrationStartDate.toIso8601String(),
      'registration_end_date': registrationEndDate.toIso8601String(),
      'image_url': imageUrl,
      'website': website,
      'courses': courses.map((e) => e.toJson()).toList(),
    };
  }
}
