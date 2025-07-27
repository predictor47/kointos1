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

/** This is an auto generated class representing the UserSettings type in your schema. */
class UserSettings extends amplify_core.Model {
  static const classType = const _UserSettingsModelType();
  final String id;
  final String? _userId;
  final UserSettingsTheme? _theme;
  final String? _language;
  final String? _currency;
  final bool? _notificationsEnabled;
  final bool? _emailNotifications;
  final bool? _pushNotifications;
  final bool? _marketAlerts;
  final bool? _portfolioPrivacy;
  final bool? _twoFactorEnabled;
  final bool? _biometricEnabled;
  final int? _dataRetention;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  UserSettingsModelIdentifier get modelIdentifier {
    return UserSettingsModelIdentifier(id: id);
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

  UserSettingsTheme? get theme {
    return _theme;
  }

  String? get language {
    return _language;
  }

  String? get currency {
    return _currency;
  }

  bool? get notificationsEnabled {
    return _notificationsEnabled;
  }

  bool? get emailNotifications {
    return _emailNotifications;
  }

  bool? get pushNotifications {
    return _pushNotifications;
  }

  bool? get marketAlerts {
    return _marketAlerts;
  }

  bool? get portfolioPrivacy {
    return _portfolioPrivacy;
  }

  bool? get twoFactorEnabled {
    return _twoFactorEnabled;
  }

  bool? get biometricEnabled {
    return _biometricEnabled;
  }

  int? get dataRetention {
    return _dataRetention;
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const UserSettings._internal(
      {required this.id,
      required userId,
      theme,
      language,
      currency,
      notificationsEnabled,
      emailNotifications,
      pushNotifications,
      marketAlerts,
      portfolioPrivacy,
      twoFactorEnabled,
      biometricEnabled,
      dataRetention,
      createdAt,
      updatedAt})
      : _userId = userId,
        _theme = theme,
        _language = language,
        _currency = currency,
        _notificationsEnabled = notificationsEnabled,
        _emailNotifications = emailNotifications,
        _pushNotifications = pushNotifications,
        _marketAlerts = marketAlerts,
        _portfolioPrivacy = portfolioPrivacy,
        _twoFactorEnabled = twoFactorEnabled,
        _biometricEnabled = biometricEnabled,
        _dataRetention = dataRetention,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory UserSettings(
      {String? id,
      required String userId,
      UserSettingsTheme? theme,
      String? language,
      String? currency,
      bool? notificationsEnabled,
      bool? emailNotifications,
      bool? pushNotifications,
      bool? marketAlerts,
      bool? portfolioPrivacy,
      bool? twoFactorEnabled,
      bool? biometricEnabled,
      int? dataRetention,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return UserSettings._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        userId: userId,
        theme: theme,
        language: language,
        currency: currency,
        notificationsEnabled: notificationsEnabled,
        emailNotifications: emailNotifications,
        pushNotifications: pushNotifications,
        marketAlerts: marketAlerts,
        portfolioPrivacy: portfolioPrivacy,
        twoFactorEnabled: twoFactorEnabled,
        biometricEnabled: biometricEnabled,
        dataRetention: dataRetention,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSettings &&
        id == other.id &&
        _userId == other._userId &&
        _theme == other._theme &&
        _language == other._language &&
        _currency == other._currency &&
        _notificationsEnabled == other._notificationsEnabled &&
        _emailNotifications == other._emailNotifications &&
        _pushNotifications == other._pushNotifications &&
        _marketAlerts == other._marketAlerts &&
        _portfolioPrivacy == other._portfolioPrivacy &&
        _twoFactorEnabled == other._twoFactorEnabled &&
        _biometricEnabled == other._biometricEnabled &&
        _dataRetention == other._dataRetention &&
        _createdAt == other._createdAt &&
        _updatedAt == other._updatedAt;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("UserSettings {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("theme=" +
        (_theme != null ? amplify_core.enumToString(_theme)! : "null") +
        ", ");
    buffer.write("language=" + "$_language" + ", ");
    buffer.write("currency=" + "$_currency" + ", ");
    buffer.write("notificationsEnabled=" +
        (_notificationsEnabled != null
            ? _notificationsEnabled.toString()
            : "null") +
        ", ");
    buffer.write("emailNotifications=" +
        (_emailNotifications != null
            ? _emailNotifications.toString()
            : "null") +
        ", ");
    buffer.write("pushNotifications=" +
        (_pushNotifications != null ? _pushNotifications.toString() : "null") +
        ", ");
    buffer.write("marketAlerts=" +
        (_marketAlerts != null ? _marketAlerts.toString() : "null") +
        ", ");
    buffer.write("portfolioPrivacy=" +
        (_portfolioPrivacy != null ? _portfolioPrivacy.toString() : "null") +
        ", ");
    buffer.write("twoFactorEnabled=" +
        (_twoFactorEnabled != null ? _twoFactorEnabled.toString() : "null") +
        ", ");
    buffer.write("biometricEnabled=" +
        (_biometricEnabled != null ? _biometricEnabled.toString() : "null") +
        ", ");
    buffer.write("dataRetention=" +
        (_dataRetention != null ? _dataRetention.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  UserSettings copyWith(
      {String? userId,
      UserSettingsTheme? theme,
      String? language,
      String? currency,
      bool? notificationsEnabled,
      bool? emailNotifications,
      bool? pushNotifications,
      bool? marketAlerts,
      bool? portfolioPrivacy,
      bool? twoFactorEnabled,
      bool? biometricEnabled,
      int? dataRetention,
      amplify_core.TemporalDateTime? createdAt,
      amplify_core.TemporalDateTime? updatedAt}) {
    return UserSettings._internal(
        id: id,
        userId: userId ?? this.userId,
        theme: theme ?? this.theme,
        language: language ?? this.language,
        currency: currency ?? this.currency,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        emailNotifications: emailNotifications ?? this.emailNotifications,
        pushNotifications: pushNotifications ?? this.pushNotifications,
        marketAlerts: marketAlerts ?? this.marketAlerts,
        portfolioPrivacy: portfolioPrivacy ?? this.portfolioPrivacy,
        twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        dataRetention: dataRetention ?? this.dataRetention,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  UserSettings copyWithModelFieldValues(
      {ModelFieldValue<String>? userId,
      ModelFieldValue<UserSettingsTheme?>? theme,
      ModelFieldValue<String?>? language,
      ModelFieldValue<String?>? currency,
      ModelFieldValue<bool?>? notificationsEnabled,
      ModelFieldValue<bool?>? emailNotifications,
      ModelFieldValue<bool?>? pushNotifications,
      ModelFieldValue<bool?>? marketAlerts,
      ModelFieldValue<bool?>? portfolioPrivacy,
      ModelFieldValue<bool?>? twoFactorEnabled,
      ModelFieldValue<bool?>? biometricEnabled,
      ModelFieldValue<int?>? dataRetention,
      ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
      ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt}) {
    return UserSettings._internal(
        id: id,
        userId: userId == null ? this.userId : userId.value,
        theme: theme == null ? this.theme : theme.value,
        language: language == null ? this.language : language.value,
        currency: currency == null ? this.currency : currency.value,
        notificationsEnabled: notificationsEnabled == null
            ? this.notificationsEnabled
            : notificationsEnabled.value,
        emailNotifications: emailNotifications == null
            ? this.emailNotifications
            : emailNotifications.value,
        pushNotifications: pushNotifications == null
            ? this.pushNotifications
            : pushNotifications.value,
        marketAlerts:
            marketAlerts == null ? this.marketAlerts : marketAlerts.value,
        portfolioPrivacy: portfolioPrivacy == null
            ? this.portfolioPrivacy
            : portfolioPrivacy.value,
        twoFactorEnabled: twoFactorEnabled == null
            ? this.twoFactorEnabled
            : twoFactorEnabled.value,
        biometricEnabled: biometricEnabled == null
            ? this.biometricEnabled
            : biometricEnabled.value,
        dataRetention:
            dataRetention == null ? this.dataRetention : dataRetention.value,
        createdAt: createdAt == null ? this.createdAt : createdAt.value,
        updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value);
  }

  UserSettings.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _userId = json['userId'],
        _theme = amplify_core.enumFromString<UserSettingsTheme>(
            json['theme'], UserSettingsTheme.values),
        _language = json['language'],
        _currency = json['currency'],
        _notificationsEnabled = json['notificationsEnabled'],
        _emailNotifications = json['emailNotifications'],
        _pushNotifications = json['pushNotifications'],
        _marketAlerts = json['marketAlerts'],
        _portfolioPrivacy = json['portfolioPrivacy'],
        _twoFactorEnabled = json['twoFactorEnabled'],
        _biometricEnabled = json['biometricEnabled'],
        _dataRetention = (json['dataRetention'] as num?)?.toInt(),
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': _userId,
        'theme': amplify_core.enumToString(_theme),
        'language': _language,
        'currency': _currency,
        'notificationsEnabled': _notificationsEnabled,
        'emailNotifications': _emailNotifications,
        'pushNotifications': _pushNotifications,
        'marketAlerts': _marketAlerts,
        'portfolioPrivacy': _portfolioPrivacy,
        'twoFactorEnabled': _twoFactorEnabled,
        'biometricEnabled': _biometricEnabled,
        'dataRetention': _dataRetention,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'userId': _userId,
        'theme': _theme,
        'language': _language,
        'currency': _currency,
        'notificationsEnabled': _notificationsEnabled,
        'emailNotifications': _emailNotifications,
        'pushNotifications': _pushNotifications,
        'marketAlerts': _marketAlerts,
        'portfolioPrivacy': _portfolioPrivacy,
        'twoFactorEnabled': _twoFactorEnabled,
        'biometricEnabled': _biometricEnabled,
        'dataRetention': _dataRetention,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<UserSettingsModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<UserSettingsModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final THEME = amplify_core.QueryField(fieldName: "theme");
  static final LANGUAGE = amplify_core.QueryField(fieldName: "language");
  static final CURRENCY = amplify_core.QueryField(fieldName: "currency");
  static final NOTIFICATIONSENABLED =
      amplify_core.QueryField(fieldName: "notificationsEnabled");
  static final EMAILNOTIFICATIONS =
      amplify_core.QueryField(fieldName: "emailNotifications");
  static final PUSHNOTIFICATIONS =
      amplify_core.QueryField(fieldName: "pushNotifications");
  static final MARKETALERTS =
      amplify_core.QueryField(fieldName: "marketAlerts");
  static final PORTFOLIOPRIVACY =
      amplify_core.QueryField(fieldName: "portfolioPrivacy");
  static final TWOFACTORENABLED =
      amplify_core.QueryField(fieldName: "twoFactorEnabled");
  static final BIOMETRICENABLED =
      amplify_core.QueryField(fieldName: "biometricEnabled");
  static final DATARETENTION =
      amplify_core.QueryField(fieldName: "dataRetention");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserSettings";
    modelSchemaDefinition.pluralName = "UserSettings";

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
        key: UserSettings.USERID,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.THEME,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.LANGUAGE,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.CURRENCY,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.NOTIFICATIONSENABLED,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.EMAILNOTIFICATIONS,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.PUSHNOTIFICATIONS,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.MARKETALERTS,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.PORTFOLIOPRIVACY,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.TWOFACTORENABLED,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.BIOMETRICENABLED,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.DATARETENTION,
        isRequired: false,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.CREATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: UserSettings.UPDATEDAT,
        isRequired: false,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _UserSettingsModelType extends amplify_core.ModelType<UserSettings> {
  const _UserSettingsModelType();

  @override
  UserSettings fromJson(Map<String, dynamic> jsonData) {
    return UserSettings.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'UserSettings';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserSettings] in your schema.
 */
class UserSettingsModelIdentifier
    implements amplify_core.ModelIdentifier<UserSettings> {
  final String id;

  /** Create an instance of UserSettingsModelIdentifier using [id] the primary key. */
  const UserSettingsModelIdentifier({required this.id});

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
  String toString() => 'UserSettingsModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserSettingsModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
