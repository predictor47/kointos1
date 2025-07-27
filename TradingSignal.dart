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

/** This is an auto generated class representing the TradingSignal type in your schema. */
class TradingSignal extends amplify_core.Model {
  static const classType = const _TradingSignalModelType();
  final String id;
  final String? _userId;
  final String? _cryptoSymbol;
  final TradingSignalSignalType? _signalType;
  final double? _targetPrice;
  final double? _stopLoss;
  final int? _confidence;
  final String? _reasoning;
  final amplify_core.TemporalDateTime? _expiresAt;
  final bool? _isActive;
  final double? _performanceRating;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  TradingSignalModelIdentifier get modelIdentifier {
    return TradingSignalModelIdentifier(id: id);
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

  TradingSignalSignalType? get signalType {
    return _signalType;
  }

  double? get targetPrice {
    return _targetPrice;
  }

  double? get stopLoss {
    return _stopLoss;
  }

  int? get confidence {
    return _confidence;
  }

  String? get reasoning {
    return _reasoning;
  }

  amplify_core.TemporalDateTime? get expiresAt {
    return _expiresAt;
  }

  bool? get isActive {
    return _isActive;
  }

  double? get performanceRating {
    return _performanceRating;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const TradingSignal._internal(
      {required this.id,
      required userId,
      required cryptoSymbol,
      signalType,
      targetPrice,
      stopLoss,
      confidence,
      reasoning,
      expiresAt,
      isActive,
      performanceRating,
      createdAt,
      updatedAt})
      : _userId = userId,
        _cryptoSymbol = cryptoSymbol,
        _signalType = signalType,
        _targetPrice = targetPrice,
        _stopLoss = stopLoss,
        _confidence = confidence,
        _reasoning = reasoning,
        _expiresAt = expiresAt,
        _isActive = isActive,
        _performanceRating = performanceRating,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory TradingSignal(
      {String? id,
      required String userId,
      required String cryptoSymbol,
      TradingSignalSignalType? signalType,
      double? targetPrice,
      double? stopLoss,
      int? confidence,
      String? reasoning,
      amplify_core.TemporalDateTime? expiresAt,
      bool? isActive,
      double? performanceRating,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return TradingSignal._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        cryptoSymbol: cryptoSymbol,
        signalType: signalType,
        targetPrice: targetPrice,
        stopLoss: stopLoss,
        confidence: confidence,
        reasoning: reasoning,
        expiresAt: expiresAt,
        isActive: isActive,
        performanceRating: performanceRating,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TradingSignal &&
        id == other.id &&
        _userId == other._userId &&
        _cryptoSymbol == other._cryptoSymbol &&
        _signalType == other._signalType &&
        _targetPrice == other._targetPrice &&
        _stopLoss == other._stopLoss &&
        _confidence == other._confidence &&
        _reasoning == other._reasoning &&
        _expiresAt == other._expiresAt &&
        _isActive == other._isActive &&
        _performanceRating == other._performanceRating &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("TradingSignal {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("cryptoSymbol=" + "$_cryptoSymbol" + ", ");
    buffer.write("signalType=" +
        (_signalType != null
            ? amplify_core.enumToString(_signalType)!
            : "null") +
        ", ");
    buffer.write("targetPrice=" +
        (_targetPrice != null ? _targetPrice.toString() : "null") +
        ", ");
    buffer.write("stopLoss=" +
        (_stopLoss != null ? _stopLoss.toString() : "null") +
        ", ");
    buffer.write("confidence=" +
        (_confidence != null ? _confidence.toString() : "null") +
        ", ");
    buffer.write("reasoning=" + "$_reasoning" + ", ");
    buffer.write("expiresAt=" +
        (_expiresAt != null ? _expiresAt.format() : "null") +
        ", ");
    buffer.write("isActive=" +
        (_isActive != null ? _isActive.toString() : "null") +
        ", ");
    buffer.write("performanceRating=" +
        (_performanceRating != null ? _performanceRating.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  TradingSignal copyWith(
      {String? userId,
      String? cryptoSymbol,
      TradingSignalSignalType? signalType,
      double? targetPrice,
      double? stopLoss,
      int? confidence,
      String? reasoning,
      amplify_core.TemporalDateTime? expiresAt,
      bool? isActive,
      double? performanceRating,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return TradingSignal._internal(
        id: id,
        userId: userId ?? this.userId,
        cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
        signalType: signalType ?? this.signalType,
        targetPrice: targetPrice ?? this.targetPrice,
        stopLoss: stopLoss ?? this.stopLoss,
        confidence: confidence ?? this.confidence,
        reasoning: reasoning ?? this.reasoning,
        expiresAt: expiresAt ?? this.expiresAt,
        isActive: isActive ?? this.isActive,
        performanceRating: performanceRating ?? this.performanceRating,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  TradingSignal copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<String>? cryptoSymbol,
      ModelFieldValue<TradingSignalSignalType?>? signalType,
      ModelFieldValue<double?>? targetPrice,
      ModelFieldValue<double?>? stopLoss,
      ModelFieldValue<int?>? confidence,
      ModelFieldValue<String?>? reasoning,
      ModelFieldValue<amplify_core.TemporalDateTime?>? expiresAt,
      ModelFieldValue<bool?>? isActive,
      ModelFieldValue<double?>? performanceRating,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return TradingSignal._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        cryptoSymbol:
            cryptoSymbol == null ? this.cryptoSymbol : cryptoSymbol.value,
        signalType: signalType == null ? this.signalType : signalType.value,
        targetPrice: targetPrice == null ? this.targetPrice : targetPrice.value,
        stopLoss: stopLoss == null ? this.stopLoss : stopLoss.value,
        confidence: confidence == null ? this.confidence : confidence.value,
        reasoning: reasoning == null ? this.reasoning : reasoning.value,
        expiresAt: expiresAt == null ? this.expiresAt : expiresAt.value,
        isActive: isActive == null ? this.isActive : isActive.value,
        performanceRating: performanceRating == null
            ? this.performanceRating
            : performanceRating.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  TradingSignal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _cryptoSymbol = json['cryptoSymbol'],
        _signalType = amplify_core.enumFromString<TradingSignalSignalType>(
            json['signalType'], TradingSignalSignalType.values),
        _targetPrice = (json['targetPrice'] as num?)?.toDouble(),
        _stopLoss = (json['stopLoss'] as num?)?.toDouble(),
        _confidence = (json['confidence'] as num?)?.toInt(),
        _reasoning = json['reasoning'],
        _expiresAt = json['expiresAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['expiresAt'])
            : null,
        _isActive = json['isActive'],
        _performanceRating = (json['performanceRating'] as num?)?.toDouble(),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'cryptoSymbol': _cryptoSymbol,
        'signalType': amplify_core.enumToString(_signalType),
        'targetPrice': _targetPrice,
        'stopLoss': _stopLoss,
        'confidence': _confidence,
        'reasoning': _reasoning,
        'expiresAt': _expiresAt?.format(),
        'isActive': _isActive,
        'performanceRating': _performanceRating,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'cryptoSymbol': _cryptoSymbol,
        'signalType': _signalType,
        'targetPrice': _targetPrice,
        'stopLoss': _stopLoss,
        'confidence': _confidence,
        'reasoning': _reasoning,
        'expiresAt': _expiresAt,
        'isActive': _isActive,
        'performanceRating': _performanceRating,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<TradingSignalModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<TradingSignalModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final CRYPTOSYMBOL =
      amplify_core.QueryField(fieldName: "cryptoSymbol");
  static final SIGNALTYPE = amplify_core.QueryField(fieldName: "signalType");
  static final TARGETPRICE = amplify_core.QueryField(fieldName: "targetPrice");
  static final STOPLOSS = amplify_core.QueryField(fieldName: "stopLoss");
  static final CONFIDENCE = amplify_core.QueryField(fieldName: "confidence");
  static final REASONING = amplify_core.QueryField(fieldName: "reasoning");
  static final EXPIRESAT = amplify_core.QueryField(fieldName: "expiresAt");
  static final ISACTIVE = amplify_core.QueryField(fieldName: "isActive");
  static final PERFORMANCERATING =
      amplify_core.QueryField(fieldName: "performanceRating");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TradingSignal";
    modelSchemaDefinition.pluralName = "TradingSignals";

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
        key: TradingSignal.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.CRYPTOSYMBOL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.SIGNALTYPE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.TARGETPRICE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.STOPLOSS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.CONFIDENCE,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.REASONING,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.EXPIRESAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.ISACTIVE,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.PERFORMANCERATING,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: TradingSignal.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _TradingSignalModelType extends amplify_core.ModelType<TradingSignal> {
  const _TradingSignalModelType();

  @override
  TradingSignal fromJson(Map<String, dynamic> jsonData) {
    return TradingSignal.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'TradingSignal';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [TradingSignal] in your schema.
 */
class TradingSignalModelIdentifier
    implements amplify_core.ModelIdentifier<TradingSignal> {
  final String id;

  /** Create an instance of TradingSignalModelIdentifier using [id] the primary key. */
  const TradingSignalModelIdentifier({required this.id});

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
  String toString() => 'TradingSignalModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TradingSignalModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
