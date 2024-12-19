import 'package:moviebar/core/models/base_media.dart';

class Movie extends BaseMedia {
  String? releaseDate;
  String? title;
  String? originalTitle;
  bool? video;
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;

  String? originalLanguage;
  String? overview;
  double? popularity;
  double? voteAverage;
  int? voteCount;

  Movie({
    this.releaseDate,
    this.title,
    this.video,
    this.originalTitle,
    this.adult,
    this.backdropPath,
    this.genreIds,
    super.id,
    this.originalLanguage,
    this.popularity,
    this.overview,
    super.posterPath,
    this.voteAverage,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] as double).toDouble(),
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] as double).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      originalTitle: json['original_title'] ?? '',
      title: json['title'] ?? '',
      releaseDate: json['release_date'] ?? '',
      video: json['video'] ?? false,
    );
  }
}
