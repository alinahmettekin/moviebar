import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/view/movie_detail/movie_detail_view.dart';

final customCacheManager = CacheManager(
  Config(
    'movieImagesCache', // Unique key
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ),
);

class DiscoverSectionScroll extends StatelessWidget {
  final List<Movie> discoverMovies;
  final String? error;

  const DiscoverSectionScroll({super.key, required this.discoverMovies, required this.error});

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      log(error.toString());
      return Center(
        child: Text(
          error!,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: PageView.builder(
        itemCount: discoverMovies.length, // Featured film sayısı
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background image
              Container(
                decoration: BoxDecoration(),
                child:
                    CachedNetworkImage(imageUrl: "https://image.tmdb.org/t/p/w500/${discoverMovies[index].posterPath}"),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black,
                    ],
                  ),
                ),
              ),
              // Content Column
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Page indicator - En üstte
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        discoverMovies.length,
                        (dotIndex) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: dotIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: dotIndex == index ? Colors.redAccent : Colors.grey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Film başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      discoverMovies[index].title.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Genre Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                  const SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.add, "Add To List", 28),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MovieDetailView(
                              movieId: discoverMovies[index].id!.toInt(),
                            ),
                          ));
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text(
                          'Details',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      _buildActionButton(Icons.favorite, "Favourites", 28),
                    ],
                  ),
                  const SizedBox(height: 30), // En altta biraz boşluk
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildActionButton(IconData icon, String label, double size, {VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
