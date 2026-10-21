class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String category;
  final double rating;

  const MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.category,
    required this.rating,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      posterUrl: json['posterUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'category': category,
      'rating': rating,
    };
  }
}