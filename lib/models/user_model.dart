class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final DateTime? birthDate;
  final String? gender;
  final int? addressId;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.birthDate,
    this.gender,
    this.addressId,
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      gender: json['gender'] as String?,
      addressId: json['address_id'] as int?,
      isAdmin: json['is_admin'] == 1 || json['is_admin'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'address_id': addressId,
      'is_admin': isAdmin ? 1 : 0,
    };
  }
}
