// lib/viewmodels/movie_detail_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie_detail.dart';
import 'package:moviebar/core/services/tmdb_service.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();

  MovieDetail? _movieDetail;
  bool _isLoading = false;
  String? _error;

  MovieDetail? get movieDetail => _movieDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMovieDetail(int movieId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _movieDetail = await _tmdbService.getMovieById(movieId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _movieDetail = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
