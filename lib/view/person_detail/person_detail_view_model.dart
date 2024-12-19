import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/person/person_detail.dart';
import 'package:moviebar/core/services/tmdb_service.dart';

class PersonDetailViewModel extends ChangeNotifier {
  TMDBService _tmdbService = TMDBService();

  PersonDetail? _personDetail;
  List<PersonCredit> _credits = [];
  List<String> _images = [];
  bool _isLoading = false;
  String? _error;

  PersonDetail? get personDetail => _personDetail;
  List<PersonCredit> get credits => _credits;
  List<String> get images => _images;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPersonDetail(int personId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _personDetail = await _tmdbService.getPersonDetailById(personId);

      _credits = await _tmdbService.getPersonCombinedCredits(personId);

      _images = await _tmdbService.getPersonImages(personId);
    } catch (e) {
      _error = 'Detaylar yüklenirken bir hata oluştu';
      log(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
