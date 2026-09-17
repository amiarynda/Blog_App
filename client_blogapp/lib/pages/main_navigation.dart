import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../theme/app_colors.dart';
import 'home_page.dart';
import 'explore_page.dart';
import 'saved_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final String username;

  const MainNavigation({
    super.key,
    required this.username,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const ExplorePage(),
      const SavedPage(),
      ProfilePage(username: widget.username),
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: pages,
        ),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.line,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: SalomonBottomBar(
                currentIndex: _index,
                onTap: (i) => setState(() => _index = i),
                selectedItemColor: AppColors.ink,
                unselectedItemColor: AppColors.muted,
                items: [
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: const Icon(Icons.home),
                    title: const Text('Beranda'),
                    selectedColor: AppColors.ink,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.explore_outlined),
                    activeIcon: const Icon(Icons.explore),
                    title: const Text('Pencarian'),
                    selectedColor: AppColors.ink,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.bookmark_border),
                    activeIcon: const Icon(Icons.bookmark),
                    title: const Text('Simpan'),
                    selectedColor: AppColors.ink,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.person_outline),
                    activeIcon: const Icon(Icons.person),
                    title: const Text('Profil'),
                    selectedColor: AppColors.ink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}