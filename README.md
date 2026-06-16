# Movie App

A Flutter mobile application for exploring movies and TV shows using The Movie Database (TMDB) API.

## Features

- **Home Screen**: 
  - Carousel slider for "Now Playing" movies
  - Horizontal lists for Popular Movies, Top Rated Movies, Upcoming Movies
  - Horizontal lists for Popular TV Series and Top Rated TV Series

- **Detail Screen**: 
  - Display movie/TV series details with poster, backdrop, rating, and overview
  - Add to favorites functionality

- **Search Screen**: 
  - Real-time search with debouncing
  - Search history
  - Search across movies and TV shows

- **Favorites Screen**: 
  - View favorite movies and TV shows
  - Organized by tabs (All, Movies, TV Shows)
  - Search within favorites
  - Remove from favorites

## Technology Stack

- **Flutter**: Cross-platform mobile development framework
- **Provider**: State management
- **Dio**: HTTP client for API requests
- **Hive**: Local database for favorites and search history
- **Cached Network Image**: Image loading and caching
- **Carousel Slider**: Image carousel for home screen
- **Intl**: Date formatting

## Setup Instructions

### 1. Get TMDB API Key

1. Go to [TMDB](https://www.themoviedb.org/)
2. Create an account and verify your email
3. Go to Settings > API > Request an API Key
4. Copy your API key (v3 auth)

### 2. Configure API Key

Replace `YOUR_API_KEY_HERE` in the following files with your actual TMDB API key:

- `lib/services/tmdb_api.dart` (line 7)
- `lib/utils/constants.dart` (line 7)

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code

```bash
flutter packages pub run build_runner build
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── models/           # Data models (Movie, TvSeries, FavoriteItem, etc.)
├── services/         # API service and storage service
├── providers/        # State management providers
├── screens/          # UI screens
├── widgets/          # Reusable widgets
└── utils/            # Constants and utilities
```

## API Endpoints Used

- Movies: Now Playing, Popular, Top Rated, Upcoming
- TV Series: Popular, Top Rated, On The Air
- Search: Multi-search across movies and TV shows
- Details: Movie and TV series details

## Local Storage

- **Favorites**: Stored using Hive database
- **Search History**: Last 20 searches stored locally

## Features Implementation

### State Management
- Provider pattern for reactive state management
- Separate providers for movies, TV series, search, and favorites

### Error Handling
- Graceful error handling with user-friendly messages
- Retry functionality for failed requests

### Performance Optimizations
- Image caching with cached_network_image
- Debounced search to reduce API calls
- Lazy loading for large lists

### UI/UX
- Material Design 3 components
- Responsive design for different screen sizes
- Loading states and error indicators
- Smooth animations and transitions

## Dependencies

See `pubspec.yaml` for the complete list of dependencies.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is for educational purposes only. TMDB data and images are used under their API terms of service.
