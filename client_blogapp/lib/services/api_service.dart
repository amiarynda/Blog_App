import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  Future<List<Post>> getPosts() async {
    final res = await http.get(Uri.parse('$baseUrl/posts'));
    if (res.statusCode != 200) throw Exception('Gagal mengambil artikel');
    final List data = jsonDecode(res.body)['data'];
    return data.map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> getPostById(int id) async {
    final res = await http.get(Uri.parse('$baseUrl/posts/$id'));
    if (res.statusCode != 200) throw Exception('Artikel tidak ditemukan');
    return Post.fromJson(jsonDecode(res.body)['data']);
  }

  Future<List<PostCategory>> getCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories'));
    if (res.statusCode != 200) throw Exception('Gagal mengambil kategori');
    final List data = jsonDecode(res.body)['data'];
    return data.map((json) => PostCategory.fromJson(json)).toList();
  }

  // create/update sengaja return void: backend cuma balikin {success, message},
  // bukan data artikelnya. Jadi setelah manggil ini, panggil getPosts() lagi
  // buat ambil data terbaru (lihat PostProvider) yhh
  Future<void> createPost({
    required String title,
    required String content,
    int? categoryId,
    String? imageUrl,
    String status = 'published',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'status': status,
      }),
    );
    if (res.statusCode != 201) throw Exception('Gagal membuat artikel');
  }

  Future<void> updatePost({
    required int id,
    required String title,
    required String content,
    int? categoryId,
    String? imageUrl,
    String status = 'published',
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'status': status,
      }),
    );
    if (res.statusCode != 200) throw Exception('Gagal memperbarui artikel');
  }

  Future<void> deletePost(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (res.statusCode != 204) throw Exception('Gagal menghapus artikel');
  }
}