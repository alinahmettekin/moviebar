// lib/viewmodels/search_viewmodel.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/search_result.dart';

import 'package:moviebar/core/services/tmdb_service.dart';

class SearchViewModel extends ChangeNotifier {
  final TMDBService _tmdbService = TMDBService();

  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String _lastQuery = '';
  String _searchQuery = '';
  String? _error;
  bool _isFirstSearch = true;
  Timer? _debounceTimer;
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  // Getters
  List<SearchResult> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;
  bool get isFirstSearch => _isFirstSearch;
  bool get hasNextPage => _hasNextPage;
  bool get isLoadingMore => _isLoadingMore;

  void search(String query) {
    _debounceTimer?.cancel();

    _searchQuery = query;

    if (query.isEmpty) {
      clearSearch();
      return;
    }

    if (query.length < 2) return;
    if (query == _lastQuery) return;

    // Yeni arama için değerleri sıfırla
    _currentPage = 1; // Sayfa numarasını sıfırla
    _hasNextPage = true; // Pagination'ı resetle
    _lastQuery = query;
    _isFirstSearch = true;
    _searchResults = []; // Önceki sonuçları temizle

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _tmdbService.getMultiSearchResponse(query, _currentPage);

      if (response.error == null) {
        _hasNextPage = _currentPage < response.totalPages;

        if (_currentPage == 1) {
          _searchResults = response.results;
        } else {
          _searchResults.addAll(response.results);
        }
      } else {
        _error = response.error;
        if (_currentPage == 1) _searchResults = [];
      }
    } catch (e) {
      _error = 'Arama yapılırken bir hata oluştu';
      if (_currentPage == 1) _searchResults = [];
    } finally {
      _isLoading = false;
      _isFirstSearch = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasNextPage || _searchQuery.isEmpty) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      _currentPage++;
      await _performSearch(_searchQuery);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    _lastQuery = '';
    _searchQuery = '';
    _error = null;
    _isFirstSearch = true;
    _currentPage = 1;
    _hasNextPage = true;
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
