enum ArticleStatus {
  draft,
  published,
  archived,
}

class Article {
  final String id;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final String summary;
  final String? coverImageUrl;
  final List<String> tags;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final ArticleStatus status;
  final String contentKey;

  Article({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.summary,
    this.coverImageUrl,
    required this.tags,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    required this.status,
    required this.contentKey,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      summary: json['summary'] as String,
      coverImageUrl: json['coverImageUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      status: ArticleStatus.values.firstWhere(
        (s) => s.toString() == json['status'],
        orElse: () => ArticleStatus.draft,
      ),
      contentKey: json['contentKey'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'content': content,
      'summary': summary,
      'coverImageUrl': coverImageUrl,
      'tags': tags,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'status': status.toString(),
      'contentKey': contentKey,
    };
  }

  factory Article.draft({
    required String id,
    required String authorId,
    required String authorName,
    String title = '',
    String content = '',
    String summary = '',
    String? coverImageUrl,
    List<String> tags = const [],
    List<String> images = const [],
  }) {
    final now = DateTime.now();
    return Article(
      id: id,
      authorId: authorId,
      authorName: authorName,
      title: title,
      content: content,
      summary: summary,
      coverImageUrl: coverImageUrl,
      tags: tags,
      images: images,
      createdAt: now,
      updatedAt: now,
      status: ArticleStatus.draft,
      contentKey: 'articles/$authorId/$id/content.md',
    );
  }

  Article copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? title,
    String? content,
    String? summary,
    String? coverImageUrl,
    List<String>? tags,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    ArticleStatus? status,
    String? contentKey,
  }) {
    return Article(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      status: status ?? this.status,
      contentKey: contentKey ?? this.contentKey,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
