class AddressModel {
  final int id;
  final String? address;
  final String? postalCode;
  final String? city;
  final String? country;
  final String? complementAddress;

  AddressModel({
    required this.id,
    this.address,
    this.postalCode,
    this.city,
    this.country,
    this.complementAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      complementAddress: json['complement_address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'postal_code': postalCode,
      'city': city,
      'country': country,
      'complement_address': complementAddress,
    };
  }
}
