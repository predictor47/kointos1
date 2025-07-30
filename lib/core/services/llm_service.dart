import 'package:kointos/core/services/amplify_bedrock_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';

/// Service for interacting with LLM (Large Language Model) via AWS Bedrock
class LLMService {
  late final AmplifyBedrockService _amplifyBedrockService;

  LLMService() {
    _amplifyBedrockService = getService<AmplifyBedrockService>();
  }

  /// Generate a response using Claude 3 Haiku via Amplify Bedrock integration
  Future<String> generateResponse(
    String prompt, {
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      LoggerService.info('LLMService: Generating response for prompt');

      final result = await _amplifyBedrockService.invokeClaudeModel(
        prompt: prompt,
        maxTokens: maxTokens,
        temperature: temperature,
      );

      if (result['response'] != null) {
        LoggerService.info('LLMService: Successfully generated response');
        return result['response'] as String;
      } else {
        throw Exception('No response generated from Bedrock');
      }
    } catch (e) {
      LoggerService.error('LLMService: Error generating response: $e');
      throw Exception('Failed to generate AI response: $e');
    }
  }

  /// Generate crypto analysis with sentiment and technical indicators
  Future<String> generateCryptoAnalysis(
      String cryptoSymbol, Map<String, dynamic> marketData) async {
    final prompt = '''
Analyze the cryptocurrency $cryptoSymbol with the following market data:
${marketData.toString()}

Please provide:
1. Sentiment analysis (Bullish/Bearish/Neutral)
2. Technical analysis based on price movements
3. Key support and resistance levels if applicable
4. Risk assessment
5. Short-term outlook (24-48 hours)

Keep the analysis concise and actionable for crypto traders.
''';

    return await generateResponse(prompt, maxTokens: 800, temperature: 0.3);
  }

  /// Generate market insights based on multiple cryptocurrencies
  Future<String> generateMarketInsights(
      List<Map<String, dynamic>> cryptoData) async {
    final prompt = '''
Based on the following cryptocurrency market data:
${cryptoData.map((crypto) => '${crypto['symbol']}: ${crypto['current_price']} (${crypto['price_change_percentage_24h']}%)').join('\n')}

Provide market insights including:
1. Overall market sentiment
2. Notable price movements
3. Potential opportunities
4. Risk factors to watch
5. Market trend analysis

Keep it informative but concise for crypto investors.
''';

    return await generateResponse(prompt, maxTokens: 600, temperature: 0.4);
  }

  /// Test connection to Bedrock service
  Future<bool> testConnection() async {
    try {
      final result = await _amplifyBedrockService.testConnection();
      return result;
    } catch (e) {
      LoggerService.error('LLMService: Connection test failed: $e');
      return false;
    }
  }
}
