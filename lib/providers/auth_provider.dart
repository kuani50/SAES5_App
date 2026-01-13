import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';
import '../services/device_info_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password, String host) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://$host'));
    final client = ApiClient(dio);

    try {
      final deviceName = await DeviceInfoService.getDeviceName();
      final token = await client.login({
        'email': email,
        'password': password,
        'device_name': deviceName,
      });

      await saveToken(token);
      _isAuthenticated = true;
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
    String host,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://$host'));
    final client = ApiClient(dio);

    try {
      final deviceName = await DeviceInfoService.getDeviceName();
      final token = await client.register({
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

      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
