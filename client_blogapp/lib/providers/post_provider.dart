import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class PostProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Post> posts = [];
  List<PostCategory> categories = [];
  bool isLoading = false;
  String? error;

  String searchQuery = '';
  int? selectedCategoryId; // null = semua kategori

  Future<void> loadInitial() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([_api.getPosts(), _api.getCategories()]);
      posts = results[0] as List<Post>;
      categories = results[1] as List<PostCategory>;
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPosts() async {
    try {
      posts = await _api.getPosts();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  void setSearch(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void setCategoryFilter(int? categoryId) {
    selectedCategoryId = selectedCategoryId == categoryId ? null : categoryId;
    notifyListeners();
  }

  List<Post> get filteredPosts {
    return posts.where((p) {
      final matchSearch =
          searchQuery.isEmpty || p.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCategory = selectedCategoryId == null || p.categoryId == selectedCategoryId;
      return matchSearch && matchCategory;
    }).toList();
  }

Post? get featuredPost {
  if (posts.isEmpty) return null;
  final withDate = posts.where((p) => p.createdAt != null).toList();
  if (withDate.isEmpty) return posts.first; // fallback kalau createdAt null semua
  withDate.sort((a, b) => b.createdAt!.compareTo(a.createdAt!)); // descending = terbaru duluan
  return withDate.first;
}

  String categoryName(int? id) {
    if (id == null) return 'Umum';
    final found = categories.where((c) => c.id == id);
    return found.isEmpty ? 'Umum' : found.first.name;
  }

  Future<void> addPost(Post post) async {
  await _api.createPost(
    title: post.title,
    content: post.content,
    categoryId: post.categoryId,
    imageUrl: post.imageUrl,
    status: post.status,
  );
  await refreshPosts(); // ambil ulang dari GET, bukan ngarep data balik dari POST
}

  Future<void> editPost(int id, Post post) async {
  await _api.updatePost(
    id: id,
    title: post.title,
    content: post.content,
    categoryId: post.categoryId,
    imageUrl: post.imageUrl,
    status: post.status,
  );
  await refreshPosts();
}
  Future<void> removePost(int id) async {
    await _api.deletePost(id);
    posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
