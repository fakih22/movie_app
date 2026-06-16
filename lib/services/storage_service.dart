import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite_item.dart';
import '../utils/constants.dart';

class StorageService {
  static late Box<FavoriteItem> _favoritesBox;
  static late Box<String> _searchHistoryBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(FavoriteItemAdapter());
    
    // Open boxes
    _favoritesBox = await Hive.openBox<FavoriteItem>(AppConstants.favoritesBoxName);
    _searchHistoryBox = await Hive.openBox<String>(AppConstants.searchHistoryBoxName);
  }

  // Favorites management
  static Future<void> addToFavorites(FavoriteItem item) async {
    await _favoritesBox.put('${item.mediaType}_${item.id}', item);
  }

  static Future<void> removeFromFavorites(int id, String mediaType) async {
    await _favoritesBox.delete('${mediaType}_$id');
  }

  static bool isFavorite(int id, String mediaType) {
    return _favoritesBox.containsKey('${mediaType}_$id');
  }

  static List<FavoriteItem> getAllFavorites() {
    return _favoritesBox.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Sort by newest first
  }

  static List<FavoriteItem> getFavoriteMovies() {
    return _favoritesBox.values
        .where((item) => item.mediaType == 'movie')
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  static List<FavoriteItem> getFavoriteTvSeries() {
    return _favoritesBox.values
        .where((item) => item.mediaType == 'tv')
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  static Future<void> clearAllFavorites() async {
    await _favoritesBox.clear();
  }

  // Search history management
  static Future<void> addToSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    // Remove existing entry if it exists
    await _searchHistoryBox.delete(query);
    
    // Add to beginning of list
    await _searchHistoryBox.put(query, DateTime.now().toIso8601String());
    
    // Keep only last 20 searches
    final keys = _searchHistoryBox.keys.toList();
    if (keys.length > 20) {
      final toRemove = keys.skip(20).toList();
      for (final key in toRemove) {
        await _searchHistoryBox.delete(key);
      }
    }
  }

  static List<String> getSearchHistory() {
    return _searchHistoryBox.keys.cast<String>().toList().reversed.toList();
  }

  static Future<void> removeFromSearchHistory(String query) async {
    await _searchHistoryBox.delete(query);
  }

  static Future<void> clearSearchHistory() async {
    await _searchHistoryBox.clear();
  }

  // Get statistics
  static Map<String, int> getFavoritesStats() {
    final movies = getFavoriteMovies().length;
    final tvSeries = getFavoriteTvSeries().length;
    
    return {
      'total': movies + tvSeries,
      'movies': movies,
      'tv': tvSeries,
    };
  }
}
