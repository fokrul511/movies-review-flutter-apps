import 'package:get/get.dart';
import 'movie.dart';
import 'movie_service.dart';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var movieList = <Movie>[].obs;
  var page = 1.obs;

  @override
  void onInit() {
    fetchMovies();
    super.onInit();
  }

  void fetchMovies() async {
    try {
      isLoading(true);
      var movies = await MovieService.fetchMovies(page.value);
      if (movies != null) {
        movieList.addAll(movies);
      }
    } finally {
      isLoading(false);
    }
  }

  void loadNextPage() {
    page.value++;
    fetchMovies();
  }

  Future<String?> fetchTrailer(String movieId) async {
    return await MovieService.fetchTrailer(movieId);
  }
}
