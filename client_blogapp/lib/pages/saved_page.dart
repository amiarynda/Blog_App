import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/article_tile.dart';
import 'detail_page.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final saved = postProvider.posts.where((p) => bookmarkProvider.isBookmarked(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Simpanan')),
      body: saved.isEmpty
          ? Center(
              child: Text('Belum ada artikel tersimpan', style: Theme.of(context).textTheme.bodySmall),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: saved
                  .map(
                    (p) => Column(
                      children: [
                        ArticleTile(
                          post: p,
                          categoryName: postProvider.categoryName(p.categoryId),
                          onTap: () =>
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(postId: p.id))),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
