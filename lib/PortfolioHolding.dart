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

/** This is an auto generated class representing the PortfolioHolding type in your schema. */
class PortfolioHolding extends amplify_core.Model {
  static const classType = const _PortfolioHoldingModelType();
  final String id;
  final String? _portfolioId;
  final String? _cryptoSymbol;
  final double? _amount;
  final double? _averageBuyPrice;
  final double? _currentValue;
  final double? _profitLoss;
  final double? _profitLossPercentage;
  final amplify_core.TemporalDateTime? _lastUpdated;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PortfolioHoldingModelIdentifier get modelIdentifier {
    return PortfolioHoldingModelIdentifier(id: id);
  }

  String get portfolioId {
    try {
      return _portfolioId!;
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

  double get amount {
    try {
      return _amount!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double? get averageBuyPrice {
    return _averageBuyPrice;
  }

  double? get currentValue {
    return _currentValue;
  }

  double? get profitLoss {
    return _profitLoss;
  }

  double? get profitLossPercentage {
    return _profitLossPercentage;
  }

  amplify_core.TemporalDateTime? get lastUpdated {
    return _lastUpdated;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const PortfolioHolding._internal(
      {required this.id,
      required portfolioId,
      required cryptoSymbol,
      required amount,
      averageBuyPrice,
      currentValue,
      profitLoss,
      profitLossPercentage,
      lastUpdated,
      createdAt,
      updatedAt})
      : _portfolioId = portfolioId,
        _cryptoSymbol = cryptoSymbol,
        _amount = amount,
        _averageBuyPrice = averageBuyPrice,
        _currentValue = currentValue,
        _profitLoss = profitLoss,
        _profitLossPercentage = profitLossPercentage,
        _lastUpdated = lastUpdated,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory PortfolioHolding(
      {String? id,
      required String portfolioId,
      required String cryptoSymbol,
      required double amount,
      double? averageBuyPrice,
      double? currentValue,
      double? profitLoss,
      double? profitLossPercentage,
      amplify_core.TemporalDateTime? lastUpdated}) {
    return PortfolioHolding._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        portfolioId: portfolioId,
        cryptoSymbol: cryptoSymbol,
        amount: amount,
        averageBuyPrice: averageBuyPrice,
        currentValue: currentValue,
        profitLoss: profitLoss,
        profitLossPercentage: profitLossPercentage,
        lastUpdated: lastUpdated);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PortfolioHolding &&
        id == other.id &&
        _portfolioId == other._portfolioId &&
        _cryptoSymbol == other._cryptoSymbol &&
        _amount == other._amount &&
        _averageBuyPrice == other._averageBuyPrice &&
        _currentValue == other._currentValue &&
        _profitLoss == other._profitLoss &&
        _profitLossPercentage == other._profitLossPercentage &&
        _lastUpdated == other._lastUpdated;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("PortfolioHolding {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("portfolioId=" + "$_portfolioId" + ", ");
    buffer.write("cryptoSymbol=" + "$_cryptoSymbol" + ", ");
    buffer.write(
        "amount=" + (_amount != null ? _amount.toString() : "null") + ", ");
    buffer.write("averageBuyPrice=" +
        (_averageBuyPrice != null ? _averageBuyPrice.toString() : "null") +
        ", ");
    buffer.write("currentValue=" +
        (_currentValue != null ? _currentValue.toString() : "null") +
        ", ");
    buffer.write("profitLoss=" +
        (_profitLoss != null ? _profitLoss.toString() : "null") +
        ", ");
    buffer.write("profitLossPercentage=" +
        (_profitLossPercentage != null
            ? _profitLossPercentage.toString()
            : "null") +
        ", ");
    buffer.write("lastUpdated=" +
        (_lastUpdated != null ? _lastUpdated.format() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  PortfolioHolding copyWith(
      {String? portfolioId,
      String? cryptoSymbol,
      double? amount,
      double? averageBuyPrice,
      double? currentValue,
      double? profitLoss,
      double? profitLossPercentage,
      amplify_core.TemporalDateTime? lastUpdated}) {
    return PortfolioHolding._internal(
        id: id,
        portfolioId: portfolioId ?? this.portfolioId,
        cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
        amount: amount ?? this.amount,
        averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
        currentValue: currentValue ?? this.currentValue,
        profitLoss: profitLoss ?? this.profitLoss,
        profitLossPercentage: profitLossPercentage ?? this.profitLossPercentage,
        lastUpdated: lastUpdated ?? this.lastUpdated);
  }

  PortfolioHolding copyWithModelFieldValues(
      {ModelFieldValue<String>? portfolioId,
      ModelFieldValue<String>? cryptoSymbol,
      ModelFieldValue<double>? amount,
      ModelFieldValue<double?>? averageBuyPrice,
      ModelFieldValue<double?>? currentValue,
      ModelFieldValue<double?>? profitLoss,
      ModelFieldValue<double?>? profitLossPercentage,
      ModelFieldValue<amplify_core.TemporalDateTime?>? lastUpdated}) {
    return PortfolioHolding._internal(
        id: id,
        portfolioId: portfolioId == null ? this.portfolioId : portfolioId.value,
        cryptoSymbol:
            cryptoSymbol == null ? this.cryptoSymbol : cryptoSymbol.value,
        amount: amount == null ? this.amount : amount.value,
        averageBuyPrice: averageBuyPrice == null
            ? this.averageBuyPrice
            : averageBuyPrice.value,
        currentValue:
            currentValue == null ? this.currentValue : currentValue.value,
        profitLoss: profitLoss == null ? this.profitLoss : profitLoss.value,
        profitLossPercentage: profitLossPercentage == null
            ? this.profitLossPercentage
            : profitLossPercentage.value,
        lastUpdated:
            lastUpdated == null ? this.lastUpdated : lastUpdated.value);
  }

  PortfolioHolding.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _portfolioId = json['portfolioId'],
        _cryptoSymbol = json['cryptoSymbol'],
        _amount = (json['amount'] as num?)?.toDouble(),
        _averageBuyPrice = (json['averageBuyPrice'] as num?)?.toDouble(),
        _currentValue = (json['currentValue'] as num?)?.toDouble(),
        _profitLoss = (json['profitLoss'] as num?)?.toDouble(),
        _profitLossPercentage =
            (json['profitLossPercentage'] as num?)?.toDouble(),
        _lastUpdated = json['lastUpdated'] != null
            ? amplify_core.TemporalDateTime.fromString(json['lastUpdated'])
            : null,
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'portfolioId': _portfolioId,
        'cryptoSymbol': _cryptoSymbol,
        'amount': _amount,
        'averageBuyPrice': _averageBuyPrice,
        'currentValue': _currentValue,
        'profitLoss': _profitLoss,
        'profitLossPercentage': _profitLossPercentage,
        'lastUpdated': _lastUpdated?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'portfolioId': _portfolioId,
        'cryptoSymbol': _cryptoSymbol,
        'amount': _amount,
        'averageBuyPrice': _averageBuyPrice,
        'currentValue': _currentValue,
        'profitLoss': _profitLoss,
        'profitLossPercentage': _profitLossPercentage,
        'lastUpdated': _lastUpdated,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core
      .QueryModelIdentifier<PortfolioHoldingModelIdentifier> MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PortfolioHoldingModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PORTFOLIOID = amplify_core.QueryField(fieldName: "portfolioId");
  static final CRYPTOSYMBOL =
      amplify_core.QueryField(fieldName: "cryptoSymbol");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final AVERAGEBUYPRICE =
      amplify_core.QueryField(fieldName: "averageBuyPrice");
  static final CURRENTVALUE =
      amplify_core.QueryField(fieldName: "currentValue");
  static final PROFITLOSS = amplify_core.QueryField(fieldName: "profitLoss");
  static final PROFITLOSSPERCENTAGE =
      amplify_core.QueryField(fieldName: "profitLossPercentage");
  static final LASTUPDATED = amplify_core.QueryField(fieldName: "lastUpdated");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PortfolioHolding";
    modelSchemaDefinition.pluralName = "PortfolioHoldings";

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
        key: PortfolioHolding.PORTFOLIOID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.CRYPTOSYMBOL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.AMOUNT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.AVERAGEBUYPRICE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.CURRENTVALUE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.PROFITLOSS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.PROFITLOSSPERCENTAGE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PortfolioHolding.LASTUPDATED,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'createdAt',
            isRequired: false,
            isReadOnly: true,
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

class _PortfolioHoldingModelType
    extends amplify_core.ModelType<PortfolioHolding> {
  const _PortfolioHoldingModelType();

  @override
  PortfolioHolding fromJson(Map<String, dynamic> jsonData) {
    return PortfolioHolding.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'PortfolioHolding';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PortfolioHolding] in your schema.
 */
class PortfolioHoldingModelIdentifier
    implements amplify_core.ModelIdentifier<PortfolioHolding> {
  final String id;

  /** Create an instance of PortfolioHoldingModelIdentifier using [id] the primary key. */
  const PortfolioHoldingModelIdentifier({required this.id});

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
  String toString() => 'PortfolioHoldingModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PortfolioHoldingModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
