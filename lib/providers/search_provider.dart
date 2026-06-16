import 'dart:async';
import 'package:flutter/material.dart';
import '../models/search_result.dart';
import '../services/tmdb_api.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class SearchProvider with ChangeNotifier {
  final TmdbApi _api = TmdbApi();

  // State variables
  List<SearchResult> _searchResults = [];
  List<String> _searchHistory = [];
  String _currentQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;

  // Debounce timer
  Timer? _debounceTimer;

  // Getters
  List<SearchResult> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  String get currentQuery => _currentQuery;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasHistory => _searchHistory.isNotEmpty;

  // Methods
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }

    _currentQuery = query;
    _isSearching = true;
    _error = null;
    notifyListeners();

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer for debounce
    _debounceTimer = Timer(Duration(milliseconds: AppConstants.searchDebounceTime), () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.searchMulti(query);
      _searchResults = response.results;
      
      // Add to search history
      await StorageService.addToSearchHistory(query);
      await _loadSearchHistory();
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _isLoading = false;
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> _loadSearchHistory() async {
    _searchHistory = StorageService.getSearchHistory();
    notifyListeners();
  }

  Future<void> loadSearchHistory() async {
    await _loadSearchHistory();
  }

  Future<void> removeFromHistory(String query) async {
    await StorageService.removeFromSearchHistory(query);
    await _loadSearchHistory();
  }

  Future<void> clearHistory() async {
    await StorageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  void searchFromHistory(String query) {
    search(query);
  }

  void _clearSearch() {
    _searchResults.clear();
    _currentQuery = '';
    _error = null;
    _isSearching = false;
    _debounceTimer?.cancel();
    notifyListeners();
  }

  void clearSearch() {
    _clearSearch();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
