// categories_view.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie.dart';
import 'package:moviebar/view/categories/categories_view_model.dart';
import 'package:moviebar/view/movie_detail/movie_detail_view.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late CategoriesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CategoriesViewModel();
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Categories',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Consumer<CategoriesViewModel>(
              builder: (context, viewModel, _) {
                return IconButton(
                  icon: Badge(
                    label: Text(viewModel.selectedGenreIds.length.toString()),
                    isLabelVisible: viewModel.selectedGenreIds.isNotEmpty,
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _showFilterDialog(context, viewModel),
                );
              },
            ),
          ],
        ),
        body: Consumer<CategoriesViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && viewModel.movies.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                _buildSelectedFilters(viewModel),
                if (viewModel.isLoading) const LinearProgressIndicator(),
                Expanded(child: _buildMovieGrid(viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedFilters(CategoriesViewModel viewModel) {
    if (viewModel.selectedGenreIds.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.selectedGenreIds.length + 1, // +1 for clear all button
        itemBuilder: (context, index) {
          // Clear All Button
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: ActionChip(
                label: const Text('Clear All'),
                onPressed: viewModel.clearFilters,
                backgroundColor: Colors.red,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            );
          }

          // Genre Chips
          final genreId = viewModel.selectedGenreIds[index - 1];
          final genre = viewModel.genres.firstWhere((g) => g.id == genreId);

          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: ActionChip(
              label: Text(genre.name.toString()),
              onPressed: () => viewModel.toggleGenre(genreId),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context, CategoriesViewModel viewModel) {
    // Dialog'da kullanılacak geçici liste
    List<int> tempSelectedIds = List.from(viewModel.selectedGenreIds);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Categories'),
              content: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: viewModel.genres.map((genre) {
                    return FilterChip(
                      label: Text(genre.name.toString()),
                      selected: tempSelectedIds.contains(genre.id),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            tempSelectedIds.add(genre.id!.toInt());
                          } else {
                            tempSelectedIds.remove(genre.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    viewModel.applyFilters(tempSelectedIds);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMovieGrid(CategoriesViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.movies.length,
      itemBuilder: (context, index) {
        final movie = viewModel.movies[index];
        return MovieCard(movie: movie);
      },
    );
  }
}

// Ayrı bir widget olarak film kartı
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailView(movieId: movie.id!.toInt()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[850],
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage!.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
