import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../services/api_client.dart';

class ProjectProvider with ChangeNotifier {
  String _baseUrl = 'feat-auth.sae.bananacloud.tech';
  late ApiClient _apiClient;

  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get baseUrl => _baseUrl;

  ProjectProvider({ApiClient? apiClient}) {
    if (apiClient != null) {
      _apiClient = apiClient;
    } else {
      _initClient();
    }
  }

  void _initClient() {
    // Ensure we have a valid URL structure.
    // Assuming baseUrl is just a host, we prepend https://
    final fullUrl = _baseUrl.startsWith('http')
        ? _baseUrl
        : 'https://$_baseUrl';
    final dio = Dio(BaseOptions(baseUrl: fullUrl));
    _apiClient = ApiClient(dio);
  }

  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    _initClient();

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
      _initClient();
      notifyListeners();
    }
  }

  String getBaseUrl() {
    return _baseUrl;
  }

  Future<void> fetchProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _apiClient.getProjects();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
