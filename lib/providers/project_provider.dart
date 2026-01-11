import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../services/api_service.dart';

class ProjectProvider with ChangeNotifier {
  String _baseUrl = 'https://sae.bananacloud.tech';
  late ApiService _apiService;
  
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get baseUrl => _baseUrl;

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
}
