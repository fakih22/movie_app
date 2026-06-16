import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/movie_provider.dart';
import 'providers/tv_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/tv_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';
import 'utils/constants.dart';
import 'models/movie.dart';
import 'models/tv_series.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF12122E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive for local storage
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => TvProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const HomeScreen(),
            routes: {
              AppRoutes.search: (context) => const SearchScreen(),
              AppRoutes.favorites: (context) => const FavoritesScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppRoutes.movieDetail:
                  final movie = settings.arguments as Movie?;
                  if (movie != null) {
                    return PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              MovieDetailScreen(movie: movie),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }
                  return null;
                case AppRoutes.tvDetail:
                  final tvSeries = settings.arguments as TvSeries?;
                  if (tvSeries != null) {
                    return PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              TvDetailScreen(tvSeries: tvSeries),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    );
                  }
                  return null;
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
