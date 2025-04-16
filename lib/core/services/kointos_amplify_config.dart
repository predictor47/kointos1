import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:kointos/core/services/logger_service.dart';

class KointosAmplifyConfig {
  static bool _isConfigured = false;

  static Future<void> configureAmplify() async {
    if (_isConfigured) return;

    try {
      // Add Amplify plugins
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);

      // Convert config map to JSON string
      final configString = jsonEncode({
        "UserAgent": "aws-amplify/cli",
        "auth": {
          "plugins": {
            "awsCognitoAuthPlugin": {
              "IdentityManager": {"Default": {}},
              "CognitoUserPool": {
                "Default": {
                  "PoolId": "us-east-1_fEr4jS9my",
                  "AppClientId": "1rtm1g5ref0ud5j845egc5mer0",
                  "Region": "us-east-1"
                }
              },
              "Auth": {
                "Default": {
                  "authenticationFlowType": "USER_SRP_AUTH",
                  "socialProviders": [],
                  "usernameAttributes": ["EMAIL"],
                  "signupAttributes": ["EMAIL"],
                  "passwordProtectionSettings": {
                    "passwordPolicyMinLength": 8,
                    "passwordPolicyCharacters": [
                      "REQUIRES_LOWERCASE",
                      "REQUIRES_UPPERCASE",
                      "REQUIRES_NUMBERS",
                      "REQUIRES_SYMBOLS"
                    ]
                  },
                  "mfaConfiguration": "OFF",
                  "mfaTypes": [],
                  "verificationMechanisms": ["EMAIL"]
                }
              }
            }
          }
        },
        "storage": {
          "plugins": {
            "awsS3StoragePlugin": {
              "bucket":
                  "amplify-kointos-munee-san-amplifydataamplifycodege-dsddvcbzmneu",
              "region": "us-east-1"
            }
          }
        }
      });

      // Configure Amplify with the JSON string
      await Amplify.configure(configString);
      _isConfigured = true;
      LoggerService.info('Amplify configured successfully');
    } catch (e, stackTrace) {
      LoggerService.error('Failed to configure Amplify', e, stackTrace);
      rethrow;
    }
  }

  static Future<bool> isConfigured() async {
    try {
      await Amplify.Auth.getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}
