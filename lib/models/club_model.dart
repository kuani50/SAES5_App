class ClubModel {
  final int id;
  final String name;
  final int addressId;
  final int managerId;
  final String? logoUrl;

  ClubModel({
    required this.id,
    required this.name,
    required this.addressId,
    required this.managerId,
    this.logoUrl,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as int,
      name: json['name'] as String,
      addressId: json['address_id'] as int,
      managerId: json['manager_id'] as int,
      logoUrl: json['logo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_id': addressId,
      'manager_id': managerId,
      'logo_url': logoUrl,
    };
  }
}
