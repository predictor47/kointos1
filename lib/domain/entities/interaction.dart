enum InteractionType {
  like,
  comment,
  follow,
}

class Interaction {
  final String id;
  final InteractionType type;
  final String userId;
  final String targetId;
  final String? content;
  final DateTime createdAt;

  Interaction({
    required this.id,
    required this.type,
    required this.userId,
    required this.targetId,
    this.content,
    required this.createdAt,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      id: json['id'],
      type: _parseType(json['type']),
      userId: json['userId'],
      targetId: json['targetId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static InteractionType _parseType(String? type) {
    switch (type) {
      case 'like':
        return InteractionType.like;
      case 'comment':
        return InteractionType.comment;
      case 'follow':
        return InteractionType.follow;
      default:
        return InteractionType.like;
    }
  }

  static String typeToString(InteractionType type) {
    switch (type) {
      case InteractionType.like:
        return 'like';
      case InteractionType.comment:
        return 'comment';
      case InteractionType.follow:
        return 'follow';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': typeToString(type),
      'userId': userId,
      'targetId': targetId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Interaction copyWith({
    String? id,
    InteractionType? type,
    String? userId,
    String? targetId,
    String? content,
    DateTime? createdAt,
  }) {
    return Interaction(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      targetId: targetId ?? this.targetId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
