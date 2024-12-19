class SearchResult {
  final int id;
  final String mediaType;
  final String title;
  final String imagePath; // poster_path veya profile_path için
  final double voteAverage;
  final String? releaseDate;
  final String? overview;
  final String? knownFor; // Sanatçılar için bilindiği işler
  final String? knownForDepartment;

  SearchResult(
      {required this.id,
      required this.mediaType,
      required this.title,
      required this.imagePath,
      required this.voteAverage,
      this.releaseDate,
      this.overview,
      this.knownFor,
      this.knownForDepartment});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] ?? '';

    String getTitle() {
      if (mediaType == 'movie') return json['title'] ?? '';
      if (mediaType == 'tv') return json['name'] ?? '';
      if (mediaType == 'person') return json['name'] ?? '';
      return '';
    }

    String getImagePath() {
      if (mediaType == 'person') {
        return json['profile_path'] ?? '';
      }
      return json['poster_path'] ?? '';
    }

    String? getKnownFor() {
      if (mediaType == 'person' && json['known_for'] is List) {
        final knownFor =
            (json['known_for'] as List).map((item) => item['title'] ?? item['name'] ?? '').take(2).join(', ');
        return knownFor.isNotEmpty ? knownFor : null;
      }
      return null;
    }

    return SearchResult(
        id: json['id'] ?? 0,
        mediaType: mediaType,
        title: getTitle(),
        imagePath: getImagePath(),
        voteAverage: mediaType == 'person' ? 0.0 : (json['vote_average'] ?? 0.0).toDouble(),
        releaseDate: mediaType == 'person' ? null : (json['release_date'] ?? json['first_air_date']),
        overview: json['overview'],
        knownFor: getKnownFor(),
        knownForDepartment: json["known_for_department"]);
  }
}
