import 'package:moviebar/core/models/base_media.dart';

class TvShow extends BaseMedia {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;

  String? firstAirDate;
  String? name;
  double? voteAverage;
  int? voteCount;

  TvShow(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      super.id,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      super.posterPath,
      this.firstAirDate,
      this.name,
      this.voteAverage,
      this.voteCount});

  TvShow.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originCountry = json['origin_country'].cast<String>();
    originalLanguage = json['original_language'];
    originalName = json['original_name'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    firstAirDate = json['first_air_date'];
    name = json['name'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}