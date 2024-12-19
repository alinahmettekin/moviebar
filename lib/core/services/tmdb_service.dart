import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviebar/core/models/base_response.dart';
import 'package:moviebar/core/models/genres.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/core/models/movie/movie_detail.dart';
import 'package:moviebar/core/models/person/person_detail.dart';
import 'package:moviebar/core/models/search_response.dart';
import 'package:moviebar/core/models/search_result.dart';
import 'package:moviebar/core/models/tv/tv_show_detial.dart';
import 'package:moviebar/core/models/tv_show.dart';
import 'package:moviebar/core/providers/app_provider.dart';
import 'package:moviebar/core/services/base_api_service.dart';
import 'package:moviebar/core/utils/api_constants.dart';

class TMDBService implements BaseApiService {
  final AppProvider _appProvider = AppProvider();
  final Dio dio = Dio();

  final String _accessToken = dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  final String _baseUrl = "https://api.themoviedb.org/3";

  String get apiReadToken => _accessToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      };

  Map<String, dynamic> get _defaultParams => _appProvider.defaultParams;

  @override
  Future<String> createRequestToken() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/request_token'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['request_token'];
    } else {
      throw Exception('Failed to create request token');
    }
  }

  @override
  Future<Map<String, dynamic>> createAccessToken(String requestToken) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/access_token'),
      headers: _headers,
      body: jsonEncode({
        'request_token': requestToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to create access token');
    }
  }

  @override
  Future<Map<String, dynamic>> createSession(String accessToken) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/auth/session'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'access_token': accessToken,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create session');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/account'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  String getAuthUrl(String requestToken) {
    return '${ApiConstants.authBaseUrl}/auth/access?request_token=$requestToken';
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/discover/movie',
        queryParameters: queryParameters,
      );
      final baseResponse = BaseResponse<Movie>.fromJson(
        response.data,
        (json) => Movie.fromJson(json),
      );
      return baseResponse.results as List<Movie>;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<TvShow>> getPopularTvShows() async {
    try {
      final response = await dio.get(
        '$_baseUrl/discover/tv',
        queryParameters: {
          "api_key": _apiKey,
        },
      );
      final baseResponse = BaseResponse<TvShow>.fromJson(
        response.data,
        (json) => TvShow.fromJson(json),
      );
      return baseResponse.results as List<TvShow>;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/movie/top_rated',
        queryParameters: queryParameters,
      );
      final baseResponse = BaseResponse<Movie>.fromJson(
        response.data,
        (json) => Movie.fromJson(json),
      );
      return baseResponse.results as List<Movie>;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<TvShow>> getTopRatedTvShows() async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/tv/top_rated',
        queryParameters: queryParameters,
      );
      final baseResponse = BaseResponse<TvShow>.fromJson(
        response.data,
        (json) => TvShow.fromJson(json),
      );
      return baseResponse.results ?? [];
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<MovieDetail> getMovieById(int movieId) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/movie/$movieId',
        queryParameters: queryParameters,
      );

      final movie = MovieDetail.fromJson(response.data);
      return movie;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<TvShowDetail> getTvShowById(int tvShowId) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/tv/$tvShowId',
        queryParameters: queryParameters,
      );
      log(response.toString());

      final movie = TvShowDetail.fromJson(response.data);
      return movie;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Genre>> getGenres(String collection) async {
    try {
      final response = await dio.get(
        '$_baseUrl/genre/$collection/list',
        queryParameters: {"api_key": _apiKey},
      );
      final genres = Genres.fromJson(response.data);

      return genres.genres as List<Genre>;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Movie>> getDiscoverMovies(Map<String, dynamic> params) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll(params);
      queryParameters.addAll({"api_key": _apiKey});
      final response = await dio.get(
        '$_baseUrl/discover/movie',
        queryParameters: queryParameters,
      );
      final baseResponse = BaseResponse<Movie>.fromJson(
        response.data,
        (json) => Movie.fromJson(json),
      );
      return baseResponse.results as List<Movie>;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<PersonDetail> getPersonDetailById(int personId) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});

      final response = await dio.get(
        '$_baseUrl/person/$personId',
        queryParameters: queryParameters,
      );

      return PersonDetail.fromJson(response.data);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});

      final response = await dio.get(
        '$_baseUrl/person/$personId/combined_credits',
        queryParameters: queryParameters,
      );

      final List<dynamic> cast = response.data['cast'] ?? [];
      List<PersonCredit> credits =
          cast.where((credit) => credit['poster_path'] != null).map((json) => PersonCredit.fromJson(json)).toList();

      // Tarihe göre sırala
      credits.sort((a, b) => (b.releaseDate ?? '').compareTo(a.releaseDate ?? ''));
      return credits;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<String>> getPersonImages(int personId) async {
    try {
      final queryParameters = _defaultParams;
      queryParameters.addAll({"api_key": _apiKey});

      final response = await dio.get(
        '$_baseUrl/person/$personId/images',
        queryParameters: queryParameters,
      );

      final List<dynamic> profiles = response.data['profiles'] ?? [];
      return profiles.map<String>((image) => image['file_path'] as String).toList();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<SearchResponse<SearchResult>> getMultiSearchResponse(String query, int page) async {
    try {
      final response = await dio.get(
        '$_baseUrl/search/multi',
        queryParameters: {
          'query': query,
          'page': page,
          'api_key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];

        final filteredResults = results
            .where((result) =>
                (result['poster_path'] != null && (result['media_type'] == 'movie' || result['media_type'] == 'tv')) ||
                (result['profile_path'] != null && result['media_type'] == 'person'))
            .map<SearchResult>((json) => SearchResult.fromJson(json))
            .toList();

        return SearchResponse(
          results: filteredResults,
          currentPage: data['page'] ?? 1,
          totalPages: data['total_pages'] ?? 1,
        );
      }

      return SearchResponse(
        results: [],
        currentPage: page,
        totalPages: 1,
        error: 'Beklenmeyen bir hata oluştu',
      );
    } catch (e) {
      return SearchResponse(
        results: [],
        currentPage: page,
        totalPages: 1,
        error: e.toString(),
      );
    }
  }
}
