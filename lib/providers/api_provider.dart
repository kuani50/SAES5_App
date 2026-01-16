import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_client.dart';

class ApiProvider with ChangeNotifier {
  String _baseUrl = 'main.sae.bananacloud.tech';
  late Dio _dio;
  late ApiClient _apiClient;
  String? _token;

  String get baseUrl => _baseUrl;
  ApiClient get apiClient => _apiClient;
  Dio get dio => _dio;
  bool get hasToken => _token != null;

  ApiProvider() {
    _initClient();
    _loadPersistedData();
  }

  void _initClient() {
    final fullUrl = _baseUrl.startsWith('http')
        ? _baseUrl
        : 'https://$_baseUrl';

    _dio = Dio(
      BaseOptions(
        baseUrl: fullUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add Logging Interceptor (for debugging)
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );

    // Add Token Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );

    _apiClient = ApiClient(_dio);
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load URL
    final savedUrl = prefs.getString('api_base_url');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      _baseUrl = savedUrl;
    }

    // Load Token
    final savedToken = prefs.getString('auth_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
    }

    // Re-init client with new data
    _initClient();
    notifyListeners();
  }

  Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    _initClient();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_base_url', url);

    notifyListeners();
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
