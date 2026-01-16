import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/course_model.dart';
import 'api_provider.dart';

class ProjectProvider with ChangeNotifier {
  final ApiProvider _apiProvider;

  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get baseUrl => _apiProvider.baseUrl;

  ProjectProvider(this._apiProvider);

  Future<void> fetchProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _apiProvider.apiClient.getProjects();
    } catch (e) {
      _projects = [];
      // _error = e.toString();
      debugPrint("Error fetching projects: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mock registration method
  Future<void> registerForCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // For now, we simulate success.
    // In a real app, calls ApiService.register(...)

    _isLoading = false;
    notifyListeners();
  }
}
