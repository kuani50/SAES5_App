import 'package:flutter/material.dart';
import '../models/raid_model.dart';
import 'api_provider.dart';

class RaidProvider with ChangeNotifier {
  final ApiProvider _apiProvider;

  List<RaidModel> _raids = [];
  bool _isLoading = false;
  String? _error;

  List<RaidModel> get raids => _raids;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RaidProvider(this._apiProvider);

  Future<void> fetchRaids() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _raids = await _apiProvider.apiClient.getRaids();
    } catch (e) {
      debugPrint('Error fetching raids: $e');
      _error = e.toString();
      _raids = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
