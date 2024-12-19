// lib/viewmodels/movie_detail_viewmodel.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/tv/tv_show_detial.dart';
import 'package:moviebar/core/services/tmdb_service.dart';

class TvShowDetailViewModel extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();

  TvShowDetail? _tvShowDetail;
  bool _isLoading = false;
  String? _error;

  TvShowDetail? get tvShowDetail => _tvShowDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTvShowDetail(int movieId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _tvShowDetail = await _tmdbService.getTvShowById(movieId);
    } catch (e) {
      _error = e.toString();
      log(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
