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

/** This is an auto generated class representing the Article type in your schema. */
class Article extends amplify_core.Model {
  static const classType = const _ArticleModelType();
  final String id;
  final String? _authorId;
  final String? _authorName;
  final String? _title;
  final String? _content;
  final String? _summary;
  final String? _coverImageUrl;
  final String? _contentKey;
  final List<String>? _tags;
  final List<String>? _images;
  final ArticleStatus? _status;
  final int? _likesCount;
  final int? _commentsCount;
  final int? _viewsCount;
  final bool? _isPublic;
  final amplify_core.TemporalDateTime? _publishedAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  ArticleModelIdentifier get modelIdentifier {
    return ArticleModelIdentifier(id: id);
  }

  String get authorId {
    try {
      return _authorId!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get authorName {
    try {
      return _authorName!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get title {
    try {
      return _title!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get content {
    return _content;
  }

  String? get summary {
    return _summary;
  }

  String? get coverImageUrl {
    return _coverImageUrl;
  }

  String get contentKey {
    try {
      return _contentKey!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String>? get tags {
    return _tags;
  }

  List<String>? get images {
    return _images;
  }

  ArticleStatus? get status {
    return _status;
  }

  int? get likesCount {
    return _likesCount;
  }

  int? get commentsCount {
    return _commentsCount;
  }

  int? get viewsCount {
    return _viewsCount;
  }

  bool? get isPublic {
    return _isPublic;
  }

  amplify_core.TemporalDateTime? get publishedAt {
    return _publishedAt;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Article._internal(
      {required this.id,
      required authorId,
      required authorName,
      required title,
      content,
      summary,
      coverImageUrl,
      required contentKey,
      tags,
      images,
      status,
      likesCount,
      commentsCount,
      viewsCount,
      isPublic,
      publishedAt,
      createdAt,
      updatedAt})
      : _authorId = authorId,
        _authorName = authorName,
        _title = title,
        _content = content,
        _summary = summary,
        _coverImageUrl = coverImageUrl,
        _contentKey = contentKey,
        _tags = tags,
        _images = images,
        _status = status,
        _likesCount = likesCount,
        _commentsCount = commentsCount,
        _viewsCount = viewsCount,
        _isPublic = isPublic,
        _publishedAt = publishedAt,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Article(
      {String? id,
      required String authorId,
      required String authorName,
      required String title,
      String? content,
      String? summary,
      String? coverImageUrl,
      required String contentKey,
      List<String>? tags,
      List<String>? images,
      ArticleStatus? status,
      int? likesCount,
      int? commentsCount,
      int? viewsCount,
      bool? isPublic,
      amplify_core.TemporalDateTime? publishedAt,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Article._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        authorId: authorId,
        authorName: authorName,
        title: title,
        content: content,
        summary: summary,
        coverImageUrl: coverImageUrl,
        contentKey: contentKey,
        tags: tags != null ? List<String>.unmodifiable(tags) : tags,
        images: images != null ? List<String>.unmodifiable(images) : images,
        status: status,
        likesCount: likesCount,
        commentsCount: commentsCount,
        viewsCount: viewsCount,
        isPublic: isPublic,
        publishedAt: publishedAt,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Article &&
        id == other.id &&
        _authorId == other._authorId &&
        _authorName == other._authorName &&
        _title == other._title &&
        _content == other._content &&
        _summary == other._summary &&
        _coverImageUrl == other._coverImageUrl &&
        _contentKey == other._contentKey &&
        DeepCollectionEquality().equals(_tags, other._tags) &&
        DeepCollectionEquality().equals(_images, other._images) &&
        _status == other._status &&
        _likesCount == other._likesCount &&
        _commentsCount == other._commentsCount &&
        _viewsCount == other._viewsCount &&
        _isPublic == other._isPublic &&
        _publishedAt == other._publishedAt &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Article {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("authorId=" + "$_authorId" + ", ");
    buffer.write("authorName=" + "$_authorName" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("summary=" + "$_summary" + ", ");
    buffer.write("coverImageUrl=" + "$_coverImageUrl" + ", ");
    buffer.write("contentKey=" + "$_contentKey" + ", ");
    buffer.write("tags=" + (_tags != null ? _tags.toString() : "null") + ", ");
    buffer.write(
        "images=" + (_images != null ? _images.toString() : "null") + ", ");
    buffer.write("status=" +
        (_status != null ? amplify_core.enumToString(_status)! : "null") +
        ", ");
    buffer.write("likesCount=" +
        (_likesCount != null ? _likesCount.toString() : "null") +
        ", ");
    buffer.write("commentsCount=" +
        (_commentsCount != null ? _commentsCount.toString() : "null") +
        ", ");
    buffer.write("viewsCount=" +
        (_viewsCount != null ? _viewsCount.toString() : "null") +
        ", ");
    buffer.write("isPublic=" +
        (_isPublic != null ? _isPublic.toString() : "null") +
        ", ");
    buffer.write("publishedAt=" +
        (_publishedAt != null ? _publishedAt.format() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Article copyWith(
      {String? authorId,
      String? authorName,
      String? title,
      String? content,
      String? summary,
      String? coverImageUrl,
      String? contentKey,
      List<String>? tags,
      List<String>? images,
      ArticleStatus? status,
      int? likesCount,
      int? commentsCount,
      int? viewsCount,
      bool? isPublic,
      amplify_core.TemporalDateTime? publishedAt,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Article._internal(
        id: id,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        title: title ?? this.title,
        content: content ?? this.content,
        summary: summary ?? this.summary,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        contentKey: contentKey ?? this.contentKey,
        tags: tags ?? this.tags,
        images: images ?? this.images,
        status: status ?? this.status,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        viewsCount: viewsCount ?? this.viewsCount,
        isPublic: isPublic ?? this.isPublic,
        publishedAt: publishedAt ?? this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Article copyWithModelFieldValues(
      {ModelFieldValue<String>? authorId,
      ModelFieldValue<String>? authorName,
      ModelFieldValue<String>? title,
      ModelFieldValue<String?>? content,
      ModelFieldValue<String?>? summary,
      ModelFieldValue<String?>? coverImageUrl,
      ModelFieldValue<String>? contentKey,
      ModelFieldValue<List<String>?>? tags,
      ModelFieldValue<List<String>?>? images,
      ModelFieldValue<ArticleStatus?>? status,
      ModelFieldValue<int?>? likesCount,
      ModelFieldValue<int?>? commentsCount,
      ModelFieldValue<int?>? viewsCount,
      ModelFieldValue<bool?>? isPublic,
      ModelFieldValue<amplify_core.TemporalDateTime?>? publishedAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return Article._internal(
        id: id,
        authorId: authorId == null ? this.authorId : authorId.value,
        authorName: authorName == null ? this.authorName : authorName.value,
        title: title == null ? this.title : title.value,
        content: content == null ? this.content : content.value,
        summary: summary == null ? this.summary : summary.value,
        coverImageUrl:
            coverImageUrl == null ? this.coverImageUrl : coverImageUrl.value,
        contentKey: contentKey == null ? this.contentKey : contentKey.value,
        tags: tags == null ? this.tags : tags.value,
        images: images == null ? this.images : images.value,
        status: status == null ? this.status : status.value,
        likesCount: likesCount == null ? this.likesCount : likesCount.value,
        commentsCount:
            commentsCount == null ? this.commentsCount : commentsCount.value,
        viewsCount: viewsCount == null ? this.viewsCount : viewsCount.value,
        isPublic: isPublic == null ? this.isPublic : isPublic.value,
        publishedAt: publishedAt == null ? this.publishedAt : publishedAt.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  Article.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _authorId = json['authorId'],
        _authorName = json['authorName'],
        _title = json['title'],
        _content = json['content'],
        _summary = json['summary'],
        _coverImageUrl = json['coverImageUrl'],
        _contentKey = json['contentKey'],
        _tags = json['tags']?.cast<String>(),
        _images = json['images']?.cast<String>(),
        _status = amplify_core.enumFromString<ArticleStatus>(
            json['status'], ArticleStatus.values),
        _likesCount = (json['likesCount'] as num?)?.toInt(),
        _commentsCount = (json['commentsCount'] as num?)?.toInt(),
        _viewsCount = (json['viewsCount'] as num?)?.toInt(),
        _isPublic = json['isPublic'],
        _publishedAt = json['publishedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['publishedAt'])
            : null,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorId': _authorId,
        'authorName': _authorName,
        'title': _title,
        'content': _content,
        'summary': _summary,
        'coverImageUrl': _coverImageUrl,
        'contentKey': _contentKey,
        'tags': _tags,
        'images': _images,
        'status': amplify_core.enumToString(_status),
        'likesCount': _likesCount,
        'commentsCount': _commentsCount,
        'viewsCount': _viewsCount,
        'isPublic': _isPublic,
        'publishedAt': _publishedAt?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'authorId': _authorId,
        'authorName': _authorName,
        'title': _title,
        'content': _content,
        'summary': _summary,
        'coverImageUrl': _coverImageUrl,
        'contentKey': _contentKey,
        'tags': _tags,
        'images': _images,
        'status': _status,
        'likesCount': _likesCount,
        'commentsCount': _commentsCount,
        'viewsCount': _viewsCount,
        'isPublic': _isPublic,
        'publishedAt': _publishedAt,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<ArticleModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<ArticleModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final AUTHORID = amplify_core.QueryField(fieldName: "authorId");
  static final AUTHORNAME = amplify_core.QueryField(fieldName: "authorName");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final SUMMARY = amplify_core.QueryField(fieldName: "summary");
  static final COVERIMAGEURL =
      amplify_core.QueryField(fieldName: "coverImageUrl");
  static final CONTENTKEY = amplify_core.QueryField(fieldName: "contentKey");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final IMAGES = amplify_core.QueryField(fieldName: "images");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final LIKESCOUNT = amplify_core.QueryField(fieldName: "likesCount");
  static final COMMENTSCOUNT =
      amplify_core.QueryField(fieldName: "commentsCount");
  static final VIEWSCOUNT = amplify_core.QueryField(fieldName: "viewsCount");
  static final ISPUBLIC = amplify_core.QueryField(fieldName: "isPublic");
  static final PUBLISHEDAT = amplify_core.QueryField(fieldName: "publishedAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Article";
    modelSchemaDefinition.pluralName = "Articles";

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
        key: Article.AUTHORID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.AUTHORNAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.TITLE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.CONTENT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.SUMMARY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.COVERIMAGEURL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.CONTENTKEY,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.TAGS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.IMAGES,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.STATUS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.LIKESCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.COMMENTSCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.VIEWSCOUNT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.ISPUBLIC,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.PUBLISHEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Article.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _ArticleModelType extends amplify_core.ModelType<Article> {
  const _ArticleModelType();

  @override
  Article fromJson(Map<String, dynamic> jsonData) {
    return Article.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Article';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Article] in your schema.
 */
class ArticleModelIdentifier implements amplify_core.ModelIdentifier<Article> {
  final String id;

  /** Create an instance of ArticleModelIdentifier using [id] the primary key. */
  const ArticleModelIdentifier({required this.id});

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
  String toString() => 'ArticleModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ArticleModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
