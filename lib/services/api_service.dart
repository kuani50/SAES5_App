import 'package:dio/dio.dart';
import '../models/project.dart';

class ApiService {
  final Dio _dio;
  String baseUrl;

  // Allow injecting Dio for testing
  ApiService({required this.baseUrl, Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Project>> fetchProjects() async {
    try {
      // Ensure no double slashes if user adds one
      final cleanBaseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      final response = await _dio.get('$cleanBaseUrl/api/projects');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}
