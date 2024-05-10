class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createDate;
  final String authorName;
  final int commentCount;
  final int likeCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createDate,
    required this.authorName,
    required this.commentCount,
    required this.likeCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createDate: DateTime.parse(json['createDate']),
      authorName: json['author']['username'],
      commentCount: json['commentCount'],
      likeCount: json['likeCount'],
    );
  }
}
