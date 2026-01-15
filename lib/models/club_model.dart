import 'raid_model.dart';

class ClubModel {
  final int id;
  final String name;
  final int? addressId;
  final int? managerId;
  final String? logoUrl;
  final List<RaidModel>? raids; // New field

  ClubModel({
    required this.id,
    required this.name,
    this.addressId,
    this.managerId,
    this.logoUrl,
    this.raids, // New parameter
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as int,
      name: json['name'] as String,
      addressId: json['address_id'] as int?,
      managerId: json['manager_id'] as int?,
      logoUrl: json['logo_url'] as String?,
      raids: json['raids'] is List
          ? (json['raids'] as List<dynamic>)
                .map((e) => RaidModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
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
