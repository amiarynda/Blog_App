import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/bookmark_provider.dart';
import '../theme/app_theme.dart';
import '../utils/format_date.dart';
import '../utils/reading_time.dart';
import 'editor_page.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final int postId;
  const DetailPage({super.key, required this.postId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final matches = context.read<PostProvider>().posts.where((p) => p.id == widget.postId);
      if (matches.isNotEmpty) {
        context.read<BookmarkProvider>().recordRead(matches.first);
      }
    });
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus artikel?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      await context.read<PostProvider>().removePost(id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final matches = postProvider.posts.where((p) => p.id == widget.postId);

    if (matches.isEmpty) {
      return const Scaffold(body: Center(child: Text('Artikel tidak ditemukan')));
    }
    final post = matches.first;
    final minutes = calculateReadingMinutes(post.content);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(bookmarkProvider.isBookmarked(post.id) ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () => bookmarkProvider.toggle(post.id),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditorPage(post: post))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, post.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            postProvider.categoryName(post.categoryId).toUpperCase(),
            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, letterSpacing: 0.5, fontSize: 12),
          ),
          const SizedBox(height: 8),
Text(
  post.title,
  style: GoogleFonts.lora(
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.ink,
  ),
),

          const SizedBox(height: 8),
          Text('${formatDate(post.createdAt)} · $minutes min baca', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 20),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              post.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                width: double.infinity,
                color: AppColors.line,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(post.content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}
