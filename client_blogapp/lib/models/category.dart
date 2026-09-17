class PostCategory {
  final int id;
  final String name;

  PostCategory({required this.id, required this.name});

  factory PostCategory.fromJson(Map<String, dynamic> json) => PostCategory(
        id: json['id'] as int,
        name: json['name'] as String,
      );
}