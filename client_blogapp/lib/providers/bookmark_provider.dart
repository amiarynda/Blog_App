import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../services/bookmark_service.dart';
import '../utils/reading_time.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkService _service = BookmarkService();

  Set<int> bookmarkedIds = {};
  int articlesRead = 0;
  int minutesRead = 0;

  Future<void> loadBookmarks() async {
    bookmarkedIds = await _service.getBookmarks();
    await _refreshStats();
  }

  bool isBookmarked(int postId) => bookmarkedIds.contains(postId);

  Future<void> toggle(int postId) async {
    bookmarkedIds = await _service.toggleBookmark(postId);
    notifyListeners();
  }

  Future<void> recordRead(Post post) async {
    final minutes = calculateReadingMinutes(post.content);
    await _service.recordRead(post.id, minutes);
    await _refreshStats();
  }

  Future<void> _refreshStats() async {
    final stats = await _service.getStats();
    articlesRead = stats['articlesRead'] ?? 0;
    minutesRead = stats['minutesRead'] ?? 0;
    notifyListeners();
  }
}
