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

/** This is an auto generated class representing the PaymentMethod type in your schema. */
class PaymentMethod extends amplify_core.Model {
  static const classType = const _PaymentMethodModelType();
  final String id;
  final String? _userId;
  final PaymentMethodType? _type;
  final String? _name;
  final String? _last4;
  final int? _expiryMonth;
  final int? _expiryYear;
  final String? _bankName;
  final String? _accountType;
  final String? _walletAddress;
  final bool? _isDefault;
  final bool? _isActive;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PaymentMethodModelIdentifier get modelIdentifier {
    return PaymentMethodModelIdentifier(id: id);
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

  PaymentMethodType? get type {
    return _type;
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

  String? get last4 {
    return _last4;
  }

  int? get expiryMonth {
    return _expiryMonth;
  }

  int? get expiryYear {
    return _expiryYear;
  }

  String? get bankName {
    return _bankName;
  }

  String? get accountType {
    return _accountType;
  }

  String? get walletAddress {
    return _walletAddress;
  }

  bool? get isDefault {
    return _isDefault;
  }

  bool? get isActive {
    return _isActive;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const PaymentMethod._internal(
      {required this.id,
      required userId,
      type,
      required name,
      last4,
      expiryMonth,
      expiryYear,
      bankName,
      accountType,
      walletAddress,
      isDefault,
      isActive,
      createdAt,
      updatedAt})
      : _userId = userId,
        _type = type,
        _name = name,
        _last4 = last4,
        _expiryMonth = expiryMonth,
        _expiryYear = expiryYear,
        _bankName = bankName,
        _accountType = accountType,
        _walletAddress = walletAddress,
        _isDefault = isDefault,
        _isActive = isActive,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory PaymentMethod(
      {String? id,
      required String userId,
      PaymentMethodType? type,
      required String name,
      String? last4,
      int? expiryMonth,
      int? expiryYear,
      String? bankName,
      String? accountType,
      String? walletAddress,
      bool? isDefault,
      bool? isActive,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return PaymentMethod._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        type: type,
        name: name,
        last4: last4,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        bankName: bankName,
        accountType: accountType,
        walletAddress: walletAddress,
        isDefault: isDefault,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentMethod &&
        id == other.id &&
        _userId == other._userId &&
        _type == other._type &&
        _name == other._name &&
        _last4 == other._last4 &&
        _expiryMonth == other._expiryMonth &&
        _expiryYear == other._expiryYear &&
        _bankName == other._bankName &&
        _accountType == other._accountType &&
        _walletAddress == other._walletAddress &&
        _isDefault == other._isDefault &&
        _isActive == other._isActive &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("PaymentMethod {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("type=" +
        (_type != null ? amplify_core.enumToString(_type)! : "null") +
        ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("last4=" + "$_last4" + ", ");
    buffer.write("expiryMonth=" +
        (_expiryMonth != null ? _expiryMonth.toString() : "null") +
        ", ");
    buffer.write("expiryYear=" +
        (_expiryYear != null ? _expiryYear.toString() : "null") +
        ", ");
    buffer.write("bankName=" + "$_bankName" + ", ");
    buffer.write("accountType=" + "$_accountType" + ", ");
    buffer.write("walletAddress=" + "$_walletAddress" + ", ");
    buffer.write("isDefault=" +
        (_isDefault != null ? _isDefault.toString() : "null") +
        ", ");
    buffer.write("isActive=" +
        (_isActive != null ? _isActive.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  PaymentMethod copyWith(
      {String? userId,
      PaymentMethodType? type,
      String? name,
      String? last4,
      int? expiryMonth,
      int? expiryYear,
      String? bankName,
      String? accountType,
      String? walletAddress,
      bool? isDefault,
      bool? isActive,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return PaymentMethod._internal(
        id: id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        name: name ?? this.name,
        last4: last4 ?? this.last4,
        expiryMonth: expiryMonth ?? this.expiryMonth,
        expiryYear: expiryYear ?? this.expiryYear,
        bankName: bankName ?? this.bankName,
        accountType: accountType ?? this.accountType,
        walletAddress: walletAddress ?? this.walletAddress,
        isDefault: isDefault ?? this.isDefault,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  PaymentMethod copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<PaymentMethodType?>? type,
      ModelFieldValue<String>? name,
      ModelFieldValue<String?>? last4,
      ModelFieldValue<int?>? expiryMonth,
      ModelFieldValue<int?>? expiryYear,
      ModelFieldValue<String?>? bankName,
      ModelFieldValue<String?>? accountType,
      ModelFieldValue<String?>? walletAddress,
      ModelFieldValue<bool?>? isDefault,
      ModelFieldValue<bool?>? isActive,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return PaymentMethod._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        type: type == null ? this.type : type.value,
        name: name == null ? this.name : name.value,
        last4: last4 == null ? this.last4 : last4.value,
        expiryMonth: expiryMonth == null ? this.expiryMonth : expiryMonth.value,
        expiryYear: expiryYear == null ? this.expiryYear : expiryYear.value,
        bankName: bankName == null ? this.bankName : bankName.value,
        accountType: accountType == null ? this.accountType : accountType.value,
        walletAddress:
            walletAddress == null ? this.walletAddress : walletAddress.value,
        isDefault: isDefault == null ? this.isDefault : isDefault.value,
        isActive: isActive == null ? this.isActive : isActive.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  PaymentMethod.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _type = amplify_core.enumFromString<PaymentMethodType>(
            json['type'], PaymentMethodType.values),
        _name = json['name'],
        _last4 = json['last4'],
        _expiryMonth = (json['expiryMonth'] as num?)?.toInt(),
        _expiryYear = (json['expiryYear'] as num?)?.toInt(),
        _bankName = json['bankName'],
        _accountType = json['accountType'],
        _walletAddress = json['walletAddress'],
        _isDefault = json['isDefault'],
        _isActive = json['isActive'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'type': amplify_core.enumToString(_type),
        'name': _name,
        'last4': _last4,
        'expiryMonth': _expiryMonth,
        'expiryYear': _expiryYear,
        'bankName': _bankName,
        'accountType': _accountType,
        'walletAddress': _walletAddress,
        'isDefault': _isDefault,
        'isActive': _isActive,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'type': _type,
        'name': _name,
        'last4': _last4,
        'expiryMonth': _expiryMonth,
        'expiryYear': _expiryYear,
        'bankName': _bankName,
        'accountType': _accountType,
        'walletAddress': _walletAddress,
        'isDefault': _isDefault,
        'isActive': _isActive,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<PaymentMethodModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<PaymentMethodModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final LAST4 = amplify_core.QueryField(fieldName: "last4");
  static final EXPIRYMONTH = amplify_core.QueryField(fieldName: "expiryMonth");
  static final EXPIRYYEAR = amplify_core.QueryField(fieldName: "expiryYear");
  static final BANKNAME = amplify_core.QueryField(fieldName: "bankName");
  static final ACCOUNTTYPE = amplify_core.QueryField(fieldName: "accountType");
  static final WALLETADDRESS =
      amplify_core.QueryField(fieldName: "walletAddress");
  static final ISDEFAULT = amplify_core.QueryField(fieldName: "isDefault");
  static final ISACTIVE = amplify_core.QueryField(fieldName: "isActive");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PaymentMethod";
    modelSchemaDefinition.pluralName = "PaymentMethods";

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
        key: PaymentMethod.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.TYPE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.NAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.LAST4,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.EXPIRYMONTH,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.EXPIRYYEAR,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.BANKNAME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.ACCOUNTTYPE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.WALLETADDRESS,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.ISDEFAULT,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.ISACTIVE,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: PaymentMethod.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _PaymentMethodModelType extends amplify_core.ModelType<PaymentMethod> {
  const _PaymentMethodModelType();

  @override
  PaymentMethod fromJson(Map<String, dynamic> jsonData) {
    return PaymentMethod.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'PaymentMethod';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [PaymentMethod] in your schema.
 */
class PaymentMethodModelIdentifier
    implements amplify_core.ModelIdentifier<PaymentMethod> {
  final String id;

  /** Create an instance of PaymentMethodModelIdentifier using [id] the primary key. */
  const PaymentMethodModelIdentifier({required this.id});

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
  String toString() => 'PaymentMethodModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PaymentMethodModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
