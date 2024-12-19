import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:moviebar/core/models/base_media.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/core/models/tv_show.dart';
import 'package:moviebar/view/movie_detail/movie_detail_view.dart';
import 'package:moviebar/view/tv_show_detail/tv_show_detail_view.dart';

// Özel cache manager tanımlayalım
final customCacheManager = CacheManager(
  Config(
    'movieImagesCache', // Unique key
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ),
);

class MediaContentScroll<T extends BaseMedia> extends StatelessWidget {
  final String contentTitle;
  final List<T> media;

  const MediaContentScroll({super.key, required this.contentTitle, required this.media});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contentTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "All",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: media.length,
            itemBuilder: (context, index) {
              final imageUrl = "https://image.tmdb.org/t/p/w500/${media[index].posterPath}";

              return GestureDetector(
                onTap: () {
                  if (media is List<Movie>) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailView(movieId: media[index].id!.toInt()),
                      ),
                    );
                  } else if (media is List<TvShow>) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TvShowDetailView(showId: media[index].id!.toInt()),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[850],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      cacheManager: customCacheManager,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 300),
                      placeholderFadeInDuration: const Duration(milliseconds: 300),
                      placeholder: (context, url) => Center(
                        child: Container(
                          color: Colors.grey[850],
                          child: const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[850],
                        child: const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      memCacheHeight: 500,
                      useOldImageOnUrlChange: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
