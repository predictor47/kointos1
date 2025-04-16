// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      contentKey: json['contentKey'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      status: $enumDecode(_$ArticleStatusEnumMap, json['status']),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'title': instance.title,
      'summary': instance.summary,
      'contentKey': instance.contentKey,
      'images': instance.images,
      'tags': instance.tags,
      'status': _$ArticleStatusEnumMap[instance.status]!,
      'likes': instance.likes,
      'comments': instance.comments,
      'points': instance.points,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ArticleStatusEnumMap = {
  ArticleStatus.draft: 'draft',
  ArticleStatus.published: 'published',
  ArticleStatus.moderation: 'moderation',
  ArticleStatus.rejected: 'rejected',
};
