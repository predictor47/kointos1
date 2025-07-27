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

/** This is an auto generated class representing the SupportTicket type in your schema. */
class SupportTicket extends amplify_core.Model {
  static const classType = const _SupportTicketModelType();
  final String id;
  final String? _userId;
  final String? _subject;
  final String? _description;
  final SupportTicketCategory? _category;
  final SupportTicketPriority? _priority;
  final SupportTicketStatus? _status;
  final List<String>? _attachments;
  final String? _adminNotes;
  final amplify_core.TemporalDateTime? _resolvedAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  SupportTicketModelIdentifier get modelIdentifier {
    return SupportTicketModelIdentifier(id: id);
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

  String get subject {
    try {
      return _subject!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get description {
    try {
      return _description!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  SupportTicketCategory? get category {
    return _category;
  }

  SupportTicketPriority? get priority {
    return _priority;
  }

  SupportTicketStatus? get status {
    return _status;
  }

  List<String>? get attachments {
    return _attachments;
  }

  String? get adminNotes {
    return _adminNotes;
  }

  amplify_core.TemporalDateTime? get resolvedAt {
    return _resolvedAt;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const SupportTicket._internal(
      {required this.id,
      required userId,
      required subject,
      required description,
      category,
      priority,
      status,
      attachments,
      adminNotes,
      resolvedAt,
      createdAt,
      updatedAt})
      : _userId = userId,
        _subject = subject,
        _description = description,
        _category = category,
        _priority = priority,
        _status = status,
        _attachments = attachments,
        _adminNotes = adminNotes,
        _resolvedAt = resolvedAt,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory SupportTicket(
      {String? id,
      required String userId,
      required String subject,
      required String description,
      SupportTicketCategory? category,
      SupportTicketPriority? priority,
      SupportTicketStatus? status,
      List<String>? attachments,
      String? adminNotes,
      amplify_core.TemporalDateTime? resolvedAt,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return SupportTicket._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        subject: subject,
        description: description,
        category: category,
        priority: priority,
        status: status,
        attachments: attachments != null
            ? List<String>.unmodifiable(attachments)
            : attachments,
        adminNotes: adminNotes,
        resolvedAt: resolvedAt,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupportTicket &&
        id == other.id &&
        _userId == other._userId &&
        _subject == other._subject &&
        _description == other._description &&
        _category == other._category &&
        _priority == other._priority &&
        _status == other._status &&
        DeepCollectionEquality().equals(_attachments, other._attachments) &&
        _adminNotes == other._adminNotes &&
        _resolvedAt == other._resolvedAt &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("SupportTicket {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("subject=" + "$_subject" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("category=" +
        (_category != null ? amplify_core.enumToString(_category)! : "null") +
        ", ");
    buffer.write("priority=" +
        (_priority != null ? amplify_core.enumToString(_priority)! : "null") +
        ", ");
    buffer.write("status=" +
        (_status != null ? amplify_core.enumToString(_status)! : "null") +
        ", ");
    buffer.write("attachments=" +
        (_attachments != null ? _attachments.toString() : "null") +
        ", ");
    buffer.write("adminNotes=" + "$_adminNotes" + ", ");
    buffer.write("resolvedAt=" +
        (_resolvedAt != null ? _resolvedAt.format() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  SupportTicket copyWith(
      {String? userId,
      String? subject,
      String? description,
      SupportTicketCategory? category,
      SupportTicketPriority? priority,
      SupportTicketStatus? status,
      List<String>? attachments,
      String? adminNotes,
      amplify_core.TemporalDateTime? resolvedAt,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return SupportTicket._internal(
        id: id,
        userId: userId ?? this.userId,
        subject: subject ?? this.subject,
        description: description ?? this.description,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        attachments: attachments ?? this.attachments,
        adminNotes: adminNotes ?? this.adminNotes,
        resolvedAt: resolvedAt ?? this.resolvedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  SupportTicket copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? subject,
      ModelFieldValue<String>? description,
      ModelFieldValue<SupportTicketCategory?>? category,
      ModelFieldValue<SupportTicketPriority?>? priority,
      ModelFieldValue<SupportTicketStatus?>? status,
      ModelFieldValue<List<String>?>? attachments,
      ModelFieldValue<String?>? adminNotes,
      ModelFieldValue<amplify_core.TemporalDateTime?>? resolvedAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return SupportTicket._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        subject: subject == null ? this.subject : subject.value,
        description: description == null ? this.description : description.value,
        category: category == null ? this.category : category.value,
        priority: priority == null ? this.priority : priority.value,
        status: status == null ? this.status : status.value,
        attachments: attachments == null ? this.attachments : attachments.value,
        adminNotes: adminNotes == null ? this.adminNotes : adminNotes.value,
        resolvedAt: resolvedAt == null ? this.resolvedAt : resolvedAt.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  SupportTicket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _subject = json['subject'],
        _description = json['description'],
        _category = amplify_core.enumFromString<SupportTicketCategory>(
            json['category'], SupportTicketCategory.values),
        _priority = amplify_core.enumFromString<SupportTicketPriority>(
            json['priority'], SupportTicketPriority.values),
        _status = amplify_core.enumFromString<SupportTicketStatus>(
            json['status'], SupportTicketStatus.values),
        _attachments = json['attachments']?.cast<String>(),
        _adminNotes = json['adminNotes'],
        _resolvedAt = json['resolvedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['resolvedAt'])
            : null,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'subject': _subject,
        'description': _description,
        'category': amplify_core.enumToString(_category),
        'priority': amplify_core.enumToString(_priority),
        'status': amplify_core.enumToString(_status),
        'attachments': _attachments,
        'adminNotes': _adminNotes,
        'resolvedAt': _resolvedAt?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'subject': _subject,
        'description': _description,
        'category': _category,
        'priority': _priority,
        'status': _status,
        'attachments': _attachments,
        'adminNotes': _adminNotes,
        'resolvedAt': _resolvedAt,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<SupportTicketModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<SupportTicketModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final SUBJECT = amplify_core.QueryField(fieldName: "subject");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final PRIORITY = amplify_core.QueryField(fieldName: "priority");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static final ATTACHMENTS = amplify_core.QueryField(fieldName: "attachments");
  static final ADMINNOTES = amplify_core.QueryField(fieldName: "adminNotes");
  static final RESOLVEDAT = amplify_core.QueryField(fieldName: "resolvedAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SupportTicket";
    modelSchemaDefinition.pluralName = "SupportTickets";

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
        key: SupportTicket.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.SUBJECT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.DESCRIPTION,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.CATEGORY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.PRIORITY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.STATUS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.ATTACHMENTS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.ADMINNOTES,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.RESOLVEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: SupportTicket.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _SupportTicketModelType extends amplify_core.ModelType<SupportTicket> {
  const _SupportTicketModelType();

  @override
  SupportTicket fromJson(Map<String, dynamic> jsonData) {
    return SupportTicket.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'SupportTicket';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SupportTicket] in your schema.
 */
class SupportTicketModelIdentifier
    implements amplify_core.ModelIdentifier<SupportTicket> {
  final String id;

  /** Create an instance of SupportTicketModelIdentifier using [id] the primary key. */
  const SupportTicketModelIdentifier({required this.id});

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
  String toString() => 'SupportTicketModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SupportTicketModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
