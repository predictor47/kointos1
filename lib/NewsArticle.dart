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

/** This is an auto generated class representing the NewsArticle type in your schema. */
class NewsArticle extends amplify_core.Model {
  static const classType = const _NewsArticleModelType();
  final String id;
  final String? _title;
  final String? _content;
  final String? _summary;
  final String? _author;
  final String? _sourceUrl;
  final String? _imageUrl;
  final amplify_core.TemporalDateTime? _publishedAt;
  final List<String>? _tags;
  final List<String>? _mentionedCryptos;
  final NewsArticleSentiment? _sentiment;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  NewsArticleModelIdentifier get modelIdentifier {
    return NewsArticleModelIdentifier(id: id);
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

  String? get summary {
    return _summary;
  }

  String? get author {
    return _author;
  }

  String? get sourceUrl {
    return _sourceUrl;
  }

  String? get imageUrl {
    return _imageUrl;
  }

  amplify_core.TemporalDateTime? get publishedAt {
    return _publishedAt;
  }

  List<String>? get tags {
    return _tags;
  }

  List<String>? get mentionedCryptos {
    return _mentionedCryptos;
  }

  NewsArticleSentiment? get sentiment {
    return _sentiment;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const NewsArticle._internal(
      {required this.id,
      required title,
      required content,
      summary,
      author,
      sourceUrl,
      imageUrl,
      publishedAt,
      tags,
      mentionedCryptos,
      sentiment,
      createdAt,
      updatedAt})
      : _title = title,
        _content = content,
        _summary = summary,
        _author = author,
        _sourceUrl = sourceUrl,
        _imageUrl = imageUrl,
        _publishedAt = publishedAt,
        _tags = tags,
        _mentionedCryptos = mentionedCryptos,
        _sentiment = sentiment,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory NewsArticle(
      {String? id,
      required String title,
      required String content,
      String? summary,
      String? author,
      String? sourceUrl,
      String? imageUrl,
      amplify_core.TemporalDateTime? publishedAt,
      List<String>? tags,
      List<String>? mentionedCryptos,
      NewsArticleSentiment? sentiment,
      amplify_core.TemporalDateTime? createdAt}) {
    return NewsArticle._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        title: title,
        content: content,
        summary: summary,
        author: author,
        sourceUrl: sourceUrl,
        imageUrl: imageUrl,
        publishedAt: publishedAt,
        tags: tags != null ? List<String>.unmodifiable(tags) : tags,
        mentionedCryptos: mentionedCryptos != null
            ? List<String>.unmodifiable(mentionedCryptos)
            : mentionedCryptos,
        sentiment: sentiment,
        createdAt: createdAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewsArticle &&
        id == other.id &&
        _title == other._title &&
        _content == other._content &&
        _summary == other._summary &&
        _author == other._author &&
        _sourceUrl == other._sourceUrl &&
        _imageUrl == other._imageUrl &&
        _publishedAt == other._publishedAt &&
        DeepCollectionEquality().equals(_tags, other._tags) &&
        DeepCollectionEquality()
            .equals(_mentionedCryptos, other._mentionedCryptos) &&
        _sentiment == other._sentiment &&
        _createdAt == other._createdAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("NewsArticle {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("summary=" + "$_summary" + ", ");
    buffer.write("author=" + "$_author" + ", ");
    buffer.write("sourceUrl=" + "$_sourceUrl" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("publishedAt=" +
        (_publishedAt != null ? _publishedAt.format() : "null") +
        ", ");
    buffer.write("tags=" + (_tags != null ? _tags.toString() : "null") + ", ");
    buffer.write("mentionedCryptos=" +
        (_mentionedCryptos != null ? _mentionedCryptos.toString() : "null") +
        ", ");
    buffer.write("sentiment=" +
        (_sentiment != null ? amplify_core.enumToString(_sentiment)! : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  NewsArticle copyWith(
      {String? title,
      String? content,
      String? summary,
      String? author,
      String? sourceUrl,
      String? imageUrl,
      amplify_core.TemporalDateTime? publishedAt,
      List<String>? tags,
      List<String>? mentionedCryptos,
      NewsArticleSentiment? sentiment,
      amplify_core.TemporalDateTime? createdAt}) {
    return NewsArticle._internal(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        summary: summary ?? this.summary,
        author: author ?? this.author,
        sourceUrl: sourceUrl ?? this.sourceUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        publishedAt: publishedAt ?? this.publishedAt,
        tags: tags ?? this.tags,
        mentionedCryptos: mentionedCryptos ?? this.mentionedCryptos,
        sentiment: sentiment ?? this.sentiment,
        createdAt: createdAt ?? this.createdAt);
  }

  NewsArticle copyWithModelFieldValues(
      {ModelFieldValue<String>? title,
      ModelFieldValue<String>? content,
      ModelFieldValue<String?>? summary,
      ModelFieldValue<String?>? author,
      ModelFieldValue<String?>? sourceUrl,
      ModelFieldValue<String?>? imageUrl,
      ModelFieldValue<amplify_core.TemporalDateTime?>? publishedAt,
      ModelFieldValue<List<String>?>? tags,
      ModelFieldValue<List<String>?>? mentionedCryptos,
      ModelFieldValue<NewsArticleSentiment?>? sentiment,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt}) {
    return NewsArticle._internal(
        id: id,
        title: title == null ? this.title : title.value,
        content: content == null ? this.content : content.value,
        summary: summary == null ? this.summary : summary.value,
        author: author == null ? this.author : author.value,
        sourceUrl: sourceUrl == null ? this.sourceUrl : sourceUrl.value,
        imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
        publishedAt: publishedAt == null ? this.publishedAt : publishedAt.value,
        tags: tags == null ? this.tags : tags.value,
        mentionedCryptos: mentionedCryptos == null
            ? this.mentionedCryptos
            : mentionedCryptos.value,
        sentiment: sentiment == null ? this.sentiment : sentiment.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value);
  }

  NewsArticle.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _title = json['title'],
        _content = json['content'],
        _summary = json['summary'],
        _author = json['author'],
        _sourceUrl = json['sourceUrl'],
        _imageUrl = json['imageUrl'],
        _publishedAt = json['publishedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['publishedAt'])
            : null,
        _tags = json['tags']?.cast<String>(),
        _mentionedCryptos = json['mentionedCryptos']?.cast<String>(),
        _sentiment = amplify_core.enumFromString<NewsArticleSentiment>(
            json['sentiment'], NewsArticleSentiment.values),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': _title,
        'content': _content,
        'summary': _summary,
        'author': _author,
        'sourceUrl': _sourceUrl,
        'imageUrl': _imageUrl,
        'publishedAt': _publishedAt?.format(),
        'tags': _tags,
        'mentionedCryptos': _mentionedCryptos,
        'sentiment': amplify_core.enumToString(_sentiment),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'title': _title,
        'content': _content,
        'summary': _summary,
        'author': _author,
        'sourceUrl': _sourceUrl,
        'imageUrl': _imageUrl,
        'publishedAt': _publishedAt,
        'tags': _tags,
        'mentionedCryptos': _mentionedCryptos,
        'sentiment': _sentiment,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<NewsArticleModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<NewsArticleModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final SUMMARY = amplify_core.QueryField(fieldName: "summary");
  static final AUTHOR = amplify_core.QueryField(fieldName: "author");
  static final SOURCEURL = amplify_core.QueryField(fieldName: "sourceUrl");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final PUBLISHEDAT = amplify_core.QueryField(fieldName: "publishedAt");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final MENTIONEDCRYPTOS =
      amplify_core.QueryField(fieldName: "mentionedCryptos");
  static final SENTIMENT = amplify_core.QueryField(fieldName: "sentiment");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "NewsArticle";
    modelSchemaDefinition.pluralName = "NewsArticles";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PRIVATE,
          operations: const [amplify_core.ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.TITLE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.CONTENT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.SUMMARY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.AUTHOR,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.SOURCEURL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.IMAGEURL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.PUBLISHEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.TAGS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.MENTIONEDCRYPTOS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.SENTIMENT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: NewsArticle.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'updatedAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _NewsArticleModelType extends amplify_core.ModelType<NewsArticle> {
  const _NewsArticleModelType();

  @override
  NewsArticle fromJson(Map<String, dynamic> jsonData) {
    return NewsArticle.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'NewsArticle';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [NewsArticle] in your schema.
 */
class NewsArticleModelIdentifier
    implements amplify_core.ModelIdentifier<NewsArticle> {
  final String id;

  /** Create an instance of NewsArticleModelIdentifier using [id] the primary key. */
  const NewsArticleModelIdentifier({required this.id});

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
  String toString() => 'NewsArticleModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NewsArticleModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
