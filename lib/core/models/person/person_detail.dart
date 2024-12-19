class PersonDetail {
  final int id;
  final String name;
  final String? profilePath;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? knownForDepartment;
  final List<String> alsoKnownAs;
  final String? imdbId;

  PersonDetail({
    required this.id,
    required this.name,
    this.profilePath,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.knownForDepartment,
    required this.alsoKnownAs,
    this.imdbId,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      biography: json['biography'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      placeOfBirth: json['place_of_birth'],
      knownForDepartment: json['known_for_department'],
      alsoKnownAs: List<String>.from(json['also_known_as'] ?? []),
      imdbId: json['imdb_id'],
    );
  }
}

class PersonCredit {
  final int id;
  final String mediaType;
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final String? character;
  final double voteAverage;

  PersonCredit({
    required this.id,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.releaseDate,
    this.character,
    required this.voteAverage,
  });

  factory PersonCredit.fromJson(Map<String, dynamic> json) {
    return PersonCredit(
      id: json['id'] ?? 0,
      mediaType: json['media_type'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? json['first_air_date'],
      character: json['character'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
    );
  }
}
