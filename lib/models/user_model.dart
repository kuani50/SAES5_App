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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String,
      addressId: json['address_id'] as int,
      isAdmin: (json['is_admin'] as int) == 1,
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] == null
          ? null
          : DateTime.parse(json['two_factor_confirmed_at'] as String),
      twoFactorRecoveryCodes: json['two_factor_recovery_codes'] as String?,
      twoFactorSecret: json['two_factor_secret'] as String?,
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
    };
  }
}
