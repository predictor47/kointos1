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

/** This is an auto generated class representing the PriceAlert type in your schema. */
class PriceAlert extends amplify_core.Model {
  static const classType = const _PriceAlertModelType();
  final String id;
  final String? _userId;
  final String? _cryptoSymbol;
  final PriceAlertAlertType? _alertType;
  final double? _targetPrice;
  final bool? _isActive;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _triggeredAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PriceAlertModelIdentifier get modelIdentifier {
    return PriceAlertModelIdentifier(id: id);
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

  String get cryptoSymbol {
    try {
      return _cryptoSymbol!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  PriceAlertAlertType? get alertType {
    return _alertType;
  }

  double get targetPrice {
    try {
      return _targetPrice!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  bool? get isActive {
    return _isActive;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get triggeredAt {
    return _triggeredAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const PriceAlert._internal(
      {required this.id,
      required userId,
      required cryptoSymbol,
      alertType,
      required targetPrice,
      isActive,
      createdAt,
      triggeredAt,
      updatedAt})
      : _userId = userId,
        _cryptoSymbol = cryptoSymbol,
        _alertType = alertType,
        _targetPrice = targetPrice,
        _isActive = isActive,
        _createdAt = createdAt,
        _triggeredAt = triggeredAt,
        _updatedAt = updatedAt;

  factory PriceAlert(
      {String? id,
      required String userId,
      required String cryptoSymbol,
      PriceAlertAlertType? alertType,
      required double targetPrice,
      bool? isActive,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? triggeredAt}) {
    return PriceAlert._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        cryptoSymbol: cryptoSymbol,
        alertType: alertType,
        targetPrice: targetPrice,
        isActive: isActive,
        createdAt: createdAt,
        triggeredAt: triggeredAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PriceAlert &&
        id == other.id &&
        _userId == other._userId &&
        _cryptoSymbol == other._cryptoSymbol &&
        _alertType == other._alertType &&
        _targetPrice == other._targetPrice &&
        _isActive == other._isActive &&
        _createdAt == other._createdAt &&
        _triggeredAt == other._triggeredAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("PriceAlert {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("cryptoSymbol=" + "$_cryptoSymbol" + ", ");
    buffer.write("alertType=" +
        (_alertType != null ? amplify_core.enumToString(_alertType)! : "null") +
        ", ");
    buffer.write("targetPrice=" +
        (_targetPrice != null ? _targetPrice.toString() : "null") +
        ", ");
    buffer.write("isActive=" +
        (_isActive != null ? _isActive.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write("triggeredAt=" +
        (_triggeredAt != null ? _triggeredAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  PriceAlert copyWith(
      {String? userId,
      String? cryptoSymbol,
      PriceAlertAlertType? alertType,
      double? targetPrice,
      bool? isActive,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? triggeredAt}) {
    return PriceAlert._internal(
        id: id,
        userId: userId ?? this.userId,
        cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
        alertType: alertType ?? this.alertType,
        targetPrice: targetPrice ?? this.targetPrice,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        triggeredAt: triggeredAt ?? this.triggeredAt);
  }

  PriceAlert copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? cryptoSymbol,
      ModelFieldValue<PriceAlertAlertType?>? alertType,
      ModelFieldValue<double>? targetPrice,
      ModelFieldValue<bool?>? isActive,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? triggeredAt}) {
    return PriceAlert._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        cryptoSymbol:
            cryptoSymbol == null ? this.cryptoSymbol : cryptoSymbol.value,
        alertType: alertType == null ? this.alertType : alertType.value,
        targetPrice: targetPrice == null ? this.targetPrice : targetPrice.value,
        isActive: isActive == null ? this.isActive : isActive.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        triggeredAt:
            triggeredAt == null ? this.triggeredAt : triggeredAt.value);
  }

  PriceAlert.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _cryptoSymbol = json['cryptoSymbol'],
        _alertType = amplify_core.enumFromString<PriceAlertAlertType>(
            json['alertType'], PriceAlertAlertType.values),
        _targetPrice = (json['targetPrice'] as num?)?.toDouble(),
        _isActive = json['isActive'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _triggeredAt = json['triggeredAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['triggeredAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'cryptoSymbol': _cryptoSymbol,
        'alertType': amplify_core.enumToString(_alertType),
        'targetPrice': _targetPrice,
        'isActive': _isActive,
        'createdAt': _createdAt?.format(),
        'triggeredAt': _triggeredAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'cryptoSymbol': _cryptoSymbol,
        'alertType': _alertType,
        'targetPrice': _targetPrice,
        'isActive': _isActive,
        'createdAt': _createdAt,
        'triggeredAt': _triggeredAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<PriceAlertModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PriceAlertModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final CRYPTOSYMBOL =
      amplify_core.QueryField(fieldName: "cryptoSymbol");
  static final ALERTTYPE = amplify_core.QueryField(fieldName: "alertType");
  static final TARGETPRICE = amplify_core.QueryField(fieldName: "targetPrice");
  static final ISACTIVE = amplify_core.QueryField(fieldName: "isActive");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final TRIGGEREDAT = amplify_core.QueryField(fieldName: "triggeredAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PriceAlert";
    modelSchemaDefinition.pluralName = "PriceAlerts";

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
        key: PriceAlert.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.CRYPTOSYMBOL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.ALERTTYPE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.TARGETPRICE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.ISACTIVE,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PriceAlert.TRIGGEREDAT,
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

class _PriceAlertModelType extends amplify_core.ModelType<PriceAlert> {
  const _PriceAlertModelType();

  @override
  PriceAlert fromJson(Map<String, dynamic> jsonData) {
    return PriceAlert.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'PriceAlert';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PriceAlert] in your schema.
 */
class PriceAlertModelIdentifier
    implements amplify_core.ModelIdentifier<PriceAlert> {
  final String id;

  /** Create an instance of PriceAlertModelIdentifier using [id] the primary key. */
  const PriceAlertModelIdentifier({required this.id});

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
  String toString() => 'PriceAlertModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PriceAlertModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
