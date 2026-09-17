import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../widgets/article_tile.dart';
import '../widgets/category_chip.dart';
import 'detail_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pencarian')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Cari artikel...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: provider.setSearch,
          ),
          const SizedBox(height: 20),
          Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryChip(
                  label: 'Semua',
                  selected: provider.selectedCategoryId == null,
                  onTap: () => provider.setCategoryFilter(null),
                ),
                ...provider.categories.map(
                  (c) => CategoryChip(
                    label: c.name,
                    selected: provider.selectedCategoryId == c.id,
                    onTap: () => provider.setCategoryFilter(c.id),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            provider.selectedCategoryId == null
                ? 'Semua Artikel'
                : 'Kategori: ${provider.categoryName(provider.selectedCategoryId)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Divider(),
          if (provider.filteredPosts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('Tidak ada artikel ditemukan', style: Theme.of(context).textTheme.bodySmall),
            ),
          ...provider.filteredPosts.map(
            (p) => Column(
              children: [
                ArticleTile(
                  post: p,
                  categoryName: provider.categoryName(p.categoryId),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(postId: p.id))),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}