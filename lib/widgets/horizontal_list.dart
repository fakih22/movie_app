import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onViewAll;
  final bool showViewAll;

  const HorizontalList({
    super.key,
    required this.title,
    required this.children,
    this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (showViewAll && onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? const Color(0xFF252552)
                              : const Color(0xFFF0F1F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Horizontal scrollable list
        SizedBox(
          height: 260,
          child:
              children.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_filter_rounded,
                          size: 36,
                          color:
                              isDark
                                  ? const Color(0xFFB0B0CC)
                                  : Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color:
                                isDark ? const Color(0xFFB0B0CC) : Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      return children[index];
                    },
                  ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
