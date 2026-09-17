import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../widgets/article_tile.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';
import 'editor_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<PostProvider>();
    final featured = provider.featuredPost;
    // Artikel terbaru : semua post KECUALI yang sudah jadi featured,
    // spy muncul.a gk doublee
    final latest = featured == null
        ? provider.posts
        : provider.posts.where((p) => p.id != featured.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Sela kala'), titleTextStyle: GoogleFonts.lora(
          color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w700)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.ink,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditorPage())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: provider.refreshPosts,
        child: provider.isLoading && provider.posts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null && provider.posts.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text(provider.error!, textAlign: TextAlign.center)),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    children: [
                      if (featured != null) ...[
                        _FeaturedCard(
                          post: featured,
                          categoryName: provider.categoryName(featured.categoryId),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text('Artikel Terbaru', style: Theme.of(context).textTheme.titleMedium),
                      const Divider(),
                      if (latest.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text('Belum ada artikel lain', style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ...latest.map(
                        (p) => Column(
                          children: [
                            ArticleTile(
                              post: p,
                              categoryName: provider.categoryName(p.categoryId),
                              onTap: () =>
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(postId: p.id))),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Post post;
  final String categoryName;
  const _FeaturedCard({required this.post, required this.categoryName});

@override
Widget build(BuildContext context) {
  const imageHeight = 280.0;

  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(postId: post.id)),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.ink),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Image.network(
                post.imageUrl!,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARTIKEL PILIHAN',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color.fromARGB(255, 94, 66, 45),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.title,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$categoryName · ${post.readingTime}',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}