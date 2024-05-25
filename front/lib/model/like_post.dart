class LikePost {
  final int id;
  final String title;
  final String content;
  final String category;
  final int likeCount;
  final String authorName;
  final DateTime createDate;
  final int commentCount;

  LikePost({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
    required this.authorName,
    required this.createDate,
    required this.commentCount,
  });

  factory LikePost.fromJson(Map<String, dynamic> json) {
    return LikePost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      likeCount: json['likeCount'],
      authorName: json['author']['username'],
      createDate: DateTime.parse(json['createDate']),
      commentCount: (json['commentDTOList'] as List).length,
    );
  }
}
