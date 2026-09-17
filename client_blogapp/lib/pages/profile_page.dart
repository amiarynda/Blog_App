import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/bookmark_provider.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/wink.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: AppColors.accent, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Hi, $username!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 24),
          Text('Statistik', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBox(label: 'Artikel dibaca', value: '${bookmarkProvider.articlesRead}'),
              const SizedBox(width: 12),
              _StatBox(label: 'Menit membaca', value: '${bookmarkProvider.minutesRead}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatBox(label: 'Total artikel', value: '${postProvider.posts.length}'),
              const SizedBox(width: 12),
              _StatBox(label: 'Tersimpan', value: '${bookmarkProvider.bookmarkedIds.length}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}