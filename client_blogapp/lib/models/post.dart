import '../utils/reading_time.dart';

class Post {
  final int id;
  final int? categoryId;
  final String title;
  final String content;
  final String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    required this.id,
    this.categoryId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.status = 'published',
    this.createdAt,
    this.updatedAt,
  });

  String get readingTime => '${calculateReadingMinutes(content)} min baca';


  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        categoryId: json['categoryId'] as int?,
        title: json['title'] as String,
        content: json['content'] as String,
        imageUrl: json['imageUrl'] as String?,
        status: (json['status'] as String?) ?? 'published',
        createdAt:
            json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
        updatedAt:
            json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'status': status,
      };
}
