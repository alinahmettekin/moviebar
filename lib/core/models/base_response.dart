// Generic base response sınıfı
class BaseResponse<T> {
  int? page;
  List<T>? results;
  int? totalPages;
  int? totalResults;

  BaseResponse({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  // fromJson fonksiyonu bir factory function alıyor
  BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    page = json['page'];
    if (json['results'] != null) {
      results = <T>[];
      json['results'].forEach((v) {
        results!.add(fromJsonT(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    if (results != null) {
      data['results'] = results!.map((v) => toJsonT(v)).toList();
    }
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}
