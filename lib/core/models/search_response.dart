class SearchResponse<T> {
  final List<T> results;
  final int currentPage;
  final int totalPages;
  final String? error;

  SearchResponse({
    required this.results,
    required this.currentPage,
    required this.totalPages,
    this.error,
  });
}
