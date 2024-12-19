import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/core/models/tv_show.dart';
import 'package:moviebar/core/services/tmdb_service.dart';

class HomeViewModel extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();
  bool isLoading = true;
  String? _error;

  String? get error => _error;

  Movie? currentMovie;
  List<Movie> _popularMovies = [];
  List<TvShow> _popularTvShows = [];
  List<Movie> _topRatedMovies = [];
  List<TvShow> _topRatedTvShows = [];

  List<Movie> get featuredMovies => _popularMovies;
  List<TvShow> get featuredTvShows => _popularTvShows;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<TvShow> get topRatedTvShows => _topRatedTvShows;

// Kullanım örneği:
  void fetchPopularMovies() async {
    try {
      List<Movie> movies = await _tmdbService.getPopularMovies();
      // movies listesini kullan
      _popularMovies = movies;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      _error = "Filmler yüklenirken bir hata oluştu";
      notifyListeners();
    }
  }

  void fetchPopularTvShows() async {
    try {
      List<TvShow> shows = await _tmdbService.getPopularTvShows();
      _popularTvShows = shows;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      _error = "Filmler yüklenirken bir hata oluştu";
      notifyListeners();
    }
  }

  void fetchTopRatedMovies() async {
    try {
      List<Movie> movies = await _tmdbService.getTopRatedMovies();
      // movies listesini kullan
      _topRatedMovies = movies;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      _error = "Filmler yüklenirken bir hata oluştu";
      notifyListeners();
    }
  }

  void fetchTopRatedTvShows() async {
    try {
      List<TvShow> shows = await _tmdbService.getTopRatedTvShows();
      // movies listesini kullan
      _topRatedTvShows = shows;
      notifyListeners();
      isLoading = false;
    } catch (e) {
      _error = "Filmler yüklenirken bir hata oluştu";
      notifyListeners();
    }
  }
}
