import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';

class MovieProvider with ChangeNotifier {
  final TmdbApi _api = TmdbApi();

  // State variables
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];

  bool _isLoadingNowPlaying = false;
  bool _isLoadingPopular = false;
  bool _isLoadingTopRated = false;
  bool _isLoadingUpcoming = false;

  String? _errorNowPlaying;
  String? _errorPopular;
  String? _errorTopRated;
  String? _errorUpcoming;

  // Getters
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;

  bool get isLoadingNowPlaying => _isLoadingNowPlaying;
  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingTopRated => _isLoadingTopRated;
  bool get isLoadingUpcoming => _isLoadingUpcoming;

  String? get errorNowPlaying => _errorNowPlaying;
  String? get errorPopular => _errorPopular;
  String? get errorTopRated => _errorTopRated;
  String? get errorUpcoming => _errorUpcoming;

  bool get hasAnyLoading => _isLoadingNowPlaying || 
                           _isLoadingPopular || 
                           _isLoadingTopRated || 
                           _isLoadingUpcoming;

  // Methods
  Future<void> fetchNowPlayingMovies({bool refresh = false}) async {
    if (_nowPlayingMovies.isNotEmpty && !refresh) return;

    _isLoadingNowPlaying = true;
    _errorNowPlaying = null;
    notifyListeners();

    try {
      final response = await _api.getNowPlayingMovies();
      _nowPlayingMovies = response.results;
      _errorNowPlaying = null;
    } catch (e) {
      _errorNowPlaying = e.toString();
      _nowPlayingMovies = [];
    } finally {
      _isLoadingNowPlaying = false;
      notifyListeners();
    }
  }

  Future<void> fetchPopularMovies({bool refresh = false}) async {
    if (_popularMovies.isNotEmpty && !refresh) return;

    _isLoadingPopular = true;
    _errorPopular = null;
    notifyListeners();

    try {
      final response = await _api.getPopularMovies();
      _popularMovies = response.results;
      _errorPopular = null;
    } catch (e) {
      _errorPopular = e.toString();
      _popularMovies = [];
    } finally {
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedMovies({bool refresh = false}) async {
    if (_topRatedMovies.isNotEmpty && !refresh) return;

    _isLoadingTopRated = true;
    _errorTopRated = null;
    notifyListeners();

    try {
      final response = await _api.getTopRatedMovies();
      _topRatedMovies = response.results;
      _errorTopRated = null;
    } catch (e) {
      _errorTopRated = e.toString();
      _topRatedMovies = [];
    } finally {
      _isLoadingTopRated = false;
      notifyListeners();
    }
  }

  Future<void> fetchUpcomingMovies({bool refresh = false}) async {
    if (_upcomingMovies.isNotEmpty && !refresh) return;

    _isLoadingUpcoming = true;
    _errorUpcoming = null;
    notifyListeners();

    try {
      final response = await _api.getUpcomingMovies();
      _upcomingMovies = response.results;
      _errorUpcoming = null;
    } catch (e) {
      _errorUpcoming = e.toString();
      _upcomingMovies = [];
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllMovies() async {
    await Future.wait([
      fetchNowPlayingMovies(),
      fetchPopularMovies(),
      fetchTopRatedMovies(),
      fetchUpcomingMovies(),
    ]);
  }

  Future<void> refreshAllMovies() async {
    await Future.wait([
      fetchNowPlayingMovies(refresh: true),
      fetchPopularMovies(refresh: true),
      fetchTopRatedMovies(refresh: true),
      fetchUpcomingMovies(refresh: true),
    ]);
  }

  void clearErrors() {
    _errorNowPlaying = null;
    _errorPopular = null;
    _errorTopRated = null;
    _errorUpcoming = null;
    notifyListeners();
  }
}
