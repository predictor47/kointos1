// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      points: json['points'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      createdAt: User._dateTimeFromJson(json['createdAt']),
      lastActive: User._dateTimeFromJson(json['lastActive']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'points': instance.points,
      'level': instance.level,
      'badges': instance.badges,
      'following': instance.following,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'createdAt': User._dateTimeToJson(instance.createdAt),
      'lastActive': User._dateTimeToJson(instance.lastActive),
    };
