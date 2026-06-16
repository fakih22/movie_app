import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';
import '../services/tmdb_api.dart';
import '../utils/app_strings.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  final TmdbApi _api = TmdbApi();
  Movie? _detailedMovie;
  bool _isLoading = false;
  String? _error;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _loadMovieDetails();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadMovieDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detailedMovie = await _api.getMovieDetails(widget.movie.id);
      setState(() {
        _detailedMovie = detailedMovie;
        _error = null;
      });
      _animController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      _animController.forward();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = _detailedMovie ?? widget.movie;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with backdrop
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0D0D2B) : Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final isFavorite = favoritesProvider.isFavorite(
                    movie.id,
                    'movie',
                  );
                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await favoritesProvider.toggleFavorite(movie, 'movie');
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          color:
                              isFavorite
                                  ? const Color(0xFFFF2D87)
                                  : Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) => Container(
                          color:
                              isDark
                                  ? const Color(0xFF1A1A3E)
                                  : Colors.grey[200],
                          child: const Icon(Icons.movie_rounded, size: 50),
                        ),
                  ),
                  // Bottom gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          isDark ? const Color(0xFF0D0D2B) : Colors.white,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Top gradient for status bar
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Movie info chips
                    _buildMovieInfoChips(movie),

                    const SizedBox(height: 24),

                    // Overview
                    Text(
                      AppStrings.overview,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : 'No overview available.',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            isDark ? const Color(0xFFB0B0CC) : Colors.grey[700],
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Loading indicator
                    if (_isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),

                    // Error message
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2D87).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFFFF2D87,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFFF2D87),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Failed to load details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _loadMovieDetails,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF2D87),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfoChips(Movie movie) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // Rating
        _buildInfoChip(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFFFAB00),
          label: movie.formattedRating,
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFAB00).withValues(alpha: isDark ? 0.15 : 0.1),
              const Color(0xFFFF6D00).withValues(alpha: isDark ? 0.1 : 0.05),
            ],
          ),
        ),

        // Release date
        if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty)
          _buildInfoChip(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF00D4FF),
            label: _formatDate(movie.releaseDate!),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00D4FF).withValues(alpha: isDark ? 0.15 : 0.1),
                const Color(0xFF7B2FF7).withValues(alpha: isDark ? 0.1 : 0.05),
              ],
            ),
          ),

        // Vote count
        _buildInfoChip(
          icon: Icons.people_rounded,
          iconColor: const Color(0xFF7B2FF7),
          label: '${movie.voteCount} ${AppStrings.votes}',
          gradient: LinearGradient(
            colors: [
              const Color(0xFF7B2FF7).withValues(alpha: isDark ? 0.15 : 0.1),
              const Color(0xFFFF2D87).withValues(alpha: isDark ? 0.1 : 0.05),
            ],
          ),
        ),

        // Language
        _buildInfoChip(
          icon: Icons.language_rounded,
          iconColor: const Color(0xFF4CAF50),
          label: movie.originalLanguage.toUpperCase(),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50).withValues(alpha: isDark ? 0.15 : 0.1),
              const Color(0xFF00D4FF).withValues(alpha: isDark ? 0.1 : 0.05),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
