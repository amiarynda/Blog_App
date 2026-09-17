import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const _bookmarkKey = 'bookmarked_post_ids';
  static const _readIdsKey = 'stat_read_ids';
  static const _readCountKey = 'stat_read_count';
  static const _readMinutesKey = 'stat_read_minutes';

  Future<Set<int>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_bookmarkKey) ?? []).map(int.parse).toSet();
  }

  Future<Set<int>> toggleBookmark(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_bookmarkKey) ?? []).map(int.parse).toSet();
    if (!ids.add(postId)) ids.remove(postId);
    await prefs.setStringList(_bookmarkKey, ids.map((e) => e.toString()).toList());
    return ids;
  }

  // Hanya dihitung sekali per artikel, supaya stats tidak membengkak
  // setiap kali user buka ulang artikel yang sama.
  Future<void> recordRead(int postId, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final readIds = prefs.getStringList(_readIdsKey) ?? [];
    final idStr = postId.toString();
    if (!readIds.contains(idStr)) {
      readIds.add(idStr);
      await prefs.setStringList(_readIdsKey, readIds);
      await prefs.setInt(_readCountKey, readIds.length);
      final currentMinutes = prefs.getInt(_readMinutesKey) ?? 0;
      await prefs.setInt(_readMinutesKey, currentMinutes + minutes);
    }
  }

  Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'articlesRead': prefs.getInt(_readCountKey) ?? 0,
      'minutesRead': prefs.getInt(_readMinutesKey) ?? 0,
    };
  }
}
