import 'package:flutter/material.dart';
import 'package:moviebar/core/providers/navigation_provider.dart';
import 'package:moviebar/view/categories/categories_view.dart';
import 'package:moviebar/view/home/home_view.dart';
import 'package:moviebar/view/profile/profile_view.dart';
import 'package:moviebar/view/search/search_view.dart';
import 'package:provider/provider.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  // Sayfa listesini static olarak tutuyoruz
  static final List<Widget> _pages = [
    const HomeView(),
    const CategoriesView(),
    const SearchView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: Scaffold(
        body: Consumer<NavigationProvider>(
          builder: (context, provider, child) {
            return IndexedStack(
              index: provider.currentIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, provider, child) {
            return Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: provider.currentIndex,
                  onTap: provider.setIndex,
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey.withValues(alpha: 0.5),
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_filled),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_library_outlined),
                      activeIcon: Icon(Icons.video_library),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_outlined),
                      activeIcon: Icon(Icons.search),
                      label: 'Search',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined),
                      activeIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
