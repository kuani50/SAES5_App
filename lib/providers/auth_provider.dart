import 'package:flutter/foundation.dart';
import '../services/device_info_service.dart';
import 'api_provider.dart';

class AuthProvider extends ChangeNotifier {
  final ApiProvider _apiProvider;

  // We derive authentication state from the ApiProvider's token existence
  bool get isAuthenticated => _apiProvider.hasToken;

  AuthProvider(this._apiProvider);

  Future<bool> login(String email, String password) async {
    try {
      final deviceName = await DeviceInfoService.getDeviceName();

      final response = await _apiProvider.apiClient.login({
        'email': email,
        'password': password,
        'device_name': deviceName,
      });

      final token = response;

      await _apiProvider.setToken(token);
      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
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

      final token = await _apiProvider.apiClient.register({
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

      await _apiProvider.setToken(token);
      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _apiProvider.clearToken();
    notifyListeners();
  }
}
