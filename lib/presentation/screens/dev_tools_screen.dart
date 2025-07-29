import 'package:flutter/material.dart';
import 'package:kointos/core/services/dummy_data_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/utils/bedrock_permission_checker.dart';
import 'package:kointos/core/services/bedrock_client.dart';
import 'package:kointos/core/services/llm_service.dart';

/// Developer tools screen for initializing dummy data and testing features
class DevToolsScreen extends StatefulWidget {
  const DevToolsScreen({super.key});

  @override
  State<DevToolsScreen> createState() => _DevToolsScreenState();
}

class _DevToolsScreenState extends State<DevToolsScreen> {
  final DummyDataService _dummyDataService = getService<DummyDataService>();
  bool _isInitializing = false;
  bool _isTestingBedrock = false;
  String _bedrockTestResult = '';

  Future<void> _initializeDummyData() async {
    setState(() {
      _isInitializing = true;
    });

    try {
      await _dummyDataService.initializeAllDummyData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dummy data initialized successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to initialize dummy data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _createDummyUsers() async {
    setState(() {
      _isInitializing = true;
    });

    try {
      await _dummyDataService.createDummyUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dummy users created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to create dummy users: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _createDummyPosts() async {
    setState(() {
      _isInitializing = true;
    });

    try {
      await _dummyDataService.createDummyPosts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dummy posts created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to create dummy posts: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _createDummyArticles() async {
    setState(() {
      _isInitializing = true;
    });

    try {
      await _dummyDataService.createDummyArticles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Dummy articles created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to create dummy articles: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _testBedrockConnection() async {
    setState(() {
      _isTestingBedrock = true;
      _bedrockTestResult = 'Testing Bedrock connection...';
    });

    try {
      // Test 1: Check credentials
      final bedrockClient = getService<BedrockClient>();
      final hasCredentials = await bedrockClient.testCredentials();

      if (!hasCredentials) {
        setState(() {
          _bedrockTestResult =
              '❌ Failed to get AWS credentials. Make sure you are logged in.';
        });
        return;
      }

      setState(() {
        _bedrockTestResult =
            '✅ AWS credentials obtained\n🔄 Testing Bedrock API...';
      });

      // Test 2: Try actual LLM call
      final llmService = getService<LLMService>();
      final response = await llmService.generateResponse(
        prompt: 'Hello, this is a test. Please respond briefly.',
        context: {},
        maxTokens: 50,
      );

      if (response.contains('🔴 Bot offline') ||
          response.contains('Bot temporarily offline')) {
        setState(() {
          _bedrockTestResult = '❌ Bedrock API call failed:\n$response\n\n'
              'Troubleshooting:\n'
              '1. Check if Claude 3 Haiku is enabled in AWS Bedrock console\n'
              '2. Verify your AWS region is us-east-1\n'
              '3. Ensure Amplify backend is deployed with proper permissions';
        });
      } else {
        setState(() {
          _bedrockTestResult = '✅ Bedrock connection successful!\n\n'
              'Response: "${response.length > 100 ? response.substring(0, 100) + '...' : response}"\n\n'
              '🎉 Your AI chatbot is working!';
        });
      }
    } catch (e) {
      setState(() {
        _bedrockTestResult = '❌ Error testing Bedrock:\n$e';
      });
    } finally {
      setState(() {
        _isTestingBedrock = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text(
          'Developer Tools',
          style: TextStyle(color: AppTheme.pureWhite),
        ),
        backgroundColor: AppTheme.secondaryBlack,
        iconTheme: const IconThemeData(color: AppTheme.pureWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppTheme.secondaryBlack,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔧 Dummy Data Management',
                      style: TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Initialize the app with realistic dummy data for testing and demonstration.',
                      style: TextStyle(color: AppTheme.greyText, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      title: 'Initialize All Dummy Data',
                      subtitle: 'Creates users, posts, articles, and comments',
                      icon: Icons.rocket_launch,
                      onPressed: _isInitializing ? null : _initializeDummyData,
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      title: 'Create Dummy Users',
                      subtitle: '8 realistic user profiles',
                      icon: Icons.people,
                      onPressed: _isInitializing ? null : _createDummyUsers,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      title: 'Create Dummy Posts',
                      subtitle: '10 social media posts',
                      icon: Icons.post_add,
                      onPressed: _isInitializing ? null : _createDummyPosts,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      title: 'Create Dummy Articles',
                      subtitle: '3 comprehensive articles',
                      icon: Icons.article,
                      onPressed: _isInitializing ? null : _createDummyArticles,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bedrock Testing Card
            Card(
              color: AppTheme.secondaryBlack,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🤖 AI Chatbot Testing',
                      style: TextStyle(
                        color: AppTheme.pureWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Test your AWS Bedrock connection and AI chatbot functionality.',
                      style: TextStyle(color: AppTheme.greyText, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      title: 'Test Bedrock Connection',
                      subtitle: 'Verify AWS credentials and Claude API access',
                      icon: Icons.smart_toy,
                      onPressed:
                          _isTestingBedrock ? null : _testBedrockConnection,
                      isPrimary: true,
                    ),
                    if (_bedrockTestResult.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _bedrockTestResult.contains('✅')
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _bedrockTestResult.contains('✅')
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        child: Text(
                          _bedrockTestResult,
                          style: TextStyle(
                            color: AppTheme.pureWhite,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BedrockPermissionChecker(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.security,
                          color: AppTheme.cryptoGold),
                      label: const Text(
                        'Advanced Bedrock Diagnostics',
                        style: TextStyle(color: AppTheme.cryptoGold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.cryptoGold),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              color: AppTheme.secondaryBlack,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Important Notes',
                      style: TextStyle(
                        color: AppTheme.cryptoGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Only use in development/testing environments\n'
                      '• Dummy data will be stored in your Amplify backend\n'
                      '• You can delete dummy data from the AWS console\n'
                      '• Initialize data before testing social features',
                      style: TextStyle(color: AppTheme.greyText, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            if (_isInitializing || _isTestingBedrock) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.cryptoGold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _isTestingBedrock
                      ? 'Testing Bedrock connection...'
                      : 'Initializing dummy data...',
                  style:
                      const TextStyle(color: AppTheme.greyText, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppTheme.cryptoGold : AppTheme.cardBlack,
          foregroundColor:
              isPrimary ? AppTheme.primaryBlack : AppTheme.pureWhite,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPrimary
                          ? AppTheme.primaryBlack
                          : AppTheme.pureWhite,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPrimary
                          ? AppTheme.primaryBlack.withValues(alpha: 0.7)
                          : AppTheme.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isPrimary ? AppTheme.primaryBlack : AppTheme.greyText,
            ),
          ],
        ),
      ),
    );
  }
}
