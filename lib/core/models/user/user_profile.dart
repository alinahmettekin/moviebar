class UserProfile {
  final int id;
  final String name;
  final String username;
  final String? avatarPath;
  final bool includeAdult;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    this.avatarPath,
    required this.includeAdult,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      avatarPath: json['avatar']?['tmdb']?['avatar_path'],
      includeAdult: json['include_adult'] ?? false,
    );
  }
}
