import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/llm_service.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/core/theme/modern_theme.dart';

/// Quick Fix Screen to test and resolve immediate issues
class QuickFixScreen extends StatefulWidget {
  const QuickFixScreen({super.key});

  @override
  State<QuickFixScreen> createState() => _QuickFixScreenState();
}

class _QuickFixScreenState extends State<QuickFixScreen> {
  final List<FixResult> _fixResults = [];
  bool _isRunningFixes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('Quick Fix',
            style: TextStyle(color: AppTheme.pureWhite)),
        backgroundColor: AppTheme.secondaryBlack,
        iconTheme: const IconThemeData(color: AppTheme.pureWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 Quick Fixes for Common Issues',
              style: TextStyle(
                color: AppTheme.pureWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Test buttons for each issue
            _buildFixButton(
              title: 'Test Post Creation',
              subtitle: 'Check if you can create social posts',
              icon: Icons.post_add,
              onPressed: _testPostCreation,
            ),

            _buildFixButton(
              title: 'Test Like Functionality',
              subtitle: 'Try liking/unliking posts',
              icon: Icons.favorite,
              onPressed: _testLikeFunctionality,
            ),

            _buildFixButton(
              title: 'Test Real-time Prices',
              subtitle: 'Check cryptocurrency price data',
              icon: Icons.trending_up,
              onPressed: _testRealTimePrices,
            ),

            _buildFixButton(
              title: 'Test AI Chatbot',
              subtitle: 'Check if Bedrock/Claude is working',
              icon: Icons.smart_toy,
              onPressed: _testChatbot,
            ),

            _buildFixButton(
              title: 'Test User Profile',
              subtitle: 'Check if user profile can be created/retrieved',
              icon: Icons.person,
              onPressed: _testUserProfile,
            ),

            const SizedBox(height: 24),

            if (_fixResults.isNotEmpty) ...[
              const Text(
                'Fix Results:',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _fixResults.length,
                  itemBuilder: (context, index) {
                    final result = _fixResults[index];
                    return Card(
                      color: AppTheme.secondaryBlack,
                      child: ListTile(
                        leading: Icon(
                          result.isSuccess ? Icons.check_circle : Icons.error,
                          color: result.isSuccess ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          result.title,
                          style: const TextStyle(color: AppTheme.pureWhite),
                        ),
                        subtitle: Text(
                          result.message,
                          style: const TextStyle(color: AppTheme.greyText),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (_isRunningFixes) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(color: AppTheme.cryptoGold),
              const SizedBox(height: 8),
              const Text(
                'Running fixes...',
                style: TextStyle(color: AppTheme.greyText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFixButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: _isRunningFixes ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.cardBlack,
          foregroundColor: AppTheme.pureWhite,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.greyText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _testPostCreation() async {
    setState(() => _isRunningFixes = true);

    try {
      final apiService = getService<ApiService>();
      final testPost = await apiService.createPost(
        content:
            'Test post from Quick Fix - ${DateTime.now().millisecondsSinceEpoch}',
        isPublic: true,
      );

      setState(() {
        _fixResults.add(FixResult(
          title: 'Post Creation',
          message: testPost != null
              ? '✅ Successfully created test post'
              : '❌ Failed to create post',
          isSuccess: testPost != null,
        ));
      });
    } catch (e) {
      setState(() {
        _fixResults.add(FixResult(
          title: 'Post Creation',
          message: '❌ Error: $e',
          isSuccess: false,
        ));
      });
    } finally {
      setState(() => _isRunningFixes = false);
    }
  }

  Future<void> _testLikeFunctionality() async {
    setState(() => _isRunningFixes = true);

    try {
      final apiService = getService<ApiService>();
      final posts = await apiService.getSocialPosts(limit: 1);

      if (posts.isNotEmpty) {
        final postId = posts.first['id'];
        final like = await apiService.likePost(postId);

        setState(() {
          _fixResults.add(FixResult(
            title: 'Like Functionality',
            message: like != null
                ? '✅ Successfully liked post'
                : '❌ Failed to like post',
            isSuccess: like != null,
          ));
        });
      } else {
        setState(() {
          _fixResults.add(FixResult(
            title: 'Like Functionality',
            message: '❌ No posts available to test',
            isSuccess: false,
          ));
        });
      }
    } catch (e) {
      setState(() {
        _fixResults.add(FixResult(
          title: 'Like Functionality',
          message: '❌ Error: $e',
          isSuccess: false,
        ));
      });
    } finally {
      setState(() => _isRunningFixes = false);
    }
  }

  Future<void> _testRealTimePrices() async {
    setState(() => _isRunningFixes = true);

    try {
      final cryptoRepo = getService<CryptocurrencyRepository>();
      final cryptos = await cryptoRepo.getTopCryptocurrencies(perPage: 3);

      setState(() {
        _fixResults.add(FixResult(
          title: 'Real-time Prices',
          message: cryptos.isNotEmpty
              ? '✅ Loaded ${cryptos.length} cryptos with real prices'
              : '❌ No cryptocurrency data available',
          isSuccess: cryptos.isNotEmpty,
        ));
      });
    } catch (e) {
      setState(() {
        _fixResults.add(FixResult(
          title: 'Real-time Prices',
          message: '❌ Error: $e',
          isSuccess: false,
        ));
      });
    } finally {
      setState(() => _isRunningFixes = false);
    }
  }

  Future<void> _testChatbot() async {
    setState(() => _isRunningFixes = true);

    try {
      final llmService = getService<LLMService>();

      // Add test for detailed connectivity
      setState(() {
        _fixResults.add(FixResult(
          title: 'AI Chatbot - Starting Test',
          message:
              '🔄 Testing AI connectivity, authentication, and network permissions...',
          isSuccess: true,
        ));
      });

      final response = await llmService.generateResponse(
        prompt: 'Hello, this is a connectivity test from Quick Fix diagnostics',
        context: {},
        maxTokens: 100,
      );

      // Analyze the response for different types of issues
      final lowerResponse = response.toLowerCase();
      bool isWorking = true;
      String diagnosis = '';

      if (lowerResponse.contains('connectivity issues') ||
          lowerResponse.contains('experiencing technical difficulties')) {
        isWorking = false;
        if (lowerResponse.contains('authentication') ||
            lowerResponse.contains('credentials')) {
          diagnosis = '🔐 Issue: AWS authentication/credentials problem';
        } else if (lowerResponse.contains('network') ||
            lowerResponse.contains('connectivity')) {
          diagnosis = '🌐 Issue: Network connectivity or permissions problem';
        } else {
          diagnosis = '⚠️ Issue: AI service connectivity problem';
        }
      } else if (lowerResponse.contains('offline') ||
          lowerResponse.contains('unavailable')) {
        isWorking = false;
        diagnosis = '🔴 Issue: AI service offline';
      } else {
        diagnosis = '✅ AI responding normally';
      }

      setState(() {
        _fixResults.add(FixResult(
          title: 'AI Chatbot - Connection Test',
          message:
              '$diagnosis\nResponse preview: ${response.substring(0, math.min(100, response.length))}${response.length > 100 ? '...' : ''}',
          isSuccess: isWorking,
        ));
      });

      // If there's a network/permission issue, suggest specific fixes
      if (!isWorking) {
        if (diagnosis.contains('Network') ||
            diagnosis.contains('connectivity')) {
          setState(() {
            _fixResults.add(FixResult(
              title: 'Network Permissions Fix',
              message:
                  '💡 Added INTERNET permission to AndroidManifest.xml. For web, check CORS settings. Try refreshing the app.',
              isSuccess: false,
            ));
          });
        }

        if (diagnosis.contains('authentication') ||
            diagnosis.contains('credentials')) {
          setState(() {
            _fixResults.add(FixResult(
              title: 'Authentication Fix Suggestion',
              message:
                  '💡 Try logging out and back in, or refresh the app to restore AWS credentials.',
              isSuccess: false,
            ));
          });
        }
      }
    } catch (e) {
      setState(() {
        _fixResults.add(FixResult(
          title: 'AI Chatbot - Error',
          message:
              '❌ Test failed with error: $e\n💡 This suggests a code-level issue rather than connectivity.',
          isSuccess: false,
        ));
      });
    } finally {
      setState(() => _isRunningFixes = false);
    }
  }

  Future<void> _testUserProfile() async {
    setState(() => _isRunningFixes = true);

    try {
      final userProfileService = getService<UserProfileInitializationService>();
      final apiService = getService<ApiService>();
      final authService = getService<AuthService>();

      // Step 1: Check authentication
      setState(() {
        _fixResults.add(FixResult(
          title: 'User Profile - Auth Check',
          message: '🔄 Checking user authentication...',
          isSuccess: true,
        ));
      });

      // Get current user ID
      final userId = await authService.getCurrentUserId();
      if (userId == null) {
        setState(() {
          _fixResults.add(FixResult(
            title: 'User Profile - Auth Failed',
            message: '❌ No authenticated user found. Please log in again.',
            isSuccess: false,
          ));
        });
        return;
      }

      setState(() {
        _fixResults.add(FixResult(
          title: 'User Profile - Auth Success',
          message: '✅ User authenticated: ${userId.substring(0, 8)}...',
          isSuccess: true,
        ));
      });

      // Step 2: Try to get existing profile
      setState(() {
        _fixResults.add(FixResult(
          title: 'User Profile - Checking Existing',
          message: '🔄 Checking for existing profile in database...',
          isSuccess: true,
        ));
      });

      try {
        final existingProfile = await apiService.getUserProfile(userId);
        if (existingProfile != null) {
          setState(() {
            _fixResults.add(FixResult(
              title: 'User Profile - Found Existing',
              message:
                  '✅ Profile found: ${existingProfile['username'] ?? 'No username'}',
              isSuccess: true,
            ));
          });
          return;
        }
      } catch (e) {
        setState(() {
          _fixResults.add(FixResult(
            title: 'User Profile - Existing Profile Error',
            message: '⚠️ Error checking existing profile: $e',
            isSuccess: false,
          ));
        });
      }

      // Step 3: Try to create new profile
      setState(() {
        _fixResults.add(FixResult(
          title: 'User Profile - Creating New',
          message: '🔄 No existing profile found. Creating new profile...',
          isSuccess: true,
        ));
      });

      final newProfile = await userProfileService.getCurrentUserProfile();
      if (newProfile != null) {
        setState(() {
          _fixResults.add(FixResult(
            title: 'User Profile - Created Successfully',
            message:
                '✅ Profile created: ${newProfile['username'] ?? 'No username'}\nEmail: ${newProfile['email'] ?? 'No email'}',
            isSuccess: true,
          ));
        });
      } else {
        setState(() {
          _fixResults.add(FixResult(
            title: 'User Profile - Creation Failed',
            message:
                '❌ Failed to create user profile. Check GraphQL API connectivity.',
            isSuccess: false,
          ));
        });
      }
    } catch (e) {
      setState(() {
        _fixResults.add(FixResult(
          title: 'User Profile - Test Error',
          message: '❌ Profile test failed: $e',
          isSuccess: false,
        ));
      });
    } finally {
      setState(() => _isRunningFixes = false);
    }
  }
}

class FixResult {
  final String title;
  final String message;
  final bool isSuccess;

  FixResult({
    required this.title,
    required this.message,
    required this.isSuccess,
  });
}
