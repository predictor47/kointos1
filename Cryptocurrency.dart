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

/** This is an auto generated class representing the Cryptocurrency type in your schema. */
class Cryptocurrency extends amplify_core.Model {
  static const classType = const _CryptocurrencyModelType();
  final String id;
  final String? _symbol;
  final String? _name;
  final double? _currentPrice;
  final double? _marketCap;
  final double? _volume24h;
  final double? _priceChange24h;
  final double? _priceChangePercentage24h;
  final String? _logoUrl;
  final String? _description;
  final String? _website;
  final amplify_core.TemporalDateTime? _lastUpdated;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  CryptocurrencyModelIdentifier get modelIdentifier {
    return CryptocurrencyModelIdentifier(id: id);
  }

  String get symbol {
    try {
      return _symbol!;
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

  double? get currentPrice {
    return _currentPrice;
  }

  double? get marketCap {
    return _marketCap;
  }

  double? get volume24h {
    return _volume24h;
  }

  double? get priceChange24h {
    return _priceChange24h;
  }

  double? get priceChangePercentage24h {
    return _priceChangePercentage24h;
  }

  String? get logoUrl {
    return _logoUrl;
  }

  String? get description {
    return _description;
  }

  String? get website {
    return _website;
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

  const Cryptocurrency._internal(
      {required this.id,
      required symbol,
      required name,
      currentPrice,
      marketCap,
      volume24h,
      priceChange24h,
      priceChangePercentage24h,
      logoUrl,
      description,
      website,
      lastUpdated,
      createdAt,
      updatedAt})
      : _symbol = symbol,
        _name = name,
        _currentPrice = currentPrice,
        _marketCap = marketCap,
        _volume24h = volume24h,
        _priceChange24h = priceChange24h,
        _priceChangePercentage24h = priceChangePercentage24h,
        _logoUrl = logoUrl,
        _description = description,
        _website = website,
        _lastUpdated = lastUpdated,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Cryptocurrency(
      {String? id,
      required String symbol,
      required String name,
      double? currentPrice,
      double? marketCap,
      double? volume24h,
      double? priceChange24h,
      double? priceChangePercentage24h,
      String? logoUrl,
      String? description,
      String? website,
      amplify_core.TemporalDateTime? lastUpdated}) {
    return Cryptocurrency._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        symbol: symbol,
        name: name,
        currentPrice: currentPrice,
        marketCap: marketCap,
        volume24h: volume24h,
        priceChange24h: priceChange24h,
        priceChangePercentage24h: priceChangePercentage24h,
        logoUrl: logoUrl,
        description: description,
        website: website,
        lastUpdated: lastUpdated);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Cryptocurrency &&
        id == other.id &&
        _symbol == other._symbol &&
        _name == other._name &&
        _currentPrice == other._currentPrice &&
        _marketCap == other._marketCap &&
        _volume24h == other._volume24h &&
        _priceChange24h == other._priceChange24h &&
        _priceChangePercentage24h == other._priceChangePercentage24h &&
        _logoUrl == other._logoUrl &&
        _description == other._description &&
        _website == other._website &&
        _lastUpdated == other._lastUpdated;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Cryptocurrency {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("symbol=" + "$_symbol" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("currentPrice=" +
        (_currentPrice != null ? _currentPrice.toString() : "null") +
        ", ");
    buffer.write("marketCap=" +
        (_marketCap != null ? _marketCap.toString() : "null") +
        ", ");
    buffer.write("volume24h=" +
        (_volume24h != null ? _volume24h.toString() : "null") +
        ", ");
    buffer.write("priceChange24h=" +
        (_priceChange24h != null ? _priceChange24h.toString() : "null") +
        ", ");
    buffer.write("priceChangePercentage24h=" +
        (_priceChangePercentage24h != null
            ? _priceChangePercentage24h.toString()
            : "null") +
        ", ");
    buffer.write("logoUrl=" + "$_logoUrl" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("website=" + "$_website" + ", ");
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

  Cryptocurrency copyWith(
      {String? symbol,
      String? name,
      double? currentPrice,
      double? marketCap,
      double? volume24h,
      double? priceChange24h,
      double? priceChangePercentage24h,
      String? logoUrl,
      String? description,
      String? website,
      amplify_core.TemporalDateTime? lastUpdated}) {
    return Cryptocurrency._internal(
        id: id,
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        currentPrice: currentPrice ?? this.currentPrice,
        marketCap: marketCap ?? this.marketCap,
        volume24h: volume24h ?? this.volume24h,
        priceChange24h: priceChange24h ?? this.priceChange24h,
        priceChangePercentage24h:
            priceChangePercentage24h ?? this.priceChangePercentage24h,
        logoUrl: logoUrl ?? this.logoUrl,
        description: description ?? this.description,
        website: website ?? this.website,
        lastUpdated: lastUpdated ?? this.lastUpdated);
  }

  Cryptocurrency copyWithModelFieldValues(
      {ModelFieldValue<String>? symbol,
      ModelFieldValue<String>? name,
      ModelFieldValue<double?>? currentPrice,
      ModelFieldValue<double?>? marketCap,
      ModelFieldValue<double?>? volume24h,
      ModelFieldValue<double?>? priceChange24h,
      ModelFieldValue<double?>? priceChangePercentage24h,
      ModelFieldValue<String?>? logoUrl,
      ModelFieldValue<String?>? description,
      ModelFieldValue<String?>? website,
      ModelFieldValue<amplify_core.TemporalDateTime?>? lastUpdated}) {
    return Cryptocurrency._internal(
        id: id,
        symbol: symbol == null ? this.symbol : symbol.value,
        name: name == null ? this.name : name.value,
        currentPrice:
            currentPrice == null ? this.currentPrice : currentPrice.value,
        marketCap: marketCap == null ? this.marketCap : marketCap.value,
        volume24h: volume24h == null ? this.volume24h : volume24h.value,
        priceChange24h:
            priceChange24h == null ? this.priceChange24h : priceChange24h.value,
        priceChangePercentage24h: priceChangePercentage24h == null
            ? this.priceChangePercentage24h
            : priceChangePercentage24h.value,
        logoUrl: logoUrl == null ? this.logoUrl : logoUrl.value,
        description: description == null ? this.description : description.value,
        website: website == null ? this.website : website.value,
        lastUpdated:
            lastUpdated == null ? this.lastUpdated : lastUpdated.value);
  }

  Cryptocurrency.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _symbol = json['symbol'],
        _name = json['name'],
        _currentPrice = (json['currentPrice'] as num?)?.toDouble(),
        _marketCap = (json['marketCap'] as num?)?.toDouble(),
        _volume24h = (json['volume24h'] as num?)?.toDouble(),
        _priceChange24h = (json['priceChange24h'] as num?)?.toDouble(),
        _priceChangePercentage24h =
            (json['priceChangePercentage24h'] as num?)?.toDouble(),
        _logoUrl = json['logoUrl'],
        _description = json['description'],
        _website = json['website'],
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
        'symbol': _symbol,
        'name': _name,
        'currentPrice': _currentPrice,
        'marketCap': _marketCap,
        'volume24h': _volume24h,
        'priceChange24h': _priceChange24h,
        'priceChangePercentage24h': _priceChangePercentage24h,
        'logoUrl': _logoUrl,
        'description': _description,
        'website': _website,
        'lastUpdated': _lastUpdated?.format(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'symbol': _symbol,
        'name': _name,
        'currentPrice': _currentPrice,
        'marketCap': _marketCap,
        'volume24h': _volume24h,
        'priceChange24h': _priceChange24h,
        'priceChangePercentage24h': _priceChangePercentage24h,
        'logoUrl': _logoUrl,
        'description': _description,
        'website': _website,
        'lastUpdated': _lastUpdated,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<CryptocurrencyModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<CryptocurrencyModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SYMBOL = amplify_core.QueryField(fieldName: "symbol");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final CURRENTPRICE =
      amplify_core.QueryField(fieldName: "currentPrice");
  static final MARKETCAP = amplify_core.QueryField(fieldName: "marketCap");
  static final VOLUME24H = amplify_core.QueryField(fieldName: "volume24h");
  static final PRICECHANGE24H =
      amplify_core.QueryField(fieldName: "priceChange24h");
  static final PRICECHANGEPERCENTAGE24H =
      amplify_core.QueryField(fieldName: "priceChangePercentage24h");
  static final LOGOURL = amplify_core.QueryField(fieldName: "logoUrl");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final WEBSITE = amplify_core.QueryField(fieldName: "website");
  static final LASTUPDATED = amplify_core.QueryField(fieldName: "lastUpdated");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Cryptocurrency";
    modelSchemaDefinition.pluralName = "Cryptocurrencies";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PRIVATE,
          operations: const [amplify_core.ModelOperation.READ]),
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
        key: Cryptocurrency.SYMBOL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.NAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.CURRENTPRICE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.MARKETCAP,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.VOLUME24H,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.PRICECHANGE24H,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.PRICECHANGEPERCENTAGE24H,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.LOGOURL,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.DESCRIPTION,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.WEBSITE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Cryptocurrency.LASTUPDATED,
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

class _CryptocurrencyModelType extends amplify_core.ModelType<Cryptocurrency> {
  const _CryptocurrencyModelType();

  @override
  Cryptocurrency fromJson(Map<String, dynamic> jsonData) {
    return Cryptocurrency.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Cryptocurrency';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Cryptocurrency] in your schema.
 */
class CryptocurrencyModelIdentifier
    implements amplify_core.ModelIdentifier<Cryptocurrency> {
  final String id;

  /** Create an instance of CryptocurrencyModelIdentifier using [id] the primary key. */
  const CryptocurrencyModelIdentifier({required this.id});

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
  String toString() => 'CryptocurrencyModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CryptocurrencyModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
