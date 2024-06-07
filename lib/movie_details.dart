import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'movie.dart';
import 'movie_controller.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;
  final MovieController movieController = Get.find();

  MovieDetail({super.key, required this.movie});

  void _shareMovie(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      '${movie.title}\n\n${movie.overview}\n\nhttps://image.tmdb.org/t/p/w500${movie.posterUrl}',
      subject: movie.title,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _copyTitle(BuildContext context) {
    Clipboard.setData(ClipboardData(text: movie.title));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareMovie(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('https://image.tmdb.org/t/p/w500${movie.posterUrl}'),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _copyTitle(context),
                child: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(movie.overview),
              const SizedBox(height: 16),
              FutureBuilder<String?>(
                future: movieController.fetchTrailer(movie.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading trailer'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No trailer available'));
                  } else {
                    return YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: snapshot.data!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
