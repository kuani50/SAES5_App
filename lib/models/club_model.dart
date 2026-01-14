class ClubModel {
  final String name;
  final String location;
  final String description;
  final String? logoUrl;

  ClubModel({
    required this.name,
    required this.location,
    required this.description,
    this.logoUrl,
  });
}
