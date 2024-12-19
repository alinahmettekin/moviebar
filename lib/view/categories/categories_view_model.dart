// categories_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/core/models/movie/movie_detail.dart';
import 'package:moviebar/core/services/tmdb_service.dart';

class CategoriesViewModel extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();

  String collection = "movie";
  List<Movie> _movies = [];
  List<Genre> _genres = [];
  List<int> _selectedGenreIds = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Movie> get movies => _movies;
  List<Genre> get genres => _genres;
  List<int> get selectedGenreIds => _selectedGenreIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    await fetchGenres(collection);
    await fetchMovies();
  }

  Future<void> fetchGenres(String collection) async {
    try {
      _genres = await _tmdbService.getGenres(collection);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchMovies() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final queryParameters = {
        'sort_by': 'popularity.desc',
      };

      if (_selectedGenreIds.isNotEmpty) {
        queryParameters['with_genres'] = _selectedGenreIds.join(',');
      }

      _movies = await _tmdbService.getDiscoverMovies(queryParameters);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Yeni seçilen filtreleri uygula
  void applyFilters(List<int> selectedIds) {
    _selectedGenreIds = selectedIds;
    fetchMovies();
  }

  // Tek bir genre'yi toggle et
  void toggleGenre(int genreId) {
    if (_selectedGenreIds.contains(genreId)) {
      _selectedGenreIds.remove(genreId);
    } else {
      _selectedGenreIds.add(genreId);
    }
    fetchMovies();
  }

  // Tüm filtreleri temizle
  void clearFilters() {
    _selectedGenreIds.clear();
    fetchMovies();
  }
}
