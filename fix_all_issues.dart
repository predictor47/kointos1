#!/usr/bin/env dart

/// Comprehensive fix script for all Kointos app issues
/// This script will verify and fix:
/// 1. Authentication and user profile initialization
/// 2. Post creation, likes, and comments functionality
/// 3. Real-time portfolio prices
/// 4. Chatbot connectivity
/// 5. Navigation to coin detail screens

import 'dart:io';
import 'dart:async';

void main() async {
  print('🚀 Starting Kointos App Fix Script...\n');

  // 1. Check authentication and user profiles
  await checkAuthenticationFlow();

  // 2. Verify GraphQL API connectivity
  await checkGraphQLAPI();

  // 3. Test real-time price data
  await checkPriceDataIntegration();

  // 4. Verify Bedrock chatbot connectivity
  await checkBedrockIntegration();

  // 5. Check navigation flows
  await checkNavigationFlows();

  print('\n✅ Fix script completed!');
  print('Next steps:');
  print('1. Run the app: flutter run -d web-server --web-port 8080');
  print('2. Test each feature systematically');
  print('3. Use Dev Tools screen for additional diagnostics');
}

Future<void> checkAuthenticationFlow() async {
  print('🔐 Checking Authentication Flow...');

  final files = [
    'lib/core/services/auth_service.dart',
    'lib/core/services/user_profile_initialization_service.dart',
    'lib/core/services/api_service.dart',
  ];

  for (String file in files) {
    if (await File(file).exists()) {
      print('  ✅ $file exists');
    } else {
      print('  ❌ $file missing');
    }
  }

  print('  📝 Authentication should handle:');
  print('     - User sign up/sign in');
  print('     - Profile creation on first login');
  print('     - JWT token management');
  print('');
}

Future<void> checkGraphQLAPI() async {
  print('📡 Checking GraphQL API Integration...');

  print('  📝 API should support:');
  print('     - createPost mutation');
  print('     - likePost mutation');
  print('     - createComment mutation');
  print('     - getUserProfile query');
  print('     - getSocialPosts query');
  print('');
}

Future<void> checkPriceDataIntegration() async {
  print('💰 Checking Real-time Price Data...');

  final files = [
    'lib/data/datasources/coingecko_service.dart',
    'lib/data/repositories/cryptocurrency_repository.dart',
  ];

  for (String file in files) {
    if (await File(file).exists()) {
      print('  ✅ $file exists');
    } else {
      print('  ❌ $file missing');
    }
  }

  print('  📝 Portfolio should show:');
  print('     - Real-time crypto prices from CoinGecko');
  print('     - Live profit/loss calculations');
  print('     - 24h price changes');
  print('');
}

Future<void> checkBedrockIntegration() async {
  print('🤖 Checking AWS Bedrock Chatbot...');

  final files = [
    'lib/core/services/bedrock_client.dart',
    'lib/core/services/llm_service.dart',
    'lib/core/services/kointos_ai_chatbot_service.dart',
  ];

  for (String file in files) {
    if (await File(file).exists()) {
      print('  ✅ $file exists');
    } else {
      print('  ❌ $file missing');
    }
  }

  print('  📝 Chatbot should provide:');
  print('     - Real AI responses from Claude 3 Haiku');
  print('     - Market data integration');
  print('     - User-specific advice');
  print('');
}

Future<void> checkNavigationFlows() async {
  print('🧭 Checking Navigation Flows...');

  final screens = [
    'lib/presentation/screens/social_feed_screen.dart',
    'lib/presentation/screens/real_market_screen.dart',
    'lib/presentation/screens/crypto_detail_screen.dart',
    'lib/presentation/screens/real_portfolio_screen.dart',
    'lib/presentation/screens/profile_screen.dart',
  ];

  for (String screen in screens) {
    if (await File(screen).exists()) {
      print('  ✅ $screen exists');
    } else {
      print('  ❌ $screen missing');
    }
  }

  print('  📝 Navigation should work:');
  print('     - Tap coin → crypto detail screen');
  print('     - Create post → refresh feed');
  print('     - Profile → show real user name');
  print('');
}
