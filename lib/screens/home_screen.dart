import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../providers/tv_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_card.dart';
import '../widgets/horizontal_list.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: IndexedStack(
          key: ValueKey(_currentIndex),
          index: _currentIndex,
          children: [
            const HomeContent(),
            const SearchScreen(),
            const FavoritesScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF12122E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_rounded,
                  Icons.home_outlined,
                  'Home',
                ),
                _buildNavItem(
                  1,
                  Icons.search_rounded,
                  Icons.search_outlined,
                  'Search',
                ),
                _buildNavItem(
                  2,
                  Icons.favorite_rounded,
                  Icons.favorite_outline_rounded,
                  'Favorites',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDark ? const Color(0xFF00D4FF) : const Color(0xFF7B2FF7);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? activeColor.withValues(alpha: 0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                key: ValueKey(isSelected),
                color:
                    isSelected
                        ? activeColor
                        : Theme.of(
                          context,
                        ).bottomNavigationBarTheme.unselectedItemColor,
                size: 24,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  late PageController _carouselController;
  int _currentCarouselPage = 0;
  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnim;

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.88);
    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerFadeAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();
    _loadData();
    _autoScrollCarousel();
  }

  void _autoScrollCarousel() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _carouselController.hasClients) {
        final movieProvider = context.read<MovieProvider>();
        final maxPages = movieProvider.nowPlayingMovies.take(7).length;
        if (maxPages > 0) {
          final nextPage = (_currentCarouselPage + 1) % maxPages;
          _carouselController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
        _autoScrollCarousel();
      }
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<MovieProvider>().fetchAllMovies(),
      context.read<TvProvider>().fetchAllTvSeries(),
      context.read<FavoritesProvider>().loadFavorites(),
    ]);
  }

  @override
  void dispose() {
    _carouselController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Consumer2<MovieProvider, TvProvider>(
        builder: (context, movieProvider, tvProvider, child) {
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.secondary,
            onRefresh: () async {
              await Future.wait([
                movieProvider.refreshAllMovies(),
                tvProvider.refreshAllTvSeries(),
              ]);
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Custom App Bar
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFadeAnim,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppConstants.appName,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()
                                          ..shader = const LinearGradient(
                                            colors: [
                                              Color(0xFF7B2FF7),
                                              Color(0xFF00D4FF),
                                            ],
                                          ).createShader(
                                            const Rect.fromLTWH(0, 0, 200, 40),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'What do you want to watch?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isDark
                                            ? const Color(0xFFB0B0CC)
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Theme toggle
                                Consumer<ThemeProvider>(
                                  builder: (context, themeProvider, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color:
                                            isDark
                                                ? const Color(0xFF252552)
                                                : const Color(0xFFF0F1F8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        onPressed:
                                            () => themeProvider.toggleTheme(),
                                        icon: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          transitionBuilder: (
                                            child,
                                            animation,
                                          ) {
                                            return RotationTransition(
                                              turns: animation,
                                              child: child,
                                            );
                                          },
                                          child: Icon(
                                            themeProvider.isDarkMode
                                                ? Icons.light_mode_rounded
                                                : Icons.dark_mode_rounded,
                                            key: ValueKey(
                                              themeProvider.isDarkMode,
                                            ),
                                            color:
                                                isDark
                                                    ? const Color(0xFFFFAB00)
                                                    : const Color(0xFF7B2FF7),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                // Favorites badge
                                Consumer<FavoritesProvider>(
                                  builder: (context, favoritesProvider, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color:
                                            isDark
                                                ? const Color(0xFF252552)
                                                : const Color(0xFFF0F1F8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.favorites,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.notifications_rounded,
                                              color:
                                                  isDark
                                                      ? const Color(0xFFF5F5F5)
                                                      : const Color(0xFF1A1A2E),
                                              size: 22,
                                            ),
                                          ),
                                          if (favoritesProvider.favoritesCount >
                                              0)
                                            Positioned(
                                              right: 8,
                                              top: 8,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF2D87),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 16,
                                                      minHeight: 16,
                                                    ),
                                                child: Text(
                                                  favoritesProvider
                                                      .favoritesCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Now Playing Carousel
                      _buildNowPlayingCarousel(movieProvider),

                      const SizedBox(height: 8),

                      // Popular Movies
                      HorizontalList(
                        title: '🔥 Popular Movies',
                        children:
                            movieProvider.popularMovies
                                .map(
                                  (movie) => MovieCard(
                                    movie: movie,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.movieDetail,
                                        arguments: movie,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      // Popular TV Series
                      HorizontalList(
                        title: '📺 Popular TV Series',
                        children:
                            tvProvider.popularTvSeries
                                .map(
                                  (tvSeries) => TvCard(
                                    tvSeries: tvSeries,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.tvDetail,
                                        arguments: tvSeries,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      // Top Rated Movies
                      HorizontalList(
                        title: '⭐ Top Rated Movies',
                        children:
                            movieProvider.topRatedMovies
                                .map(
                                  (movie) => MovieCard(
                                    movie: movie,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.movieDetail,
                                        arguments: movie,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      // Top Rated TV Series
                      HorizontalList(
                        title: '🏆 Top Rated TV Series',
                        children:
                            tvProvider.topRatedTvSeries
                                .map(
                                  (tvSeries) => TvCard(
                                    tvSeries: tvSeries,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.tvDetail,
                                        arguments: tvSeries,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      // Upcoming Movies
                      HorizontalList(
                        title: '🎬 Coming Soon',
                        children:
                            movieProvider.upcomingMovies
                                .map(
                                  (movie) => MovieCard(
                                    movie: movie,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.movieDetail,
                                        arguments: movie,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      // On The Air TV Series
                      HorizontalList(
                        title: '📡 On The Air',
                        children:
                            tvProvider.onTheAirTvSeries
                                .map(
                                  (tvSeries) => TvCard(
                                    tvSeries: tvSeries,
                                    showFavoriteButton: true,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.tvDetail,
                                        arguments: tvSeries,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNowPlayingCarousel(MovieProvider movieProvider) {
    if (movieProvider.isLoadingNowPlaying &&
        movieProvider.nowPlayingMovies.isEmpty) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).cardTheme.color ?? Colors.grey,
              Theme.of(context).cardTheme.color?.withValues(alpha: 0.5) ??
                  Colors.grey,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (movieProvider.errorNowPlaying != null) {
      return _buildErrorWidget(
        movieProvider.errorNowPlaying!,
        () => movieProvider.fetchNowPlayingMovies(refresh: true),
      );
    }

    if (movieProvider.nowPlayingMovies.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final movies = movieProvider.nowPlayingMovies.take(7).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B2FF7), Color(0xFF00D4FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Now Playing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _carouselController,
            itemCount: movies.length,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselPage = index;
              });
            },
            itemBuilder: (context, index) {
              final movie = movies[index];
              return AnimatedBuilder(
                animation: _carouselController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_carouselController.position.haveDimensions) {
                    value = (_carouselController.page! - index).abs().clamp(
                      0.0,
                      1.0,
                    );
                  }
                  return Transform.scale(
                    scale: 1.0 - (value * 0.08),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.movieDetail,
                          arguments: movie,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isDark
                                      ? const Color(
                                        0xFF7B2FF7,
                                      ).withValues(alpha: 0.3)
                                      : Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: movie.backdropUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).cardTheme.color,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).cardTheme.color,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.movie, size: 50),
                                    ),
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                  ],
                                  stops: const [0.0, 0.4, 1.0],
                                ),
                              ),
                            ),
                            // Content
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFFFFAB00,
                                          ).withValues(alpha: 0.9),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              movie.formattedRating,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        movie.releaseYear,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(movies.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentCarouselPage == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient:
                    _currentCarouselPage == index
                        ? const LinearGradient(
                          colors: [Color(0xFF7B2FF7), Color(0xFF00D4FF)],
                        )
                        : null,
                color:
                    _currentCarouselPage == index
                        ? null
                        : isDark
                        ? const Color(0xFF3A3A6A)
                        : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF2D87).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF2D87).withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF2D87),
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load data',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2D87),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends StatelessWidget {
  final Listenable animation;
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(animation: animation, builder: builder);
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const AnimatedBuilder2({
    super.key,
    required Listenable animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
