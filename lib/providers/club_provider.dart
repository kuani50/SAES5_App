import 'dart:convert';
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
      // Use Dio directly to handle various response formats
      final response = await _apiProvider.dio.get(
        '/api/clubs?with=upcoming,address',
      );
      var responseData = response.data;

      // If response is a String, parse it as JSON
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      List<dynamic> clubsJson;

      if (responseData is List) {
        // Direct array response
        clubsJson = responseData;
      } else if (responseData is Map && responseData.containsKey('data')) {
        // Paginated response with 'data' key
        clubsJson = responseData['data'] as List<dynamic>;
      } else {
        throw Exception(
          'Format de réponse inattendu: ${responseData.runtimeType}',
        );
      }

      _clubs = clubsJson
          .map((json) => ClubModel.fromJson(json as Map<String, dynamic>))
          .toList();
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
