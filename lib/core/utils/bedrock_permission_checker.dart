import 'package:flutter/material.dart';
import 'package:kointos/core/services/bedrock_client.dart';
import 'package:kointos/core/services/llm_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/core/services/service_locator.dart';

/// Bedrock Permission Verification Widget
/// Use this to test if your Amplify app has proper Bedrock access
class BedrockPermissionChecker extends StatefulWidget {
  const BedrockPermissionChecker({Key? key}) : super(key: key);

  @override
  State<BedrockPermissionChecker> createState() =>
      _BedrockPermissionCheckerState();
}

class _BedrockPermissionCheckerState extends State<BedrockPermissionChecker> {
  String _status = 'Ready to test Bedrock permissions';
  bool _isLoading = false;
  bool _hasPermissions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bedrock Permission Test'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔐 Bedrock Permission Checker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will test if your Amplify app can access AWS Bedrock API',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _hasPermissions
                    ? Colors.green.shade50
                    : Colors.orange.shade50,
                border: Border.all(
                  color: _hasPermissions ? Colors.green : Colors.orange,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _hasPermissions ? Icons.check_circle : Icons.warning,
                        color: _hasPermissions ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Status:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_status),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Test buttons
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testBasicConnection,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.security),
              label: const Text('Test Basic Connection'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testFullIntegration,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.chat),
              label: const Text('Test Full AI Integration'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Setup Checklist:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. ✅ Deploy backend: npx ampx sandbox'),
                    Text('2. ✅ Enable Claude 3 Haiku in AWS Bedrock Console'),
                    Text('3. ✅ Ensure user is authenticated in the app'),
                    Text('4. ✅ Check AWS region is us-east-1'),
                    SizedBox(height: 8),
                    Text(
                      'If tests fail, check CloudWatch logs for detailed errors.',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testBasicConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing AWS credentials and basic connectivity...';
      _hasPermissions = false;
    });

    try {
      // Test 1: Check if BedrockClient can be instantiated
      final bedrockClient = getService<BedrockClient>();
      LoggerService.info('✅ BedrockClient instantiated successfully');

      // Test 2: Try to test AWS credentials
      final hasCredentials = await bedrockClient.testCredentials();

      if (hasCredentials) {
        setState(() {
          _status = '✅ AWS credentials obtained successfully!\n'
              'Region: us-east-1\n'
              'IAM Role: Authenticated users\n'
              '✨ Ready for Bedrock API calls!';
          _hasPermissions = true;
        });
        LoggerService.info('✅ AWS credentials test passed');
      } else {
        setState(() {
          _status = '❌ Failed to get AWS credentials.\n'
              'Please ensure:\n'
              '• User is logged in with Cognito\n'
              '• Backend is deployed with IAM policies\n'
              '• App is connected to correct Amplify environment';
        });
        LoggerService.error('❌ AWS credentials test failed');
      }
    } catch (e) {
      setState(() {
        _status = '❌ Connection test failed:\n$e\n\n'
            'Common fixes:\n'
            '• Run: npx ampx sandbox\n'
            '• Check AWS region consistency\n'
            '• Verify user authentication';
      });
      LoggerService.error('❌ Basic connection test failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testFullIntegration() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing full Bedrock + Claude integration...';
      _hasPermissions = false;
    });

    try {
      // Test the complete LLM service flow
      final llmService = getService<LLMService>();

      setState(() {
        _status = 'Calling Claude 3 Haiku via Bedrock API...\n'
            '(This may take 10-30 seconds)';
      });

      final response = await llmService.generateResponse(
        prompt:
            'Hello! This is a test message to verify Bedrock integration. Please respond with a brief confirmation that you can access real-time data.',
        context: {},
        maxTokens: 100,
        temperature: 0.7,
      );

      if (response.isNotEmpty && !response.contains('temporarily offline')) {
        setState(() {
          _status = '🎉 SUCCESS! Full integration working!\n\n'
              'Claude 3 Haiku Response:\n'
              '"${response.length > 200 ? response.substring(0, 200) + '...' : response}"\n\n'
              '✅ Your chatbot is now powered by real AI!';
          _hasPermissions = true;
        });
        LoggerService.info('🎉 Full integration test passed');
      } else {
        setState(() {
          _status =
              '⚠️ Partial success - but Claude returned fallback response:\n'
              '"$response"\n\n'
              'Possible issues:\n'
              '• Claude 3 Haiku not enabled in AWS Bedrock Console\n'
              '• Model access request still pending\n'
              '• Regional configuration mismatch';
        });
        LoggerService.warning(
            '⚠️ Received fallback response instead of Claude');
      }
    } catch (e) {
      setState(() {
        _status = '❌ Full integration test failed:\n$e\n\n'
            'Debug steps:\n'
            '1. Check AWS Bedrock Console → Model access\n'
            '2. Ensure Claude 3 Haiku is enabled\n'
            '3. Verify IAM permissions in CloudFormation\n'
            '4. Check CloudWatch logs for detailed errors';
      });
      LoggerService.error('❌ Full integration test failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
