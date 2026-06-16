import 'package:flutter/material.dart';
import '../models/favorite_item.dart';
import '../services/storage_service.dart';

class FavoritesProvider with ChangeNotifier {
  List<FavoriteItem> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FavoriteItem> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasFavorites => _favorites.isNotEmpty;
  int get favoritesCount => _favorites.length;

  // Get filtered favorites
  List<FavoriteItem> get favoriteMovies {
    return _favorites.where((item) => item.mediaType == 'movie').toList();
  }

  List<FavoriteItem> get favoriteTvSeries {
    return _favorites.where((item) => item.mediaType == 'tv').toList();
  }

  // Methods
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favorites = StorageService.getAllFavorites();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToFavorites(dynamic item, String mediaType) async {
    try {
      final favoriteItem = mediaType == 'movie' 
          ? FavoriteItem.fromMovie(item, DateTime.now())
          : FavoriteItem.fromTvSeries(item, DateTime.now());

      await StorageService.addToFavorites(favoriteItem);
      _favorites.insert(0, favoriteItem); // Add to beginning
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(int id, String mediaType) async {
    try {
      await StorageService.removeFromFavorites(id, mediaType);
      _favorites.removeWhere((item) => item.id == id && item.mediaType == mediaType);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isFavorite(int id, String mediaType) {
    return StorageService.isFavorite(id, mediaType);
  }

  Future<void> toggleFavorite(dynamic item, String mediaType) async {
    final id = item.id;
    
    if (isFavorite(id, mediaType)) {
      await removeFromFavorites(id, mediaType);
    } else {
      await addToFavorites(item, mediaType);
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await StorageService.clearAllFavorites();
      _favorites.clear();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get statistics
  Map<String, int> getFavoritesStats() {
    return StorageService.getFavoritesStats();
  }

  // Search within favorites
  List<FavoriteItem> searchFavorites(String query) {
    if (query.trim().isEmpty) return _favorites;
    
    final lowerQuery = query.toLowerCase();
    return _favorites.where((item) {
      final title = item.displayTitle.toLowerCase();
      final overview = item.overview.toLowerCase();
      return title.contains(lowerQuery) || overview.contains(lowerQuery);
    }).toList();
  }
}
