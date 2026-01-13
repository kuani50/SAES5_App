import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/device_info_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password, String host) async {
    final uri = Uri(scheme: 'https', host: host, path: 'api/mobile/login');

    final deviceName = await DeviceInfoService.getDeviceName();

    final response = await http.post(
      uri,
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_name': deviceName,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
    }

    return _isAuthenticated;
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
    final uri = Uri(scheme: 'https', host: host, path: 'api/mobile/register');

    final deviceName = await DeviceInfoService.getDeviceName();

    final response = await http.post(
      uri,
      body: jsonEncode({
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
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
    }

    return _isAuthenticated;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
