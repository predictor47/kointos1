/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;

/** This is an auto generated class representing the UserProfile type in your schema. */
class UserProfile extends amplify_core.Model {
  static const classType = const _UserProfileModelType();
  final String id;
  final String? _userId;
  final String? _email;
  final String? _username;
  final String? _displayName;
  final String? _bio;
  final String? _profilePicture;
  final double? _totalPortfolioValue;
  final int? _followersCount;
  final int? _followingCount;
  final bool? _isPublic;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  UserProfileModelIdentifier get modelIdentifier {
    return UserProfileModelIdentifier(id: id);
  }

  String get userId {
    try {
      return _userId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get email {
    try {
      return _email!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get username {
    try {
      return _username!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get displayName {
    return _displayName;
  }

  String? get bio {
    return _bio;
  }

  String? get profilePicture {
    return _profilePicture;
  }

  double? get totalPortfolioValue {
    return _totalPortfolioValue;
  }

  int? get followersCount {
    return _followersCount;
  }

  int? get followingCount {
    return _followingCount;
  }

  bool? get isPublic {
    return _isPublic;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const UserProfile._internal(
      {required this.id,
      required userId,
      required email,
      required username,
      displayName,
      bio,
      profilePicture,
      totalPortfolioValue,
      followersCount,
      followingCount,
      isPublic,
      createdAt,
      updatedAt})
      : _userId = userId,
        _email = email,
        _username = username,
        _displayName = displayName,
        _bio = bio,
        _profilePicture = profilePicture,
        _totalPortfolioValue = totalPortfolioValue,
        _followersCount = followersCount,
        _followingCount = followingCount,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory UserProfile(
      {String? id,
      required String userId,
      required String email,
      required String username,
      String? displayName,
      String? bio,
      String? profilePicture,
      double? totalPortfolioValue,
      int? followersCount,
      int? followingCount,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return UserProfile._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        email: email,
        username: username,
        displayName: displayName,
        bio: bio,
        profilePicture: profilePicture,
        totalPortfolioValue: totalPortfolioValue,
        followersCount: followersCount,
        followingCount: followingCount,
        isPublic: isPublic,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        id == other.id &&
        _userId == other._userId &&
        _email == other._email &&
        _username == other._username &&
        _displayName == other._displayName &&
        _bio == other._bio &&
        _profilePicture == other._profilePicture &&
        _totalPortfolioValue == other._totalPortfolioValue &&
        _followersCount == other._followersCount &&
        _followingCount == other._followingCount &&
        _isPublic == other._isPublic &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("UserProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("username=" + "$_username" + ", ");
    buffer.write("displayName=" + "$_displayName" + ", ");
    buffer.write("bio=" + "$_bio" + ", ");
    buffer.write("profilePicture=" + "$_profilePicture" + ", ");
    buffer.write("totalPortfolioValue=" +
        (_totalPortfolioValue != null
            ? _totalPortfolioValue.toString()
            : "null") +
        ", ");
    buffer.write("followersCount=" +
        (_followersCount != null ? _followersCount.toString() : "null") +
        ", ");
    buffer.write("followingCount=" +
        (_followingCount != null ? _followingCount.toString() : "null") +
        ", ");
    buffer.write("isPublic=" +
        (_isPublic != null ? _isPublic.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  UserProfile copyWith(
      {String? userId,
      String? email,
      String? username,
      String? displayName,
      String? bio,
      String? profilePicture,
      double? totalPortfolioValue,
      int? followersCount,
      int? followingCount,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return UserProfile._internal(
        id: id,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        bio: bio ?? this.bio,
        profilePicture: profilePicture ?? this.profilePicture,
        totalPortfolioValue: totalPortfolioValue ?? this.totalPortfolioValue,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount,
        isPublic: isPublic ?? this.isPublic,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  UserProfile copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? email,
      ModelFieldValue<String>? username,
      ModelFieldValue<String?>? displayName,
      ModelFieldValue<String?>? bio,
      ModelFieldValue<String?>? profilePicture,
      ModelFieldValue<double?>? totalPortfolioValue,
      ModelFieldValue<int?>? followersCount,
      ModelFieldValue<int?>? followingCount,
      ModelFieldValue<bool?>? isPublic,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return UserProfile._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        email: email == null ? this.email : email.value,
        username: username == null ? this.username : username.value,
        displayName: displayName == null ? this.displayName : displayName.value,
        bio: bio == null ? this.bio : bio.value,
        profilePicture:
            profilePicture == null ? this.profilePicture : profilePicture.value,
        totalPortfolioValue: totalPortfolioValue == null
            ? this.totalPortfolioValue
            : totalPortfolioValue.value,
        followersCount:
            followersCount == null ? this.followersCount : followersCount.value,
        followingCount:
            followingCount == null ? this.followingCount : followingCount.value,
        isPublic: isPublic == null ? this.isPublic : isPublic.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  UserProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _email = json['email'],
        _username = json['username'],
        _displayName = json['displayName'],
        _bio = json['bio'],
        _profilePicture = json['profilePicture'],
        _totalPortfolioValue =
            (json['totalPortfolioValue'] as num?)?.toDouble(),
        _followersCount = (json['followersCount'] as num?)?.toInt(),
        _followingCount = (json['followingCount'] as num?)?.toInt(),
        _isPublic = json['isPublic'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'email': _email,
        'username': _username,
        'displayName': _displayName,
        'bio': _bio,
        'profilePicture': _profilePicture,
        'totalPortfolioValue': _totalPortfolioValue,
        'followersCount': _followersCount,
        'followingCount': _followingCount,
        'isPublic': _isPublic,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'email': _email,
        'username': _username,
        'displayName': _displayName,
        'bio': _bio,
        'profilePicture': _profilePicture,
        'totalPortfolioValue': _totalPortfolioValue,
        'followersCount': _followersCount,
        'followingCount': _followingCount,
        'isPublic': _isPublic,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<UserProfileModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<UserProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final USERNAME = amplify_core.QueryField(fieldName: "username");
  static final DISPLAYNAME = amplify_core.QueryField(fieldName: "displayName");
  static final BIO = amplify_core.QueryField(fieldName: "bio");
  static final PROFILEPICTURE =
      amplify_core.QueryField(fieldName: "profilePicture");
  static final TOTALPORTFOLIOVALUE =
      amplify_core.QueryField(fieldName: "totalPortfolioValue");
  static final FOLLOWERSCOUNT =
      amplify_core.QueryField(fieldName: "followersCount");
  static final FOLLOWINGCOUNT =
      amplify_core.QueryField(fieldName: "followingCount");
  static final ISPUBLIC = amplify_core.QueryField(fieldName: "isPublic");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserProfile";
    modelSchemaDefinition.pluralName = "UserProfiles";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: amplify_core.AuthRuleProvider.USERPOOLS,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.EMAIL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.USERNAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.DISPLAYNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.BIO,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.PROFILEPICTURE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.TOTALPORTFOLIOVALUE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.FOLLOWERSCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.FOLLOWINGCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.ISPUBLIC,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserProfile.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _UserProfileModelType extends amplify_core.ModelType<UserProfile> {
  const _UserProfileModelType();

  @override
  UserProfile fromJson(Map<String, dynamic> jsonData) {
    return UserProfile.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'UserProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserProfile] in your schema.
 */
class UserProfileModelIdentifier
    implements amplify_core.ModelIdentifier<UserProfile> {
  final String id;

  /** Create an instance of UserProfileModelIdentifier using [id] the primary key. */
  const UserProfileModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'UserProfileModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserProfileModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
