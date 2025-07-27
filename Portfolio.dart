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

/** This is an auto generated class representing the Portfolio type in your schema. */
class Portfolio extends amplify_core.Model {
  static const classType = const _PortfolioModelType();
  final String id;
  final String? _name;
  final String? _description;
  final double? _totalValue;
  final bool? _isPublic;
  final String? _userId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PortfolioModelIdentifier get modelIdentifier {
    return PortfolioModelIdentifier(id: id);
  }

  String get name {
    try {
      return _name!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get description {
    return _description;
  }

  double? get totalValue {
    return _totalValue;
  }

  bool? get isPublic {
    return _isPublic;
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

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Portfolio._internal(
      {required this.id,
      required name,
      description,
      totalValue,
      isPublic,
      required userId,
      createdAt,
      updatedAt})
      : _name = name,
        _description = description,
        _totalValue = totalValue,
        _isPublic = isPublic,
        _userId = userId,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Portfolio(
      {String? id,
      required String name,
      String? description,
      double? totalValue,
      bool? isPublic,
      required String userId,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Portfolio._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        name: name,
        description: description,
        totalValue: totalValue,
        isPublic: isPublic,
        userId: userId,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Portfolio &&
        id == other.id &&
        _name == other._name &&
        _description == other._description &&
        _totalValue == other._totalValue &&
        _isPublic == other._isPublic &&
        _userId == other._userId &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Portfolio {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("totalValue=" +
        (_totalValue != null ? _totalValue.toString() : "null") +
        ", ");
    buffer.write("isPublic=" +
        (_isPublic != null ? _isPublic.toString() : "null") +
        ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Portfolio copyWith(
      {String? name,
      String? description,
      double? totalValue,
      bool? isPublic,
      String? userId,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Portfolio._internal(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        totalValue: totalValue ?? this.totalValue,
        isPublic: isPublic ?? this.isPublic,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Portfolio copyWithModelFieldValues(
      {ModelFieldValue<String>? name,
      ModelFieldValue<String?>? description,
      ModelFieldValue<double?>? totalValue,
      ModelFieldValue<bool?>? isPublic,
      ModelFieldValue<String>? userId,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return Portfolio._internal(
        id: id,
        name: name == null ? this.name : name.value,
        description: description == null ? this.description : description.value,
        totalValue: totalValue == null ? this.totalValue : totalValue.value,
        isPublic: isPublic == null ? this.isPublic : isPublic.value,
        userId: userId == null ? this.userId : userId.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  Portfolio.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _description = json['description'],
        _totalValue = (json['totalValue'] as num?)?.toDouble(),
        _isPublic = json['isPublic'],
        _userId = json['userId'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': _name,
        'description': _description,
        'totalValue': _totalValue,
        'isPublic': _isPublic,
        'userId': _userId,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'name': _name,
        'description': _description,
        'totalValue': _totalValue,
        'isPublic': _isPublic,
        'userId': _userId,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<PortfolioModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PortfolioModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final TOTALVALUE = amplify_core.QueryField(fieldName: "totalValue");
  static final ISPUBLIC = amplify_core.QueryField(fieldName: "isPublic");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Portfolio";
    modelSchemaDefinition.pluralName = "Portfolios";

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
        key: Portfolio.NAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.DESCRIPTION,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.TOTALVALUE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.ISPUBLIC,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Portfolio.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _PortfolioModelType extends amplify_core.ModelType<Portfolio> {
  const _PortfolioModelType();

  @override
  Portfolio fromJson(Map<String, dynamic> jsonData) {
    return Portfolio.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Portfolio';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Portfolio] in your schema.
 */
class PortfolioModelIdentifier
    implements amplify_core.ModelIdentifier<Portfolio> {
  final String id;

  /** Create an instance of PortfolioModelIdentifier using [id] the primary key. */
  const PortfolioModelIdentifier({required this.id});

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
  String toString() => 'PortfolioModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PortfolioModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
