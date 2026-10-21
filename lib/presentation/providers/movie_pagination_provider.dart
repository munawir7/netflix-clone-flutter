import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';
import 'movie_provider.dart';

/// Provides a separate pagination controller for each movie category.
final moviePaginationProvider =
    Provider.family<MoviePaginationController, String>((ref, category) {
  final repository = ref.watch(movieRepositoryProvider);

  final controller = MoviePaginationController(
    repository: repository,
    category: category,
  );

  ref.onDispose(controller.dispose);

  controller.loadInitialMovies();

  return controller;
});

/// Manages paginated movie loading for a category.
class MoviePaginationController extends ChangeNotifier {
  MoviePaginationController({
    required MovieRepository repository,
    required this.category,
  }) : _repository = repository;

  final MovieRepository _repository;
  final String category;

  /// Number of movies requested per page.
  final int pageSize = 5;

  final List<MovieModel> movies = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;

  Object? error;

  int _currentPage = 0;

  /// Loads the first page of movies.
  Future<void> loadInitialMovies() async {
    if (isLoadingMore) return;

    isLoading = true;
    isLoadingMore = false;
    error = null;
    hasMore = true;
    _currentPage = 0;
    movies.clear();

    notifyListeners();

    try {
      final result = await _repository.getMoviesByCategoryPage(
        category: category,
        page: _currentPage,
        pageSize: pageSize,
      );

      movies.addAll(result);

      hasMore = result.length == pageSize;
    } catch (e) {
      error = e;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the next page when the user scrolls near the end.
  Future<void> loadMoreMovies() async {
    if (isLoading || isLoadingMore || !hasMore || error != null) {
      return;
    }

    isLoadingMore = true;
    error = null;

    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final result = await _repository.getMoviesByCategoryPage(
        category: category,
        page: nextPage,
        pageSize: pageSize,
      );

      if (result.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(result);
        _currentPage = nextPage;
        hasMore = result.length == pageSize;
      }
    } catch (e) {
      error = e;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Retries the failed request.
  Future<void> retry() async {
    if (isLoading || isLoadingMore) return;

    if (movies.isEmpty) {
      await loadInitialMovies();
    } else {
      error = null;
      await loadMoreMovies();
    }
  }
}