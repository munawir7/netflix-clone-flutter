import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constant.dart';
import '../../../data/models/movie_model.dart';
import '../../providers/movie_pagination_provider.dart';
import 'movie_detail.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingController =
        ref.watch(moviePaginationProvider('Trending Now'));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'NETFLIX',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: trendingController,
        builder: (context, child) {
          if (trendingController.isLoading &&
              trendingController.movies.isEmpty) {
            return const _MovieLoadingView();
          }

          if (trendingController.error != null &&
              trendingController.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to load movies.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: trendingController.retry,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return _MovieHomeContent(
            trendingController: trendingController,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _MovieHomeContent extends StatelessWidget {
  final MoviePaginationController trendingController;

  const _MovieHomeContent({
    required this.trendingController,
  });

  @override
  Widget build(BuildContext context) {
    const categories = <String>[
      'Trending Now',
      'Popular on Netflix',
      'Recommended for You',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: trendingController,
            builder: (context, child) {
              return _buildFeaturedBanner(
                context,
                trendingController.movies,
              );
            },
          ),
          for (final category in categories)
            _PaginatedMovieSection(
              key: ValueKey(category),
              title: category,
              category: category,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner(
    BuildContext context,
    List<MovieModel> movies,
  ) {
    final featuredMovie = movies.isNotEmpty ? movies.first : null;

    return Container(
      height: 260,
      width: double.infinity,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppConstants.borderRadius,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF641515),
            Color(0xFF141414),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          if (featuredMovie != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius,
                ),
                child: Image.network(
                  featuredMovie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  featuredMovie?.title ?? 'Discover Movies',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Movies and shows picked for you.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (featuredMovie != null) {
                          _openMovieDetails(context, featuredMovie);
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (featuredMovie != null) {
                          _openMovieDetails(context, featuredMovie);
                        }
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('More Info'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginatedMovieSection extends ConsumerWidget {
  final String title;
  final String category;

  const _PaginatedMovieSection({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      moviePaginationProvider(category),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.isLoading && controller.movies.isEmpty) {
          return _buildLoadingSection(context);
        }

        if (controller.error != null &&
            controller.movies.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to load this category.',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: controller.retry,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.movies.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildMovieSection(context, controller);
      },
    );
  }

 Widget _buildLoadingSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey.shade700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 190,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 125,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 0,
                    right: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildMovieSection(
  BuildContext context,
  MoviePaginationController controller,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.axis == Axis.horizontal &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 100) {
                controller.loadMoreMovies();
              }

              return false;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.movies.length +
                  (controller.isLoadingMore ? 1 : 0) +
                  (controller.error != null &&
                          controller.movies.isNotEmpty
                      ? 1
                      : 0),
              itemBuilder: (context, index) {
                if (index >= controller.movies.length) {
                  if (controller.error != null) {
                    return SizedBox(
                      width: 125,
                      child: Center(
                        child: IconButton(
                          tooltip: 'Retry loading movies',
                          onPressed: controller.retry,
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }

                  return const SizedBox(
                    width: 70,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                final movie = controller.movies[index];

                return GestureDetector(
                  onTap: () => _openMovieDetails(context, movie),
                  child: Container(
                    width: 125,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 0,
                      right: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.posterUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Container(
                                  color: AppColors.surface,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.movie_outlined,
                                    size: 40,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '⭐ ${movie.rating}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
}

void _openMovieDetails(BuildContext context, MovieModel movie) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => MovieDetailScreen(movie: movie),
    ),
  );
}

class _MovieLoadingView extends StatelessWidget {
  const _MovieLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey.shade700,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              margin: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadius,
                ),
              ),
            ),
            for (int section = 0; section < 3; section++) ...[
              Container(
                width: 170,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 65,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 0,
                        right: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
            ],
          ],
        ),
      ),
    );
  }
}