import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Varsayılan değerler
  String _language = 'en-US';
  // static String region = 'TR';
  bool _includeAdult = true;

  // API istekleri için ortak parametreler
  Map<String, dynamic> get defaultParams => {
        'language': _language,
        // 'region': region,
        'include_adult': _includeAdult,
      };

  // Ayarları güncelleme
  void updateSettings({String? newLanguage, String? newRegion, bool? newIncludeAdult}) {
    _language = newLanguage ?? _language;
    // region = newRegion ?? region;
    _includeAdult = newIncludeAdult ?? _includeAdult;
    notifyListeners();
  }
}
