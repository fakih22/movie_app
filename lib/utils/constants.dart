class AppConstants {
  // API Configuration
  static const String tmdbApiKey = 'e37721eaddf13db757e1f09319d22160';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';

  // Image Sizes
  static const String posterSizeW92 = 'w92';
  static const String posterSizeW154 = 'w154';
  static const String posterSizeW185 = 'w185';
  static const String posterSizeW342 = 'w342';
  static const String posterSizeW500 = 'w500';
  static const String posterSizeW780 = 'w780';
  static const String posterSizeOriginal = 'original';

  static const String backdropSizeW300 = 'w300';
  static const String backdropSizeW780 = 'w780';
  static const String backdropSizeW1280 = 'w1280';
  static const String backdropSizeOriginal = 'original';

  // App Configuration
  static const String appName = 'CineVerse';
  static const String appVersion = '1.0.0';

  // Local Storage Keys
  static const String favoritesBoxName = 'favorites';
  static const String searchHistoryBoxName = 'search_history';
  static const String settingsBoxName = 'settings';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 500;

  // Debounce time for search (milliseconds)
  static const int searchDebounceTime = 500;

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Error messages
  static const String errorMessageGeneric =
      'Something went wrong. Please try again.';
  static const String errorMessageNoInternet =
      'No internet connection. Please check your network.';
  static const String errorMessageNotFound = 'No results found.';
  static const String errorMessageApiLimit =
      'API rate limit exceeded. Please try again later.';
}

class AppRoutes {
  static const String home = '/';
  static const String movieDetail = '/movie-detail';
  static const String tvDetail = '/tv-detail';
  static const String search = '/search';
  static const String favorites = '/favorites';
}
