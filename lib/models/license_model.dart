class LicenseModel {
  final int userId;
  final int clubId;
  final String licenseNumber;
  final bool isVerified;

  LicenseModel({
    required this.userId,
    required this.clubId,
    required this.licenseNumber,
    required this.isVerified,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      userId: json['user_id'] as int,
      clubId: json['club_id'] as int,
      licenseNumber: json['license_number'] as String,
      isVerified: (json['is_verified'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'club_id': clubId,
      'license_number': licenseNumber,
      'is_verified': isVerified ? 1 : 0,
    };
  }
}
