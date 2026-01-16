import 'pps_model.dart';

class TeamMemberModel {
  final int teamId;
  final int userId;
  final String? chipNumber;

  // User details (from joined user table)
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? licenseNumber;

  // PPS details
  final PpsModel? pps;
  final String ppsStatus; // validated, pending, none, rejected

  TeamMemberModel({
    required this.teamId,
    required this.userId,
    this.chipNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.licenseNumber,
    this.pps,
    this.ppsStatus = 'none',
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? 'Sans nom';
  }

  bool get isLicensed => licenseNumber != null && licenseNumber!.isNotEmpty;

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    PpsModel? pps;
    if (json['pps'] != null) {
      pps = PpsModel.fromJson(json['pps'] as Map<String, dynamic>);
    }

    // Determine PPS status
    String ppsStatus = 'none';
    if (json['license_number'] != null &&
        (json['license_number'] as String).isNotEmpty) {
      ppsStatus = 'licensed'; // Has license, no PPS needed
    } else if (pps != null) {
      ppsStatus = pps.isValid ? 'validated' : 'pending';
    } else if (json['pps_status'] != null) {
      ppsStatus = json['pps_status'] as String;
    }

    return TeamMemberModel(
      teamId: _parseInt(json['team_id']),
      userId: _parseInt(json['user_id']),
      chipNumber: json['chip_number']?.toString(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      licenseNumber: json['license_number'] as String?,
      pps: pps,
      ppsStatus: ppsStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'user_id': userId,
      'chip_number': chipNumber,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'license_number': licenseNumber,
      'pps': pps?.toJson(),
      'pps_status': ppsStatus,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
