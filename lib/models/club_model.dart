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
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int? tryParseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return ClubModel(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? 'Non défini',
      addressId: tryParseInt(json['address_id']),
      managerId: tryParseInt(json['manager_id']),
      logoUrl: json['logo_url']?.toString(),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClubModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
