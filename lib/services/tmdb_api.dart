import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../models/tv_series.dart';
import '../models/genre.dart';
import '../models/search_result.dart';
import '../utils/constants.dart';

class TmdbApi {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = AppConstants.tmdbApiKey;

  final Dio _dio;

  TmdbApi()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = _apiKey;
          options.queryParameters['language'] = 'en-US';
          handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  // Movie endpoints
  Future<MovieResponse> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load now playing movies: $e');
    }
  }

  Future<MovieResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  Future<MovieResponse> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page},
      );
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load top rated movies: $e');
    }
  }

  Future<MovieResponse> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/upcoming',
        queryParameters: {'page': page},
      );
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load upcoming movies: $e');
    }
  }

  // TV Series endpoints
  Future<TvSeriesResponse> getPopularTvSeries({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/tv/popular',
        queryParameters: {'page': page},
      );
      return TvSeriesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load popular TV series: $e');
    }
  }

  Future<TvSeriesResponse> getTopRatedTvSeries({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/tv/top_rated',
        queryParameters: {'page': page},
      );
      return TvSeriesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load top rated TV series: $e');
    }
  }

  Future<TvSeriesResponse> getOnTheAirTvSeries({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/tv/on_the_air',
        queryParameters: {'page': page},
      );
      return TvSeriesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load on the air TV series: $e');
    }
  }

  // Search endpoints
  Future<SearchResultResponse> searchMulti(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/multi',
        queryParameters: {'query': query, 'page': page, 'include_adult': false},
      );
      return SearchResultResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }

  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page, 'include_adult': false},
      );
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<TvSeriesResponse> searchTvSeries(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/tv',
        queryParameters: {'query': query, 'page': page, 'include_adult': false},
      );
      return TvSeriesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to search TV series: $e');
    }
  }

  // Genre endpoints
  Future<GenreResponse> getMovieGenres() async {
    try {
      final response = await _dio.get('/genre/movie/list');
      return GenreResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie genres: $e');
    }
  }

  Future<GenreResponse> getTvGenres() async {
    try {
      final response = await _dio.get('/genre/tv/list');
      return GenreResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load TV genres: $e');
    }
  }

  // Movie details
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {'append_to_response': 'credits,videos'},
      );
      return Movie.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  // TV Series details
  Future<TvSeries> getTvSeriesDetails(int seriesId) async {
    try {
      final response = await _dio.get(
        '/tv/$seriesId',
        queryParameters: {'append_to_response': 'credits,videos'},
      );
      return TvSeries.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load TV series details: $e');
    }
  }
}
