import 'package:flutter/material.dart';
import '../models/project.dart';
import 'api_provider.dart';

class ProjectProvider with ChangeNotifier {
  final ApiProvider _apiProvider;

  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

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
      // On utilise l'apiClient fourni par ApiProvider
      _projects = await _apiProvider.apiClient.getProjects();
    } catch (e) {
      _projects = [];
      // _error = e.toString();
      print("Error fetching projects: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
