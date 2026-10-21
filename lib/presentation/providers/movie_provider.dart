import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/movie_model.dart';
import '../../data/repositories/movie_repository.dart';

// Provides the movie repository throughout the app.
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
return MovieRepository();
});

// Loads the movie list asynchronously.
final moviesProvider = FutureProvider<List<MovieModel>>((ref) {
final repository = ref.watch(movieRepositoryProvider);
return repository.getMovies();
});
