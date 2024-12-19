class WatchList {
  final int id;
  final String name;
  final String? description;
  final int itemCount;
  final String? posterPath;
  final DateTime createdAt;

  WatchList({
    required this.id,
    required this.name,
    this.description,
    required this.itemCount,
    this.posterPath,
    required this.createdAt,
  });

  factory WatchList.fromJson(Map<String, dynamic> json) {
    return WatchList(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      itemCount: json['item_count'] ?? 0,
      posterPath: json['poster_path'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
