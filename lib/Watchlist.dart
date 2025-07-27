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

/** This is an auto generated class representing the Watchlist type in your schema. */
class Watchlist extends amplify_core.Model {
  static const classType = const _WatchlistModelType();
  final String id;
  final String? _userId;
  final String? _name;
  final List<String>? _cryptoSymbols;
  final bool? _isPublic;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  WatchlistModelIdentifier get modelIdentifier {
    return WatchlistModelIdentifier(id: id);
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

  List<String>? get cryptoSymbols {
    return _cryptoSymbols;
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

  const Watchlist._internal(
      {required this.id,
      required userId,
      required name,
      cryptoSymbols,
      isPublic,
      createdAt,
      updatedAt})
      : _userId = userId,
        _name = name,
        _cryptoSymbols = cryptoSymbols,
        _isPublic = isPublic,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Watchlist(
      {String? id,
      required String userId,
      required String name,
      List<String>? cryptoSymbols,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Watchlist._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        name: name,
        cryptoSymbols: cryptoSymbols != null
            ? List<String>.unmodifiable(cryptoSymbols)
            : cryptoSymbols,
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
    return other is Watchlist &&
        id == other.id &&
        _userId == other._userId &&
        _name == other._name &&
        DeepCollectionEquality().equals(_cryptoSymbols, other._cryptoSymbols) &&
        _isPublic == other._isPublic &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Watchlist {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("cryptoSymbols=" +
        (_cryptoSymbols != null ? _cryptoSymbols.toString() : "null") +
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

  Watchlist copyWith(
      {String? userId,
      String? name,
      List<String>? cryptoSymbols,
      bool? isPublic,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return Watchlist._internal(
        id: id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        cryptoSymbols: cryptoSymbols ?? this.cryptoSymbols,
        isPublic: isPublic ?? this.isPublic,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Watchlist copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? name,
      ModelFieldValue<List<String>?>? cryptoSymbols,
      ModelFieldValue<bool?>? isPublic,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return Watchlist._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        name: name == null ? this.name : name.value,
        cryptoSymbols:
            cryptoSymbols == null ? this.cryptoSymbols : cryptoSymbols.value,
        isPublic: isPublic == null ? this.isPublic : isPublic.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  Watchlist.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _name = json['name'],
        _cryptoSymbols = json['cryptoSymbols']?.cast<String>(),
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
        'name': _name,
        'cryptoSymbols': _cryptoSymbols,
        'isPublic': _isPublic,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'name': _name,
        'cryptoSymbols': _cryptoSymbols,
        'isPublic': _isPublic,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<WatchlistModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<WatchlistModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final CRYPTOSYMBOLS =
      amplify_core.QueryField(fieldName: "cryptoSymbols");
  static final ISPUBLIC = amplify_core.QueryField(fieldName: "isPublic");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Watchlist";
    modelSchemaDefinition.pluralName = "Watchlists";

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
        key: Watchlist.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Watchlist.NAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Watchlist.CRYPTOSYMBOLS,
        isRequired: false,
        isArray: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.collection,
            ofModelName: amplify_core.ModelFieldTypeEnum.string.name)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Watchlist.ISPUBLIC,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Watchlist.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Watchlist.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _WatchlistModelType extends amplify_core.ModelType<Watchlist> {
  const _WatchlistModelType();

  @override
  Watchlist fromJson(Map<String, dynamic> jsonData) {
    return Watchlist.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Watchlist';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Watchlist] in your schema.
 */
class WatchlistModelIdentifier
    implements amplify_core.ModelIdentifier<Watchlist> {
  final String id;

  /** Create an instance of WatchlistModelIdentifier using [id] the primary key. */
  const WatchlistModelIdentifier({required this.id});

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
  String toString() => 'WatchlistModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is WatchlistModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
