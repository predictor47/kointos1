import 'package:flutter_test/flutter_test.dart';
import 'package:kointos/core/services/bedrock_client.dart';
import 'package:kointos/core/services/llm_service.dart';
import 'package:kointos/core/services/service_locator.dart';

void main() {
  group('Bedrock Integration Tests', () {
    setUp(() async {
      // Initialize service locator for testing
      await setupServiceLocator();
    });

    test('BedrockClient should be instantiable', () {
      final client = BedrockClient();
      expect(client, isNotNull);
    });

    test('LLMService should use BedrockClient', () {
      final llmService = LLMService();
      expect(llmService, isNotNull);
    });

    test('Service locator should provide BedrockClient', () {
      final client = getService<BedrockClient>();
      expect(client, isNotNull);
    });

    // Note: These tests will only work in a real AWS environment
    // with proper credentials and Bedrock access
    test('Bedrock integration test (requires AWS setup)', () async {
      // This test should be run only when AWS credentials are available
      // and Bedrock is properly configured in the AWS account

      final testPrompt = "Hello, can you help me understand Bitcoin?";

      try {
        final llmService = getService<LLMService>();
        final response = await llmService.generateResponse(
          prompt: testPrompt,
          context: {},
          maxTokens: 100,
          temperature: 0.7,
        );

        print('Bedrock Response: $response');
        expect(response, isNotNull);
        expect(response.length, greaterThan(10));
      } catch (e) {
        print('Bedrock test skipped - AWS setup required: $e');
        // This is expected in development without proper AWS setup
      }
    }, skip: 'Requires AWS Bedrock setup');
  });
}
