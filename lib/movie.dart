class Movie {
  final String title;
  final String posterUrl;
  final String overview;
  final String id;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: json['poster_path'],
      overview: json['overview'],
      id: json['id'].toString(),
    );
  }
}
