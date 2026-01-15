class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final DateTime birthDate;
  final String gender;
  final int addressId;
  final bool isAdmin;
  final DateTime? twoFactorConfirmedAt;
  final String? twoFactorRecoveryCodes;
  final String? twoFactorSecret;
  final String? licenseNumber;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.addressId,
    required this.isAdmin,
    this.twoFactorConfirmedAt,
    this.twoFactorRecoveryCodes,
    this.twoFactorSecret,
    this.licenseNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return false;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      id: parseInt(json['id']),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      birthDate: parseDate(json['birth_date']),
      gender: json['gender']?.toString() ?? 'M',
      addressId: parseInt(json['address_id']),
      isAdmin: parseBool(json['is_admin']),
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] == null
          ? null
          : parseDate(json['two_factor_confirmed_at']),
      twoFactorRecoveryCodes: json['two_factor_recovery_codes']?.toString(),
      twoFactorSecret: json['two_factor_secret']?.toString(),
      licenseNumber: json['license_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'address_id': addressId,
      'is_admin': isAdmin ? 1 : 0,
      'two_factor_confirmed_at': twoFactorConfirmedAt?.toIso8601String(),
      'two_factor_recovery_codes': twoFactorRecoveryCodes,
      'two_factor_secret': twoFactorSecret,
      'license_number': licenseNumber,
    };
  }
}
