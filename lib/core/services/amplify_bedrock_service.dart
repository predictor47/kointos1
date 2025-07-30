import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/auth_service.dart';

/// AWS Bedrock service using Amplify API instead of direct HTTP calls
class AmplifyBedrockService {
  final AuthService _authService = getService<AuthService>();

  /// Invoke Claude model using Amplify API
  Future<Map<String, dynamic>> invokeClaudeModel({
    required String prompt,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      LoggerService.info('Invoking Claude 3 Haiku via Amplify API...');

      // Ensure user is authenticated
      final isAuth = await _authService.isAuthenticated();
      if (!isAuth) {
        throw Exception('User must be authenticated to use AI features');
      }

      // Use Amplify API to call Bedrock through Lambda function
      final request = GraphQLRequest<String>(
        document: '''
          mutation InvokeBedrock(\$prompt: String!, \$maxTokens: Int, \$temperature: Float) {
            invokeBedrock(prompt: \$prompt, maxTokens: \$maxTokens, temperature: \$temperature) {
              response
              usage {
                inputTokens
                outputTokens
              }
            }
          }
        ''',
        variables: {
          'prompt': prompt,
          'maxTokens': maxTokens,
          'temperature': temperature,
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.data != null) {
        LoggerService.info('Claude response received successfully');
        // The response is a JSON string, so decode it first
        final decoded = jsonDecode(response.data!);
        // The mutation returns { "invokeBedrock": { "response": "...", "usage": {...} } }
        return decoded['invokeBedrock'] as Map<String, dynamic>;
      } else if (response.errors.isNotEmpty) {
        LoggerService.error('GraphQL errors: ${response.errors}');
        throw Exception(
            'Bedrock API call failed: ${response.errors.first.message}');
      }

      throw Exception('No data received from Bedrock API');
    } catch (e) {
      LoggerService.error('Error invoking Claude model: $e');
      rethrow;
    }
  }

  /// Test if Bedrock is accessible through Amplify
  Future<bool> testConnection() async {
    try {
      final response = await invokeClaudeModel(
        prompt: 'Hello, this is a test. Please respond briefly.',
        maxTokens: 50,
      );

      return response['response'] != null &&
          (response['response'] as String).isNotEmpty;
    } catch (e) {
      LoggerService.error('Bedrock connection test failed: $e');
      return false;
    }
  }
}
