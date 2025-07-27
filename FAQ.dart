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

/** This is an auto generated class representing the FAQ type in your schema. */
class FAQ extends amplify_core.Model {
  static const classType = const _FAQModelType();
  final String id;
  final String? _question;
  final String? _answer;
  final String? _category;
  final List<String>? _tags;
  final bool? _isPublished;
  final int? _order;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  FAQModelIdentifier get modelIdentifier {
    return FAQModelIdentifier(id: id);
  }

  String get question {
    try {
      return _question!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get answer {
    try {
      return _answer!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get category {
    return _category;
  }

  List<String>? get tags {
    return _tags;
  }

  bool? get isPublished {
    return _isPublished;
  }

  int? get order {
    return _order;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const FAQ._internal(
      {required this.id,
      required question,
      required answer,
      category,
      tags,
      isPublished,
      order,
      createdAt,
      updatedAt})
      : _question = question,
        _answer = answer,
        _category = category,
        _tags = tags,
        _isPublished = isPublished,
        _order = order,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory FAQ(
      {String? id,
      required String question,
      required String answer,
      String? category,
      List<String>? tags,
      bool? isPublished,
      int? order,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return FAQ._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        question: question,
        answer: answer,
        category: category,
        tags: tags != null ? List<String>.unmodifiable(tags) : tags,
        isPublished: isPublished,
        order: order,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FAQ &&
        id == other.id &&
        _question == other._question &&
        _answer == other._answer &&
        _category == other._category &&
        DeepCollectionEquality().equals(_tags, other._tags) &&
        _isPublished == other._isPublished &&
        _order == other._order &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("FAQ {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("question=" + "$_question" + ", ");
    buffer.write("answer=" + "$_answer" + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("tags=" + (_tags != null ? _tags.toString() : "null") + ", ");
    buffer.write("isPublished=" +
        (_isPublished != null ? _isPublished.toString() : "null") +
        ", ");
    buffer
        .write("order=" + (_order != null ? _order.toString() : "null") + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  FAQ copyWith(
      {String? question,
      String? answer,
      String? category,
      List<String>? tags,
      bool? isPublished,
      int? order,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return FAQ._internal(
        id: id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        category: category ?? this.category,
        tags: tags ?? this.tags,
        isPublished: isPublished ?? this.isPublished,
        order: order ?? this.order,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  FAQ copyWithModelFieldValues(
      {ModelFieldValue<String>? question,
      ModelFieldValue<String>? answer,
      ModelFieldValue<String?>? category,
      ModelFieldValue<List<String>?>? tags,
      ModelFieldValue<bool?>? isPublished,
      ModelFieldValue<int?>? order,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return FAQ._internal(
        id: id,
        question: question == null ? this.question : question.value,
        answer: answer == null ? this.answer : answer.value,
        category: category == null ? this.category : category.value,
        tags: tags == null ? this.tags : tags.value,
        isPublished: isPublished == null ? this.isPublished : isPublished.value,
        order: order == null ? this.order : order.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  FAQ.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _question = json['question'],
        _answer = json['answer'],
        _category = json['category'],
        _tags = json['tags']?.cast<String>(),
        _isPublished = json['isPublished'],
        _order = (json['order'] as num?)?.toInt(),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': _question,
        'answer': _answer,
        'category': _category,
        'tags': _tags,
        'isPublished': _isPublished,
        'order': _order,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'question': _question,
        'answer': _answer,
        'category': _category,
        'tags': _tags,
        'isPublished': _isPublished,
        'order': _order,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<FAQModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<FAQModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final QUESTION = amplify_core.QueryField(fieldName: "question");
  static final ANSWER = amplify_core.QueryField(fieldName: "answer");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final ISPUBLISHED = amplify_core.QueryField(fieldName: "isPublished");
  static final ORDER = amplify_core.QueryField(fieldName: "order");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "FAQ";
    modelSchemaDefinition.pluralName = "FAQS";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PRIVATE,
          operations: const [amplify_core.ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.QUESTION,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.ANSWER,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.CATEGORY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.TAGS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.ISPUBLISHED,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.ORDER,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: FAQ.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _FAQModelType extends amplify_core.ModelType<FAQ> {
  const _FAQModelType();

  @override
  FAQ fromJson(Map<String, dynamic> jsonData) {
    return FAQ.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'FAQ';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [FAQ] in your schema.
 */
class FAQModelIdentifier implements amplify_core.ModelIdentifier<FAQ> {
  final String id;

  /** Create an instance of FAQModelIdentifier using [id] the primary key. */
  const FAQModelIdentifier({required this.id});

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
  String toString() => 'FAQModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FAQModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
