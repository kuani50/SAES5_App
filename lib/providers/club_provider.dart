import 'package:flutter/material.dart';
import '../models/club_model.dart';
import 'api_provider.dart';

class ClubProvider with ChangeNotifier {
  final ApiProvider _apiProvider;

  List<ClubModel> _clubs = [];
  bool _isLoading = false;
  String? _error;

  List<ClubModel> get clubs => _clubs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ClubProvider(this._apiProvider);

  Future<void> fetchClubs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clubs = await _apiProvider.apiClient.getClubsWithUpcomingEvents();
    } catch (e) {
      debugPrint('Error fetching clubs: $e');
      _error = e.toString();
      _clubs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
