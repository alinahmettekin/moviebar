// lib/views/movie_detail_view.dart

import 'package:flutter/material.dart';
import 'package:moviebar/core/models/movie/movie_detail.dart';
import 'package:moviebar/view/movie_detail/movie_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class MovieDetailView extends StatefulWidget {
  final int movieId;

  const MovieDetailView({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  // ... initState, dispose ve diğer state yönetimi kodları aynı kalacak
  late MovieDetailViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MovieDetailViewModel();
    _viewModel.fetchMovieDetail(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: Consumer<MovieDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _buildErrorWidget(viewModel.error!);
            }

            final movie = viewModel.movieDetail;
            if (movie == null) {
              return const Center(child: Text('No data available'));
            }

            return CustomScrollView(
              slivers: [
                _buildSliverHeader(movie),
                SliverToBoxAdapter(
                  child: _buildBody(movie),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverHeader(MovieDetail movie) {
    return SliverAppBar(
      expandedHeight: 500,
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/original/${movie.backdropPath}",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black,
                  ],
                  stops: const [0.1, 0.5, 0.8, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (movie.tagline!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      movie.tagline.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(MovieDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainInfo(movie),
        _buildGenres(movie),
        _buildOverview(movie),
        _buildStats(movie),
        _buildProductionInfo(movie),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMainInfo(MovieDetail movie) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.black, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage!.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${movie.voteCount} votes)',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${movie.runtime} min',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenres(MovieDetail movie) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: movie.genre!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Text(
              movie.genre![index].name.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverview(MovieDetail movie) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            movie.overview.toString(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(MovieDetail movie) {
    final stats = [
      _buildStatItem('Budget', '\$${(movie.budget ?? 2700000 / 1000000).toStringAsFixed(1)}M'),
      _buildStatItem('Revenue', '\$${(movie.revenue ?? 6000000 / 1000000).toStringAsFixed(1)}M'),
      _buildStatItem('Release', movie.releaseDate.toString()),
      _buildStatItem('Status', movie.status.toString()),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: stats,
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionInfo(MovieDetail movie) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Production Companies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: movie.productionCompanies!.map((company) {
              return Column(
                children: [
                  if (company.logoPath != null)
                    CachedNetworkImage(
                      imageUrl: "https://image.tmdb.org/t/p/w200${company.logoPath}",
                      height: 40,
                      color: Colors.white,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    company.name.toString(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
