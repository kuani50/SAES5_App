import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/course_model.dart'; // Added import
import '../services/api_service.dart';

class ProjectProvider with ChangeNotifier {
  String _baseUrl = 'https://sae.bananacloud.tech';
  late ApiService _apiService;

  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get baseUrl => _baseUrl;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // Allow injecting ApiService for testing
  ProjectProvider({ApiService? apiService}) {
    _apiService = apiService ?? ApiService(baseUrl: _baseUrl);
  }

  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    // Note: If we are testing, this might overwrite our mock service if we don't handle it.
    // For this simple app, we'll accept that changing the URL resets the service.
    _apiService = ApiService(baseUrl: _baseUrl);

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_base_url', url);

    notifyListeners();
  }

  Future<void> loadSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('api_base_url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _baseUrl = savedUrl;
      _apiService = ApiService(baseUrl: _baseUrl);
      notifyListeners();
    }
  }

  Future<void> fetchProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _apiService.fetchProjects();
    } catch (e) {
      _error = e.toString();
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
