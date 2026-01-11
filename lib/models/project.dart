class Project {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Helper to get the full image URL.
  /// [baseUrl] should be the root of the API, e.g., "http://10.0.2.2:8000".
  String? getFullImageUrl(String baseUrl) {
    if (image == null) return null;
    // Assuming the API returns a relative path like "projects/image1.jpg"
    // and the storage is at /storage/
    // We need to handle trailing slashes in baseUrl to avoid double slashes.
    final cleanBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    // If the image path already starts with http, return it as is.
    if (image!.startsWith('http')) return image;

    return '$cleanBaseUrl/storage/$image';
  }
}
