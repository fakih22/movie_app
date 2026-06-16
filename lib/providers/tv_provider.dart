import 'package:flutter/material.dart';
import '../models/tv_series.dart';
import '../services/tmdb_api.dart';

class TvProvider with ChangeNotifier {
  final TmdbApi _api = TmdbApi();

  // State variables
  List<TvSeries> _popularTvSeries = [];
  List<TvSeries> _topRatedTvSeries = [];
  List<TvSeries> _onTheAirTvSeries = [];

  bool _isLoadingPopular = false;
  bool _isLoadingTopRated = false;
  bool _isLoadingOnTheAir = false;

  String? _errorPopular;
  String? _errorTopRated;
  String? _errorOnTheAir;

  // Getters
  List<TvSeries> get popularTvSeries => _popularTvSeries;
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;
  List<TvSeries> get onTheAirTvSeries => _onTheAirTvSeries;

  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingTopRated => _isLoadingTopRated;
  bool get isLoadingOnTheAir => _isLoadingOnTheAir;

  String? get errorPopular => _errorPopular;
  String? get errorTopRated => _errorTopRated;
  String? get errorOnTheAir => _errorOnTheAir;

  bool get hasAnyLoading => _isLoadingPopular || _isLoadingTopRated || _isLoadingOnTheAir;

  // Methods
  Future<void> fetchPopularTvSeries({bool refresh = false}) async {
    if (_popularTvSeries.isNotEmpty && !refresh) return;

    _isLoadingPopular = true;
    _errorPopular = null;
    notifyListeners();

    try {
      final response = await _api.getPopularTvSeries();
      _popularTvSeries = response.results;
      _errorPopular = null;
    } catch (e) {
      _errorPopular = e.toString();
      _popularTvSeries = [];
    } finally {
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopRatedTvSeries({bool refresh = false}) async {
    if (_topRatedTvSeries.isNotEmpty && !refresh) return;

    _isLoadingTopRated = true;
    _errorTopRated = null;
    notifyListeners();

    try {
      final response = await _api.getTopRatedTvSeries();
      _topRatedTvSeries = response.results;
      _errorTopRated = null;
    } catch (e) {
      _errorTopRated = e.toString();
      _topRatedTvSeries = [];
    } finally {
      _isLoadingTopRated = false;
      notifyListeners();
    }
  }

  Future<void> fetchOnTheAirTvSeries({bool refresh = false}) async {
    if (_onTheAirTvSeries.isNotEmpty && !refresh) return;

    _isLoadingOnTheAir = true;
    _errorOnTheAir = null;
    notifyListeners();

    try {
      final response = await _api.getOnTheAirTvSeries();
      _onTheAirTvSeries = response.results;
      _errorOnTheAir = null;
    } catch (e) {
      _errorOnTheAir = e.toString();
      _onTheAirTvSeries = [];
    } finally {
      _isLoadingOnTheAir = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllTvSeries() async {
    await Future.wait([
      fetchPopularTvSeries(),
      fetchTopRatedTvSeries(),
      fetchOnTheAirTvSeries(),
    ]);
  }

  Future<void> refreshAllTvSeries() async {
    await Future.wait([
      fetchPopularTvSeries(refresh: true),
      fetchTopRatedTvSeries(refresh: true),
      fetchOnTheAirTvSeries(refresh: true),
    ]);
  }

  void clearErrors() {
    _errorPopular = null;
    _errorTopRated = null;
    _errorOnTheAir = null;
    notifyListeners();
  }
}
