import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter_apps/movie_controller.dart';
import 'package:movies_flutter_apps/movie_details.dart';

class MovieListScreen extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text('Movies'),
      ),
      body: Obx(() {
        if (movieController.isLoading.value && movieController.movieList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: movieController.movieList.length,
                  itemBuilder: (context, index) {
                    final movie = movieController.movieList[index];
                    return ListTile(
                      leading: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterUrl}',
                        fit: BoxFit.cover,
                        width: 50,
                      ),
                      title: Text(movie.title),
                      subtitle: Text(movie.overview,maxLines: 2, ),
                      onTap: () {
                        Get.to(() => MovieDetail(movie: movie));
                      },
                    );
                  },
                ),
              ),
              if (movieController.isLoading.value)
                Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        movieController.loadNextPage();
                      },
                      child: Text('Next'),
                    ),
                  ),
                ),
            ],
          );
        }
      }),
    );
  }
}