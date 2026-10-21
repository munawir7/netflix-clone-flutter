import '../models/movie_model.dart';

class MovieRepository {
final List<MovieModel> _movies = const [
// Trending Now
MovieModel(
id: '1',
title: 'Stranger Things',
description: 'A mysterious adventure in a small town.',
posterUrl:
'https://image.tmdb.org/t/p/w500/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
category: 'Trending Now',
rating: 8.7,
),
MovieModel(
id: '2',
title: 'Wednesday',
description: 'A clever student investigates strange mysteries.',
posterUrl:
'https://image.tmdb.org/t/p/w500/jeGtaMwGxPmQN5xM4ClnwPQcNQz.jpg',
category: 'Trending Now',
rating: 8.0,
),
MovieModel(
id: '3',
title: 'Money Heist',
description: 'A criminal mastermind plans an ambitious robbery.',
posterUrl:
'https://image.tmdb.org/t/p/w500/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
category: 'Trending Now',
rating: 8.2,
),
MovieModel(
id: '4',
title: 'The Witcher',
description: 'A monster hunter explores a fantasy world.',
posterUrl:
'https://image.tmdb.org/t/p/w500/cZ0d3rtvXPVvuiX22sP79K3Hmjz.jpg',
category: 'Trending Now',
rating: 8.0,
),
MovieModel(
id: '5',
title: 'Dark',
description: 'A disappearance reveals secrets across generations.',
posterUrl:
'https://image.tmdb.org/t/p/w500/apbrbWs8M9lyOpJYU5WXrpFbk1Z.jpg',
category: 'Trending Now',
rating: 8.7,
),


// Popular on Netflix
MovieModel(
  id: '6',
  title: 'Lupin',
  description: 'A gentleman thief seeks justice for his father.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/sgxawbFB5Vi5OkPWQLNfl3dvkNJ.jpg',
  category: 'Popular on Netflix',
  rating: 7.5,
),
MovieModel(
  id: '7',
  title: 'The Queen\'s Gambit',
  description: 'A chess prodigy rises to the top.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/zU0htwkhNvBQdVSIKB9s6hgVeFK.jpg',
  category: 'Popular on Netflix',
  rating: 8.5,
),
MovieModel(
  id: '8',
  title: 'Extraction',
  description: 'A mercenary takes on a dangerous rescue mission.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/nygOUcBKPHFTbxsYRFZVePqgPK6.jpg',
  category: 'Popular on Netflix',
  rating: 6.8,
),
MovieModel(
  id: '9',
  title: 'The Adam Project',
  description: 'A time traveler meets his younger self.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/wFjboE0aFZNbVOF05fzrka9Fqyx.jpg',
  category: 'Popular on Netflix',
  rating: 6.7,
),
MovieModel(
  id: '10',
  title: 'Enola Holmes',
  description: 'A young detective investigates a mystery.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/riYInlsq2kf1AWoGm80JQW5dLKp.jpg',
  category: 'Popular on Netflix',
  rating: 6.6,
),

// Recommended for You
MovieModel(
  id: '11',
  title: 'Breaking Bad',
  description: 'A chemistry teacher enters the criminal world.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
  category: 'Recommended for You',
  rating: 9.5,
),
MovieModel(
  id: '12',
  title: 'Peaky Blinders',
  description: 'A gangster family expands its influence.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/vUUqzWa2LnHIVqkaKVlVGkVcZIW.jpg',
  category: 'Recommended for You',
  rating: 8.8,
),
MovieModel(
  id: '13',
  title: 'Squid Game',
  description: 'Contestants compete in mysterious survival games.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
  category: 'Recommended for You',
  rating: 8.0,
),
MovieModel(
  id: '14',
  title: 'The Umbrella Academy',
  description: 'Superpowered siblings reunite to prevent disaster.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/scZlQQYnDVlnpxFTxaIv2g0BWnL.jpg',
  category: 'Recommended for You',
  rating: 7.8,
),
MovieModel(
  id: '15',
  title: 'You',
  description: 'A bookstore manager becomes dangerously obsessed.',
  posterUrl:
      'https://image.tmdb.org/t/p/w500/oANi0vEE92nuijiZQgPZ88FSxqQ.jpg',
  category: 'Recommended for You',
  rating: 7.7,
),


];

/// Returns all dummy movies.
Future<List<MovieModel>> getMovies() async {
await Future.delayed(const Duration(seconds: 2));
return List.unmodifiable(_movies);
}

/// Returns movies belonging to a particular category.
Future<List<MovieModel>> getMoviesByCategory(String category) async {
  await Future.delayed(const Duration(seconds: 1));

  return _movies
      .where((movie) => movie.category == category)
      .toList();
}
/// Loads a page of movies from a particular category.
Future<List<MovieModel>> getMoviesByCategoryPage({
  required String category,
  required int page,
  int pageSize = 3,
}) async {
  // Simulate an API request.
  await Future.delayed(const Duration(seconds: 1));

  final categoryMovies = _movies
      .where((movie) => movie.category == category)
      .toList();

  final startIndex = page * pageSize;

  if (startIndex >= categoryMovies.length) {
    return [];
  }

  final endIndex = (startIndex + pageSize)
      .clamp(0, categoryMovies.length);

  return categoryMovies.sublist(startIndex, endIndex);
}

/// Finds a movie by its ID.
MovieModel? getMovieById(String id) {
for (final movie in _movies) {
if (movie.id == id) {
return movie;
}
}


return null;


}
}
