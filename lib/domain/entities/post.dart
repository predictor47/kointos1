enum PostType {
  text,
  image,
  article,
}

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final List<String> images;
  final PostType type;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.tags,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.images = const [],
    this.type = PostType.text,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String,
      content: json['content'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      images: List<String>.from(json['images'] ?? []),
      type: PostType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PostType.text,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'images': images,
      'type': type.toString(),
    };
  }

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    List<String>? tags,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    List<String>? images,
    PostType? type,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      images: images ?? this.images,
      type: type ?? this.type,
    );
  }

  factory Post.mock() {
    return Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: 'mock_user_id',
      authorName: 'Mock User',
      authorAvatar: '',
      content: 'This is a mock post content.',
      tags: ['mock', 'test'],
      createdAt: DateTime.now(),
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
      images: [],
      type: PostType.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
