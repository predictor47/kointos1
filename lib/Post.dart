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
import 'package:collection/collection.dart';

/** This is an auto generated class representing the Post type in your schema. */
class Post extends amplify_core.Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _userId;
  final String? _content;
  final String? _imageUrl;
  final int? _likesCount;
  final int? _commentsCount;
  final int? _sharesCount;
  final List<String>? _tags;
  final List<String>? _mentionedCryptos;
  final bool? _isPublic;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PostModelIdentifier get modelIdentifier {
    return PostModelIdentifier(id: id);
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

  String get content {
    try {
      return _content!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get imageUrl {
    return _imageUrl;
  }

  int? get likesCount {
    return _likesCount;
  }

  int? get commentsCount {
    return _commentsCount;
  }

  int? get sharesCount {
    return _sharesCount;
  }

  List<String>? get tags {
    return _tags;
  }

  List<String>? get mentionedCryptos {
    return _mentionedCryptos;
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

  const Post._internal(
      {required this.id,
      required userId,
      required content,
      imageUrl,
      likesCount,
      commentsCount,
      sharesCount,
      tags,
      mentionedCryptos,
      isPublic,
      createdAt,
      updatedAt})
      : _userId = userId,
        _content = content,
        _imageUrl = imageUrl,
        _likesCount = likesCount,
        _commentsCount = commentsCount,
        _sharesCount = sharesCount,
        _tags = tags,
        _mentionedCryptos = mentionedCryptos,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Post(
      {String? id,
      required String userId,
      required String content,
      String? imageUrl,
      int? likesCount,
      int? commentsCount,
      int? sharesCount,
      List<String>? tags,
      List<String>? mentionedCryptos,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Post._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        content: content,
        imageUrl: imageUrl,
        likesCount: likesCount,
        commentsCount: commentsCount,
        sharesCount: sharesCount,
        tags: tags != null ? List<String>.unmodifiable(tags) : tags,
        mentionedCryptos: mentionedCryptos != null
            ? List<String>.unmodifiable(mentionedCryptos)
            : mentionedCryptos,
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
    return other is Post &&
        id == other.id &&
        _userId == other._userId &&
        _content == other._content &&
        _imageUrl == other._imageUrl &&
        _likesCount == other._likesCount &&
        _commentsCount == other._commentsCount &&
        _sharesCount == other._sharesCount &&
        DeepCollectionEquality().equals(_tags, other._tags) &&
        DeepCollectionEquality()
            .equals(_mentionedCryptos, other._mentionedCryptos) &&
        _isPublic == other._isPublic &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("likesCount=" +
        (_likesCount != null ? _likesCount.toString() : "null") +
        ", ");
    buffer.write("commentsCount=" +
        (_commentsCount != null ? _commentsCount.toString() : "null") +
        ", ");
    buffer.write("sharesCount=" +
        (_sharesCount != null ? _sharesCount.toString() : "null") +
        ", ");
    buffer.write("tags=" + (_tags != null ? _tags.toString() : "null") + ", ");
    buffer.write("mentionedCryptos=" +
        (_mentionedCryptos != null ? _mentionedCryptos.toString() : "null") +
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

  Post copyWith(
      {String? userId,
      String? content,
      String? imageUrl,
      int? likesCount,
      int? commentsCount,
      int? sharesCount,
      List<String>? tags,
      List<String>? mentionedCryptos,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Post._internal(
        id: id,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        sharesCount: sharesCount ?? this.sharesCount,
        tags: tags ?? this.tags,
        mentionedCryptos: mentionedCryptos ?? this.mentionedCryptos,
        isPublic: isPublic ?? this.isPublic,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Post copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? content,
      ModelFieldValue<String?>? imageUrl,
      ModelFieldValue<int?>? likesCount,
      ModelFieldValue<int?>? commentsCount,
      ModelFieldValue<int?>? sharesCount,
      ModelFieldValue<List<String>?>? tags,
      ModelFieldValue<List<String>?>? mentionedCryptos,
      ModelFieldValue<bool?>? isPublic,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return Post._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        content: content == null ? this.content : content.value,
        imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
        likesCount: likesCount == null ? this.likesCount : likesCount.value,
        commentsCount:
            commentsCount == null ? this.commentsCount : commentsCount.value,
        sharesCount: sharesCount == null ? this.sharesCount : sharesCount.value,
        tags: tags == null ? this.tags : tags.value,
        mentionedCryptos: mentionedCryptos == null
            ? this.mentionedCryptos
            : mentionedCryptos.value,
        isPublic: isPublic == null ? this.isPublic : isPublic.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _content = json['content'],
        _imageUrl = json['imageUrl'],
        _likesCount = (json['likesCount'] as num?)?.toInt(),
        _commentsCount = (json['commentsCount'] as num?)?.toInt(),
        _sharesCount = (json['sharesCount'] as num?)?.toInt(),
        _tags = json['tags']?.cast<String>(),
        _mentionedCryptos = json['mentionedCryptos']?.cast<String>(),
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
        'content': _content,
        'imageUrl': _imageUrl,
        'likesCount': _likesCount,
        'commentsCount': _commentsCount,
        'sharesCount': _sharesCount,
        'tags': _tags,
        'mentionedCryptos': _mentionedCryptos,
        'isPublic': _isPublic,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'content': _content,
        'imageUrl': _imageUrl,
        'likesCount': _likesCount,
        'commentsCount': _commentsCount,
        'sharesCount': _sharesCount,
        'tags': _tags,
        'mentionedCryptos': _mentionedCryptos,
        'isPublic': _isPublic,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<PostModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PostModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final LIKESCOUNT = amplify_core.QueryField(fieldName: "likesCount");
  static final COMMENTSCOUNT =
      amplify_core.QueryField(fieldName: "commentsCount");
  static final SHARESCOUNT = amplify_core.QueryField(fieldName: "sharesCount");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final MENTIONEDCRYPTOS =
      amplify_core.QueryField(fieldName: "mentionedCryptos");
  static final ISPUBLIC = amplify_core.QueryField(fieldName: "isPublic");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";

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
          ]),
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PRIVATE,
          operations: const [amplify_core.ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.CONTENT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.IMAGEURL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.LIKESCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.COMMENTSCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.SHARESCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.TAGS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.MENTIONEDCRYPTOS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.ISPUBLIC,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Post.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _PostModelType extends amplify_core.ModelType<Post> {
  const _PostModelType();

  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Post';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Post] in your schema.
 */
class PostModelIdentifier implements amplify_core.ModelIdentifier<Post> {
  final String id;

  /** Create an instance of PostModelIdentifier using [id] the primary key. */
  const PostModelIdentifier({required this.id});

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
  String toString() => 'PostModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PostModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
