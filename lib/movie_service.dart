import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

class MovieService {
  static const String _apiKey = '601f8feacc9f85450eb8a6ad8f0ed584';
  static const String _baseUrl = 'https://api.themoviedb.org/3/movie/';

  static Future<List<Movie>> fetchMovies(int page) async {
    final response = await http.get(Uri.parse('$_baseUrl/popular?api_key=$_apiKey&page=$page'));

    if (response.statusCode == 200) {
      final List moviesJson = json.decode(response.body)['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<String?> fetchTrailer(String movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl$movieId/videos?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final List videosJson = json.decode(response.body)['results'];
      if (videosJson.isNotEmpty) {
        return videosJson.firstWhere((video) => video['type'] == 'Trailer' && video['site'] == 'YouTube')['key'];
      }
    }
    return null;
  }
}
