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

/** This is an auto generated class representing the Transaction type in your schema. */
class Transaction extends amplify_core.Model {
  static const classType = const _TransactionModelType();
  final String id;
  final String? _portfolioId;
  final String? _cryptoSymbol;
  final TransactionType? _type;
  final double? _amount;
  final double? _price;
  final double? _totalValue;
  final double? _fees;
  final String? _notes;
  final amplify_core.TemporalDateTime? _transactionDate;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  TransactionModelIdentifier get modelIdentifier {
    return TransactionModelIdentifier(id: id);
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

  TransactionType? get type {
    return _type;
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

  double get price {
    try {
      return _price!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get totalValue {
    try {
      return _totalValue!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double? get fees {
    return _fees;
  }

  String? get notes {
    return _notes;
  }

  amplify_core.TemporalDateTime get transactionDate {
    try {
      return _transactionDate!;
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

  const Transaction._internal(
      {required this.id,
      required portfolioId,
      required cryptoSymbol,
      type,
      required amount,
      required price,
      required totalValue,
      fees,
      notes,
      required transactionDate,
      createdAt,
      updatedAt})
      : _portfolioId = portfolioId,
        _cryptoSymbol = cryptoSymbol,
        _type = type,
        _amount = amount,
        _price = price,
        _totalValue = totalValue,
        _fees = fees,
        _notes = notes,
        _transactionDate = transactionDate,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Transaction(
      {String? id,
      required String portfolioId,
      required String cryptoSymbol,
      TransactionType? type,
      required double amount,
      required double price,
      required double totalValue,
      double? fees,
      String? notes,
      required amplify_core.TemporalDateTime transactionDate,
      amplify_core.TemporalDateTime? createdAt}) {
    return Transaction._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        portfolioId: portfolioId,
        cryptoSymbol: cryptoSymbol,
        type: type,
        amount: amount,
        price: price,
        totalValue: totalValue,
        fees: fees,
        notes: notes,
        transactionDate: transactionDate,
        createdAt: createdAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Transaction &&
        id == other.id &&
        _portfolioId == other._portfolioId &&
        _cryptoSymbol == other._cryptoSymbol &&
        _type == other._type &&
        _amount == other._amount &&
        _price == other._price &&
        _totalValue == other._totalValue &&
        _fees == other._fees &&
        _notes == other._notes &&
        _transactionDate == other._transactionDate &&
        _createdAt == other._createdAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Transaction {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("portfolioId=" + "$_portfolioId" + ", ");
    buffer.write("cryptoSymbol=" + "$_cryptoSymbol" + ", ");
    buffer.write("type=" +
        (_type != null ? amplify_core.enumToString(_type)! : "null") +
        ", ");
    buffer.write(
        "amount=" + (_amount != null ? _amount.toString() : "null") + ", ");
    buffer
        .write("price=" + (_price != null ? _price.toString() : "null") + ", ");
    buffer.write("totalValue=" +
        (_totalValue != null ? _totalValue.toString() : "null") +
        ", ");
    buffer.write("fees=" + (_fees != null ? _fees.toString() : "null") + ", ");
    buffer.write("notes=" + "$_notes" + ", ");
    buffer.write("transactionDate=" +
        (_transactionDate != null ? _transactionDate.format() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Transaction copyWith(
      {String? portfolioId,
      String? cryptoSymbol,
      TransactionType? type,
      double? amount,
      double? price,
      double? totalValue,
      double? fees,
      String? notes,
      amplify_core.TemporalDateTime? transactionDate,
      amplify_core.TemporalDateTime? createdAt}) {
    return Transaction._internal(
        id: id,
        portfolioId: portfolioId ?? this.portfolioId,
        cryptoSymbol: cryptoSymbol ?? this.cryptoSymbol,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        price: price ?? this.price,
        totalValue: totalValue ?? this.totalValue,
        fees: fees ?? this.fees,
        notes: notes ?? this.notes,
        transactionDate: transactionDate ?? this.transactionDate,
        createdAt: createdAt ?? this.createdAt);
  }

  Transaction copyWithModelFieldValues(
      {ModelFieldValue<String>? portfolioId,
      ModelFieldValue<String>? cryptoSymbol,
      ModelFieldValue<TransactionType?>? type,
      ModelFieldValue<double>? amount,
      ModelFieldValue<double>? price,
      ModelFieldValue<double>? totalValue,
      ModelFieldValue<double?>? fees,
      ModelFieldValue<String?>? notes,
      ModelFieldValue<amplify_core.TemporalDateTime>? transactionDate,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt}) {
    return Transaction._internal(
        id: id,
        portfolioId: portfolioId == null ? this.portfolioId : portfolioId.value,
        cryptoSymbol:
            cryptoSymbol == null ? this.cryptoSymbol : cryptoSymbol.value,
        type: type == null ? this.type : type.value,
        amount: amount == null ? this.amount : amount.value,
        price: price == null ? this.price : price.value,
        totalValue: totalValue == null ? this.totalValue : totalValue.value,
        fees: fees == null ? this.fees : fees.value,
        notes: notes == null ? this.notes : notes.value,
        transactionDate: transactionDate == null
            ? this.transactionDate
            : transactionDate.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value);
  }

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _portfolioId = json['portfolioId'],
        _cryptoSymbol = json['cryptoSymbol'],
        _type = amplify_core.enumFromString<TransactionType>(
            json['type'], TransactionType.values),
        _amount = (json['amount'] as num?)?.toDouble(),
        _price = (json['price'] as num?)?.toDouble(),
        _totalValue = (json['totalValue'] as num?)?.toDouble(),
        _fees = (json['fees'] as num?)?.toDouble(),
        _notes = json['notes'],
        _transactionDate = json['transactionDate'] != null
            ? amplify_core.TemporalDateTime.fromString(json['transactionDate'])
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
        'type': amplify_core.enumToString(_type),
        'amount': _amount,
        'price': _price,
        'totalValue': _totalValue,
        'fees': _fees,
        'notes': _notes,
        'transactionDate': _transactionDate?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'portfolioId': _portfolioId,
        'cryptoSymbol': _cryptoSymbol,
        'type': _type,
        'amount': _amount,
        'price': _price,
        'totalValue': _totalValue,
        'fees': _fees,
        'notes': _notes,
        'transactionDate': _transactionDate,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<TransactionModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<TransactionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PORTFOLIOID = amplify_core.QueryField(fieldName: "portfolioId");
  static final CRYPTOSYMBOL =
      amplify_core.QueryField(fieldName: "cryptoSymbol");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final AMOUNT = amplify_core.QueryField(fieldName: "amount");
  static final PRICE = amplify_core.QueryField(fieldName: "price");
  static final TOTALVALUE = amplify_core.QueryField(fieldName: "totalValue");
  static final FEES = amplify_core.QueryField(fieldName: "fees");
  static final NOTES = amplify_core.QueryField(fieldName: "notes");
  static final TRANSACTIONDATE =
      amplify_core.QueryField(fieldName: "transactionDate");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Transaction";
    modelSchemaDefinition.pluralName = "Transactions";

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
        key: Transaction.PORTFOLIOID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.CRYPTOSYMBOL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.TYPE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.AMOUNT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.PRICE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.TOTALVALUE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.FEES,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.NOTES,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.TRANSACTIONDATE,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Transaction.CREATEDAT,
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

class _TransactionModelType extends amplify_core.ModelType<Transaction> {
  const _TransactionModelType();

  @override
  Transaction fromJson(Map<String, dynamic> jsonData) {
    return Transaction.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Transaction';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Transaction] in your schema.
 */
class TransactionModelIdentifier
    implements amplify_core.ModelIdentifier<Transaction> {
  final String id;

  /** Create an instance of TransactionModelIdentifier using [id] the primary key. */
  const TransactionModelIdentifier({required this.id});

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
  String toString() => 'TransactionModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TransactionModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
