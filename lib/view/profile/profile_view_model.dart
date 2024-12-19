import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/core/models/tv_show.dart';
import 'package:moviebar/core/models/user/user_profile.dart';
import 'package:moviebar/core/models/watch_list.dart';
import 'package:moviebar/core/providers/auth_provider.dart';
import 'package:moviebar/view/widgets/list_selection_sheet.dart';
import 'package:provider/provider.dart';

// lib/viewmodels/profile_viewmodel.dart
class ProfileViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.themoviedb.org/3";
  late final AuthProvider _authProvider;

  bool _isLoading = false;
  String? _error;
  UserProfile? _userProfile;
  List<WatchList>? _watchLists;
  List<Movie> _favoriteMovies = [];
  List<TvShow> _favoriteTVShows = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserProfile? get userProfile => _userProfile;
  List<WatchList>? get watchLists => _watchLists;
  List<Movie> get favoriteMovies => _favoriteMovies;
  List<TvShow> get favoriteTVShows => _favoriteTVShows;

  void setContext(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _dio.options.headers['Authorization'] = 'Bearer ${_authProvider.sessionToken}';
  }

  Future<void> init() async {
    if (!_authProvider.isAuthenticated) {
      _error = 'Oturum açılmamış';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _fetchUserProfile(),
        _fetchUserLists(),
        _fetchFavoriteMovies(),
        _fetchFavoriteTVShows(),
      ]);
    } catch (e) {
      _error = 'Profil bilgileri yüklenemedi';
      log('ProfileViewModel Error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToList(int listId, {required int mediaId, required String mediaType}) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/list/$listId/add_item',
        data: {
          'media_id': mediaId,
          'media_type': mediaType, // 'movie' veya 'tv'
        },
      );

      if (response.statusCode == 201) {
        await _fetchUserLists();
      } else {
        throw Exception('Failed to add item to list');
      }
    } catch (e) {
      log('Add to List Error: ${e.toString()}');
      rethrow;
    }
  }

  void showListSelectionDialog(
    BuildContext context, {
    required int mediaId,
    required String mediaType,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ListSelectionSheet(
        lists: _watchLists ?? [],
        onListSelected: (listId) async {
          Navigator.pop(context);
          try {
            await addToList(
              listId,
              mediaId: mediaId,
              mediaType: mediaType,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listeye eklendi'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Listeye eklenemedi: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _fetchFavoriteMovies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/account/${_authProvider.accountId}/favorite/movies',
        queryParameters: {
          'language': 'tr-TR',
          'sort_by': 'created_at.desc',
          'page': 1,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        _favoriteMovies = results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite movies');
      }
    } catch (e) {
      log('Fetch Favorite Movies Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _fetchFavoriteTVShows() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/account/${_authProvider.accountId}/favorite/tv',
        queryParameters: {
          'language': 'tr-TR',
          'sort_by': 'created_at.desc',
          'page': 1,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        _favoriteTVShows = results.map((json) => TvShow.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite TV shows');
      }
    } catch (e) {
      log('Fetch Favorite TV Shows Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/account/${_authProvider.accountId}',
      );

      if (response.statusCode == 200) {
        _userProfile = UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      log('Fetch Profile Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _fetchUserLists() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/account/${_authProvider.accountId}/lists',
      );

      if (response.statusCode == 200) {
        _watchLists = (response.data['results'] as List).map((json) => WatchList.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load lists');
      }
    } catch (e) {
      log('Fetch Lists Error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> refreshProfile() async {
    await init();
  }

  Future<void> logout() async {
    await _authProvider.logout();
  }
}
