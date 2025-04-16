import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? profileImageUrl;
  final String? bio;
  final int points;
  final int level;
  final List<String> badges;
  final List<String> following;
  final int followersCount;
  final int followingCount;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime lastActive;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.profileImageUrl,
    this.bio,
    this.points = 0,
    this.level = 1,
    this.badges = const [],
    this.following = const [],
    this.followersCount = 0,
    this.followingCount = 0,
    DateTime? createdAt,
    DateTime? lastActive,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastActive = lastActive ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static DateTime _dateTimeFromJson(dynamic json) =>
      json is String ? DateTime.parse(json) : DateTime.now();

  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? profileImageUrl,
    String? bio,
    int? points,
    int? level,
    List<String>? badges,
    List<String>? following,
    int? followersCount,
    int? followingCount,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      following: following ?? this.following,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
