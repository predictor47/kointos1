import 'package:flutter/material.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/llm_service.dart';
import 'package:kointos/core/services/user_profile_initialization_service.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/core/theme/modern_theme.dart';

/// Comprehensive system diagnostics screen
class SystemDiagnosticsScreen extends StatefulWidget {
  const SystemDiagnosticsScreen({super.key});

  @override
  State<SystemDiagnosticsScreen> createState() =>
      _SystemDiagnosticsScreenState();
}

class _SystemDiagnosticsScreenState extends State<SystemDiagnosticsScreen> {
  final Map<String, String> _testResults = {};
  bool _isRunningTests = false;

  @override
  void initState() {
    super.initState();
    _runAllDiagnostics();
  }

  Future<void> _runAllDiagnostics() async {
    setState(() {
      _isRunningTests = true;
      _testResults.clear();
    });

    await _testAuthentication();
    await _testUserProfile();
    await _testGraphQLAPI();
    await _testCryptoPrices();
    await _testChatbot();

    setState(() {
      _isRunningTests = false;
    });
  }

  Future<void> _testAuthentication() async {
    try {
      final authService = getService<AuthService>();
      final isAuthenticated = await authService.isAuthenticated();
      final userId = await authService.getCurrentUserId();

      setState(() {
        _testResults['Authentication'] = isAuthenticated
            ? '✅ User authenticated (ID: ${userId?.substring(0, 8)}...)'
            : '❌ User not authenticated';
      });
    } catch (e) {
      setState(() {
        _testResults['Authentication'] = '❌ Error: $e';
      });
    }
  }

  Future<void> _testUserProfile() async {
    try {
      final profileService = getService<UserProfileInitializationService>();
      final profile = await profileService.getCurrentUserProfile();

      setState(() {
        _testResults['User Profile'] = profile != null
            ? '✅ Profile exists (${profile['displayName'] ?? 'No name'})'
            : '❌ Profile not found';
      });
    } catch (e) {
      setState(() {
        _testResults['User Profile'] = '❌ Error: $e';
      });
    }
  }

  Future<void> _testGraphQLAPI() async {
    try {
      final apiService = getService<ApiService>();
      final posts = await apiService.getSocialPosts(limit: 1);

      setState(() {
        _testResults['GraphQL API'] =
            '✅ API working (${posts.length} posts loaded)';
      });
    } catch (e) {
      setState(() {
        _testResults['GraphQL API'] = '❌ Error: $e';
      });
    }
  }

  Future<void> _testCryptoPrices() async {
    try {
      final cryptoRepo = getService<CryptocurrencyRepository>();
      final cryptos = await cryptoRepo.getTopCryptocurrencies(perPage: 1);

      setState(() {
        _testResults['Crypto Prices'] = cryptos.isNotEmpty
            ? '✅ Real prices loaded (${cryptos.first.name}: \$${cryptos.first.currentPrice})'
            : '❌ No crypto data';
      });
    } catch (e) {
      setState(() {
        _testResults['Crypto Prices'] = '❌ Error: $e';
      });
    }
  }

  Future<void> _testChatbot() async {
    try {
      final llmService = getService<LLMService>();
      final response = await llmService.generateResponse(
        prompt: 'Test message',
        context: {},
        maxTokens: 50,
      );

      setState(() {
        _testResults['AI Chatbot'] = response.contains('🔴 Bot offline')
            ? '❌ Bot offline - Check Bedrock configuration'
            : '✅ Chatbot responding: ${response.substring(0, 50)}...';
      });
    } catch (e) {
      setState(() {
        _testResults['AI Chatbot'] = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('System Diagnostics',
            style: TextStyle(color: AppTheme.pureWhite)),
        backgroundColor: AppTheme.secondaryBlack,
        iconTheme: const IconThemeData(color: AppTheme.pureWhite),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunningTests ? null : _runAllDiagnostics,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isRunningTests) ...[
              const LinearProgressIndicator(color: AppTheme.cryptoGold),
              const SizedBox(height: 16),
              const Text(
                '🔍 Running diagnostics...',
                style: TextStyle(color: AppTheme.pureWhite, fontSize: 16),
              ),
            ] else ...[
              const Text(
                '🏥 System Health Check',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: _testResults.entries.map((entry) {
                  final isSuccess = entry.value.startsWith('✅');
                  return Card(
                    color: AppTheme.secondaryBlack,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        isSuccess ? Icons.check_circle : Icons.error,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          color: AppTheme.pureWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        entry.value,
                        style: const TextStyle(color: AppTheme.greyText),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRunningTests ? null : _runAllDiagnostics,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Run Full Diagnostics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cryptoGold,
                  foregroundColor: AppTheme.primaryBlack,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
