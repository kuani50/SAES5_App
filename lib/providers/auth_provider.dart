import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/device_info_service.dart';
import 'api_provider.dart';

class AuthProvider extends ChangeNotifier {
  final ApiProvider _apiProvider;
  UserModel? _currentUser;
  bool _isRaceManager = false;

  bool get isAuthenticated => _apiProvider.hasToken;
  UserModel? get currentUser => _currentUser;
  bool get isRaceManager => _isRaceManager;
  String get userDisplayName => _currentUser != null
      ? "${_currentUser!.firstName} ${_currentUser!.lastName}"
      : "";

  AuthProvider(this._apiProvider) {
    // Start logged out - don't auto-load from prefs
    _clearSession();
  }

  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      await _apiProvider.clearToken();
      _currentUser = null;
      _isRaceManager = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from prefs: $e');
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error saving user to prefs: $e');
    }
  }

  /// Returns null on success, or an error message string on failure
  Future<String?> login(String email, String password) async {
    try {
      final deviceName = await DeviceInfoService.getDeviceName();

      var responseData = await _apiProvider.apiClient.login({
        'email': email,
        'password': password,
        'device_name': deviceName,
      });

      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (_) {}
      }

      String token;
      if (responseData is Map) {
        // Check for error in response
        if (responseData.containsKey('message') &&
            !responseData.containsKey('token')) {
          return responseData['message']?.toString() ?? 'Erreur inconnue';
        }

        token = responseData['token']?.toString() ?? responseData.toString();

        // If user data is included in response
        if (responseData.containsKey('user')) {
          _currentUser = UserModel.fromJson(responseData['user']);
          await _saveUserToPrefs(_currentUser!);
        }
      } else {
        token = responseData.toString();
      }

      await _apiProvider.setToken(token);

      // Fetch user data if not included in login response
      if (_currentUser == null) {
        await fetchCurrentUser();
      }

      notifyListeners();
      return null; // Success
    } on DioException catch (e) {
      debugPrint('Login DioException: ${e.response?.data}');
      // Extract error message from API response
      final responseData = e.response?.data;
      if (responseData is Map && responseData.containsKey('message')) {
        return responseData['message']?.toString() ?? 'Erreur de connexion';
      }
      if (responseData is String) {
        try {
          final decoded = jsonDecode(responseData);
          if (decoded is Map && decoded.containsKey('message')) {
            return decoded['message']?.toString() ?? 'Erreur de connexion';
          }
        } catch (_) {}
      }
      return 'Erreur de connexion: ${e.message}';
    } catch (e) {
      debugPrint('Login error: $e');
      return 'Erreur: $e';
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      debugPrint('Fetching current user from /api/user...');
      var responseData = await _apiProvider.apiClient.getCurrentUser();

      debugPrint('User API response type: ${responseData.runtimeType}');
      debugPrint('User API response: $responseData');

      // Handle the response - it could be a Map or need decoding
      Map<String, dynamic>? userData;
      if (responseData is Map<String, dynamic>) {
        userData = responseData;
      } else if (responseData is String && responseData.isNotEmpty) {
        try {
          userData = jsonDecode(responseData) as Map<String, dynamic>;
        } catch (_) {}
      }

      if (userData != null && userData.isNotEmpty) {
        _currentUser = UserModel.fromJson(userData);
        debugPrint(
          'User loaded: ${_currentUser?.firstName} ${_currentUser?.lastName}',
        );
        await _saveUserToPrefs(_currentUser!);
        notifyListeners();
      }

      // Check if user manages any races
      await checkRaceManagerStatus();
    } catch (e) {
      debugPrint('Error fetching current user: $e');
    }
  }

  /// Check if the authenticated user manages any races
  Future<void> checkRaceManagerStatus() async {
    try {
      final response = await _apiProvider.apiClient.getManagedRaces();

      var racesList = <dynamic>[];
      if (response is List) {
        racesList = response;
      } else if (response is Map && response.containsKey('data')) {
        racesList = response['data'] as List<dynamic>;
      }

      _isRaceManager = racesList.isNotEmpty;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking race manager status: $e');
      _isRaceManager = false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gender,
    String phone,
    String birthDate,
    String address,
    String postalCode,
    String city,
    String country,
    String complementAddress,
  ) async {
    try {
      final deviceName = await DeviceInfoService.getDeviceName();

      var responseData = await _apiProvider.apiClient.register({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'phone': phone,
        'birth_date': birthDate,
        'address': address,
        'postal_code': postalCode,
        'city': city,
        'country': country,
        'complement_address': complementAddress,
        'device_name': deviceName,
      });

      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (_) {}
      }

      String token;
      if (responseData is Map) {
        token = responseData['token']?.toString() ?? responseData.toString();

        if (responseData.containsKey('user')) {
          _currentUser = UserModel.fromJson(responseData['user']);
          await _saveUserToPrefs(_currentUser!);
        }
      } else {
        token = responseData.toString();
      }

      await _apiProvider.setToken(token);

      if (_currentUser == null) {
        await fetchCurrentUser();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _apiProvider.clearToken();
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');

    notifyListeners();
  }
}
