import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviebar/core/services/tmdb_service.dart';
import 'package:moviebar/core/utils/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();

  String? _sessionToken;
  String? _accountId;
  bool _isAuthenticated = false;

  String? get sessionToken => _sessionToken;
  String? get accountId => _accountId;
  bool get isAuthenticated => _isAuthenticated;

  Future<String> createRequestToken() async {
    return await _tmdbService.createRequestToken();
  }

  Future<void> authenticate(String requestToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Access token ile session oluştur
      final sessionResponse = await _tmdbService.createAccessToken(requestToken);
      log(sessionResponse.keys.toString());
      _accountId = sessionResponse['account_id'];
      _sessionToken = sessionResponse['access_token'];
      _isAuthenticated = true;

      // Token'ları kaydet
      await prefs.setString(StorageKeys.sessionToken, _sessionToken!);
      await prefs.setString(StorageKeys.accountId, _accountId!);

      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionToken = prefs.getString(StorageKeys.sessionToken);
    _accountId = prefs.getString(StorageKeys.accountId);
    _isAuthenticated = _sessionToken != null && _accountId != null;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.sessionToken);
    await prefs.remove(StorageKeys.accountId);
    _sessionToken = null;
    _accountId = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
