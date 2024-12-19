import 'package:flutter/material.dart';
import 'package:moviebar/view/home/home_view_model.dart';
import 'package:moviebar/view/widgets/media_content_section.dart';
import 'package:moviebar/view/widgets/discover_section_scroll.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final read = Provider.of<HomeViewModel>(context, listen: false);
  late final listen = Provider.of<HomeViewModel>(context, listen: true);

  @override
  void initState() {
    read.fetchPopularMovies();
    read.fetchPopularTvShows();
    read.fetchTopRatedMovies();
    read.fetchTopRatedTvShows();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (listen.isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (listen.error != null) {
      return Center(
        child: Column(
          children: [
            const Icon(
              Icons.error,
              size: 60,
            ),
            Text(read.error.toString())
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          height: 50,
          child: Image.asset(
            'assets/app_bar_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Popular Movies
              Consumer<HomeViewModel>(
                builder: (context, value, child) => DiscoverSectionScroll(
                  discoverMovies: read.featuredMovies,
                  error: value.error,
                ),
              ),

              // Content Lists
              const SizedBox(height: 20),
              Consumer<HomeViewModel>(
                builder: (context, value, child) => MediaContentScroll(
                  contentTitle: "Popular TV Shows",
                  media: value.featuredTvShows,
                ),
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) => MediaContentScroll(
                  contentTitle: "Top Rated Movies",
                  media: value.topRatedMovies,
                ),
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) => MediaContentScroll(
                  contentTitle: "Top Rated Tv Shows",
                  media: value.topRatedTvShows,
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildGenreTag(String tag) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4),
  //     child: Row(
  //       children: [
  //         const CircleAvatar(
  //           radius: 2,
  //           backgroundColor: Colors.redAccent,
  //         ),
  //         const SizedBox(width: 6),
  //         Text(
  //           tag,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 14,
  //           ),
  //         ),
  //         const SizedBox(width: 6),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildContentSection(String title) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         child: Text(
  //           title,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 200,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           padding: const EdgeInsets.symmetric(horizontal: 8),
  //           itemCount: 10,
  //           itemBuilder: (context, index) {
  //             return Container(
  //               width: 140,
  //               margin: const EdgeInsets.symmetric(horizontal: 8),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(4),
  //                 image: DecorationImage(
  //                   image: NetworkImage(
  //                     'https://picsum.photos/200',
  //                   ),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
