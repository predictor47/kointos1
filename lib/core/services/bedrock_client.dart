import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:crypto/crypto.dart';

/// AWS Bedrock Runtime Client for Flutter
/// Handles direct communication with AWS Bedrock API
class BedrockClient {
  static const String _region = 'us-east-1';
  static const String _service = 'bedrock-runtime';
  static const String _algorithm = 'AWS4-HMAC-SHA256';

  final http.Client _httpClient;

  BedrockClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Invoke Claude 3 Haiku model via Bedrock
  Future<String?> invokeClaudeModel({
    required String prompt,
    int maxTokens = 500,
    double temperature = 0.7,
    List<String> stopSequences = const [],
  }) async {
    try {
      LoggerService.info('Invoking Claude 3 Haiku via Bedrock...');

      // Get AWS credentials from Amplify
      final credentials = await _getAWSCredentials();
      if (credentials == null) {
        throw Exception('Failed to get AWS credentials');
      }

      // Prepare the request body for Claude 3 Haiku
      final requestBody = {
        'anthropic_version': 'bedrock-2023-05-31',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': prompt,
              }
            ]
          }
        ],
        'max_tokens': maxTokens,
        'temperature': temperature,
        if (stopSequences.isNotEmpty) 'stop_sequences': stopSequences,
      };

      final bodyJson = jsonEncode(requestBody);
      final endpoint = 'https://bedrock-runtime.$_region.amazonaws.com';
      const modelId = 'anthropic.claude-3-haiku-20240307-v1:0';
      final path = '/model/$modelId/invoke';
      final url = '$endpoint$path';

      // Create signed headers
      final signedHeaders = await _createSignedRequest(
        method: 'POST',
        url: url,
        body: bodyJson,
        credentials: credentials,
      );

      // Make the HTTP request
      final response = await _httpClient
          .post(
            Uri.parse(url),
            headers: signedHeaders,
            body: bodyJson,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract Claude's response
        if (responseData['content'] != null &&
            responseData['content'] is List &&
            responseData['content'].isNotEmpty) {
          final content = responseData['content'][0];
          if (content['text'] != null) {
            LoggerService.info('Claude response received successfully');
            return content['text'] as String;
          }
        }

        LoggerService.error('Invalid response format from Claude');
        return null;
      } else {
        final errorBody = response.body;
        LoggerService.error(
            'Bedrock API error ${response.statusCode}: $errorBody');
        return null;
      }
    } catch (e) {
      LoggerService.error('Error invoking Claude model: $e');
      return null;
    }
  }

  /// Get AWS credentials from Amplify Auth
  Future<Map<String, String>?> _getAWSCredentials() async {
    try {
      final authSession = await Amplify.Auth.fetchAuthSession();

      if (authSession is CognitoAuthSession) {
        final credentials = authSession.credentialsResult.value;

        return {
          'accessKeyId': credentials.accessKeyId,
          'secretAccessKey': credentials.secretAccessKey,
          'sessionToken': credentials.sessionToken ?? '',
        };
      }

      return null;
    } catch (e) {
      LoggerService.error('Error getting AWS credentials: $e');
      return null;
    }
  }

  /// Test method to verify AWS credentials (for debugging)
  Future<bool> testCredentials() async {
    try {
      final credentials = await _getAWSCredentials();
      return credentials != null && credentials['accessKeyId']!.isNotEmpty;
    } catch (e) {
      LoggerService.error('Credential test failed: $e');
      return false;
    }
  }

  /// Create AWS Signature Version 4 signed request headers
  Future<Map<String, String>> _createSignedRequest({
    required String method,
    required String url,
    required String body,
    required Map<String, String> credentials,
  }) async {
    final uri = Uri.parse(url);
    final host = uri.host;
    final path = uri.path;
    final query = uri.query;

    final now = DateTime.now().toUtc();
    final dateStamp = _formatDate(now);
    final timeStamp = _formatDateTime(now);

    // Create canonical request
    final payloadHash = _hash(utf8.encode(body));
    final canonicalHeaders = 'content-type:application/json\n'
        'host:$host\n'
        'x-amz-date:$timeStamp\n'
        '${credentials['sessionToken']!.isNotEmpty ? 'x-amz-security-token:${credentials['sessionToken']}\n' : ''}';

    final signedHeaders = 'content-type;host;x-amz-date'
        '${credentials['sessionToken']!.isNotEmpty ? ';x-amz-security-token' : ''}';

    final canonicalRequest = '$method\n'
        '$path\n'
        '$query\n'
        '$canonicalHeaders\n'
        '$signedHeaders\n'
        '$payloadHash';

    // Create string to sign
    final credentialScope = '$dateStamp/$_region/$_service/aws4_request';
    final stringToSign = '$_algorithm\n'
        '$timeStamp\n'
        '$credentialScope\n'
        '${_hash(utf8.encode(canonicalRequest))}';

    // Calculate signature
    final signature = _calculateSignature(
      credentials['secretAccessKey']!,
      dateStamp,
      stringToSign,
    );

    // Create authorization header
    final authorization = '$_algorithm '
        'Credential=${credentials['accessKeyId']}/$credentialScope, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    // Return headers
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Host': host,
      'X-Amz-Date': timeStamp,
      'Authorization': authorization,
    };

    if (credentials['sessionToken']!.isNotEmpty) {
      headers['X-Amz-Security-Token'] = credentials['sessionToken']!;
    }

    return headers;
  }

  /// Calculate AWS Signature Version 4 signature
  String _calculateSignature(
      String secretKey, String dateStamp, String stringToSign) {
    final kDate = _hmacSha256(utf8.encode('AWS4$secretKey'), dateStamp);
    final kRegion = _hmacSha256(kDate, _region);
    final kService = _hmacSha256(kRegion, _service);
    final kSigning = _hmacSha256(kService, 'aws4_request');
    final signature = _hmacSha256(kSigning, stringToSign);

    return signature
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  /// HMAC SHA256 helper
  List<int> _hmacSha256(List<int> key, String data) {
    final hmac = Hmac(sha256, key);
    return hmac.convert(utf8.encode(data)).bytes;
  }

  /// SHA256 hash helper
  String _hash(List<int> data) {
    return sha256.convert(data).toString();
  }

  /// Format date for AWS signature (YYYYMMDD)
  String _formatDate(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}'
        '${dateTime.month.toString().padLeft(2, '0')}'
        '${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// Format datetime for AWS signature (YYYYMMDDTHHMMSSZ)
  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)}T'
        '${dateTime.hour.toString().padLeft(2, '0')}'
        '${dateTime.minute.toString().padLeft(2, '0')}'
        '${dateTime.second.toString().padLeft(2, '0')}Z';
  }
}
