import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/favorites_provider.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final double width;
  final double height;
  final bool showFavoriteButton;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 140,
    this.height = 240,
    this.showFavoriteButton = false,
    this.onTap,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          margin: const EdgeInsets.only(right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: widget.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? const Color(
                                      0xFF7B2FF7,
                                    ).withValues(alpha: 0.2)
                                    : Colors.black.withValues(alpha: 0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: widget.movie.posterUrl,
                          fit: BoxFit.cover,
                          width: widget.width,
                          height: double.infinity,
                          placeholder:
                              (context, url) => Container(
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? const Color(0xFF252552)
                                          : const Color(0xFFF0F1F8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? const Color(0xFF252552)
                                          : const Color(0xFFF0F1F8),
                                ),
                                child: Icon(
                                  Icons.movie_rounded,
                                  size: 36,
                                  color:
                                      isDark
                                          ? const Color(0xFFB0B0CC)
                                          : Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),

                    // Favorite button
                    if (widget.showFavoriteButton)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Consumer<FavoritesProvider>(
                          builder: (context, favoritesProvider, child) {
                            final isFavorite = favoritesProvider.isFavorite(
                              widget.movie.id,
                              'movie',
                            );
                            return GestureDetector(
                              onTap: () async {
                                await favoritesProvider.toggleFavorite(
                                  widget.movie,
                                  'movie',
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey(isFavorite),
                                    color:
                                        isFavorite
                                            ? const Color(0xFFFF2D87)
                                            : Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // Rating badge
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFAB00).withValues(alpha: 0.9),
                              const Color(0xFFFF6D00).withValues(alpha: 0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              widget.movie.formattedRating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Title
              SizedBox(
                width: widget.width,
                child: Text(
                  widget.movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Year
              Text(
                widget.movie.releaseYear,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? const Color(0xFFB0B0CC) : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
