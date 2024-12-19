abstract class BaseApiService {
  Future<String> createRequestToken();
  Future<Map<String, dynamic>> createAccessToken(String requestToken);
  Future<Map<String, dynamic>> createSession(String accessToken);
  Future<Map<String, dynamic>> getUserDetails(String accessToken);

  Future<dynamic> getPopularMovies();
  Future<dynamic> getPopularTvShows();
  Future<dynamic> getTopRatedMovies();
  Future<dynamic> getTopRatedTvShows();
  Future<dynamic> getMovieById(int movieId);
  Future<dynamic> getTvShowById(int movieId);
  Future<dynamic> getGenres(String collection);
  Future<dynamic> getDiscoverMovies(Map<String, dynamic> params);
  Future<dynamic> getPersonDetailById(int personId);
  Future<dynamic> getPersonCombinedCredits(int personId);
  Future<dynamic> getPersonImages(int personId);
  Future<dynamic> getMultiSearchResponse(String query, int page);
}
