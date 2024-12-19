import 'package:moviebar/core/models/movie/movie_detail.dart';

class Genres {
  List<Genre>? genres;

  Genres({this.genres});

  Genres.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = <Genre>[];
      json['genres'].forEach((v) {
        genres!.add(Genre.fromJson(v));
      });
    }
  }
}
