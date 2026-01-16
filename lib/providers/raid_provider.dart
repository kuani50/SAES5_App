import 'dart:convert';
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
      // Use Dio directly to handle various response formats
      final response = await _apiProvider.dio.get(
        '/api/raids?with=club,address',
      );
      var responseData = response.data;

      // If response is a String, parse it as JSON
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      List<dynamic> raidsJson;

      if (responseData is List) {
        // Direct array response
        raidsJson = responseData;
      } else if (responseData is Map && responseData.containsKey('data')) {
        // Paginated response with 'data' key
        raidsJson = responseData['data'] as List<dynamic>;
      } else {
        throw Exception(
          'Format de réponse inattendu: ${responseData.runtimeType}',
        );
      }

      _raids = raidsJson
          .map((json) => RaidModel.fromJson(json as Map<String, dynamic>))
          .toList();
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
