import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviebar/view/login/login_view.dart';
import 'package:moviebar/view/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  final ProfileViewModel _viewModel = ProfileViewModel();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _viewModel.setContext(context);
    _initViewModel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initViewModel() async {
    await _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return _buildLoadingScreen();
            }
            if (viewModel.userProfile == null) {
              return _buildSignUp();
            }

            return Scaffold(
              backgroundColor: Colors.black,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  _buildAppBar(viewModel),
                  _buildProfileInfo(viewModel),
                  _buildTabBar(),
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFavoriteMovies(viewModel),
                    _buildFavoriteTVShows(viewModel),
                    _buildLists(viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildAppBar(ProfileViewModel viewModel) {
    final user = viewModel.userProfile;
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(
            'https://image.tmdb.org/t/p/w200${user!.avatarPath}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () async {
            await viewModel.logout();
            if (mounted) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileInfo(ProfileViewModel viewModel) {
    final user = viewModel.userProfile;
    if (user == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user.avatarPath != null
                  ? CachedNetworkImageProvider('https://image.tmdb.org/t/p/w200${user.avatarPath}')
                  : null,
              child: user.avatarPath == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: 'Filmler'),
            Tab(text: 'Diziler'),
            Tab(text: 'Listeler'),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteMovies(ProfileViewModel viewModel) {
    if (viewModel.favoriteMovies.isEmpty) {
      return _buildEmptyState('Favori film bulunmuyor');
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = viewModel.favoriteMovies[index];
        return _buildMediaCard(
          title: movie.title.toString(),
          posterPath: movie.posterPath,
          onTap: () {
            // Navigate to movie detail
          },
        );
      },
    );
  }

  Widget _buildFavoriteTVShows(ProfileViewModel viewModel) {
    if (viewModel.favoriteTVShows.isEmpty) {
      return _buildEmptyState('Favori dizi bulunmuyor');
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.favoriteTVShows.length,
      itemBuilder: (context, index) {
        final show = viewModel.favoriteTVShows[index];
        return _buildMediaCard(
          title: show.name.toString(),
          posterPath: show.posterPath,
          onTap: () {
            // Navigate to TV show detail
          },
        );
      },
    );
  }

  Widget _buildLists(ProfileViewModel viewModel) {
    if (viewModel.watchLists?.isEmpty ?? true) {
      return _buildEmptyState('Liste bulunmuyor');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.watchLists!.length,
      itemBuilder: (context, index) {
        final list = viewModel.watchLists![index];
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              list.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    list.description!,
                    style: TextStyle(color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.movie, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${list.itemCount} içerik',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
            leading: Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: list.posterPath != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://image.tmdb.org/t/p/w200${list.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[850],
              ),
              child: list.posterPath == null ? const Icon(Icons.list, color: Colors.white54) : null,
            ),
            onTap: () {
              // Navigate to list detail
            },
          ),
        );
      },
    );
  }

  Widget _buildMediaCard({
    required String title,
    required String? posterPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/w500$posterPath',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[850],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[850],
              child: const Center(
                child: Icon(Icons.error, color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Please sign in with TMDB for user account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(200, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
