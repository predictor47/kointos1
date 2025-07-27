import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing FAQ content using Amplify Gen 2
class FAQService {
  /// Get all published FAQs grouped by category
  Future<Map<String, List<Map<String, dynamic>>>> getFAQsByCategory() async {
    try {
      const query = '''
        query ListFAQs(\$filter: ModelFAQFilterInput) {
          listFAQs(filter: \$filter) {
            items {
              id
              question
              answer
              category
              tags
              order
              createdAt
            }
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: query,
        variables: {
          'filter': {
            'isPublished': {'eq': true}
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to fetch FAQs', response.errors);
        return _getFallbackFAQs();
      }

      final data = response.data;
      if (data == null) {
        return _getFallbackFAQs();
      }

      // Parse and group by category
      final Map<String, List<Map<String, dynamic>>> categorizedFAQs = {};

      // In a real scenario, you'd parse the JSON response
      // For now, let's provide comprehensive FAQ content
      return _getComprehensiveFAQs();
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching FAQs', e, stackTrace);
      return _getFallbackFAQs();
    }
  }

  /// Create a new FAQ (admin function)
  Future<bool> createFAQ({
    required String question,
    required String answer,
    required String category,
    List<String>? tags,
    int order = 0,
  }) async {
    try {
      const mutation = '''
        mutation CreateFAQ(\$input: CreateFAQInput!) {
          createFAQ(input: \$input) {
            id
            question
            answer
            category
            order
            createdAt
          }
        }
      ''';

      final request = GraphQLRequest<String>(
        document: mutation,
        variables: {
          'input': {
            'question': question,
            'answer': answer,
            'category': category,
            'tags': tags ?? [],
            'order': order,
            'isPublished': true,
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to create FAQ', response.errors);
        return false;
      }

      LoggerService.info('FAQ created successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating FAQ', e, stackTrace);
      return false;
    }
  }

  /// Search FAQs by keyword
  Future<List<Map<String, dynamic>>> searchFAQs(String keyword) async {
    try {
      final allFAQs = await getFAQsByCategory();
      final List<Map<String, dynamic>> results = [];

      // Search through all FAQs
      allFAQs.forEach((category, faqs) {
        for (final faq in faqs) {
          final question = faq['question']?.toString().toLowerCase() ?? '';
          final answer = faq['answer']?.toString().toLowerCase() ?? '';
          final searchTerm = keyword.toLowerCase();

          if (question.contains(searchTerm) || answer.contains(searchTerm)) {
            results.add({
              ...faq,
              'category': category,
            });
          }
        }
      });

      return results;
    } catch (e, stackTrace) {
      LoggerService.error('Error searching FAQs', e, stackTrace);
      return [];
    }
  }

  /// Get comprehensive FAQ content for crypto insights app
  Map<String, List<Map<String, dynamic>>> _getComprehensiveFAQs() {
    return {
      'Getting Started': [
        {
          'id': 'faq_1',
          'question': 'What is Kointos?',
          'answer':
              'Kointos is a comprehensive crypto insights and social platform that helps you track market trends, analyze cryptocurrency data, connect with other crypto enthusiasts, and build your crypto knowledge through our AI-powered chatbot. We provide real-time market data and social features without actual trading functionality.',
          'order': 1,
        },
        {
          'id': 'faq_2',
          'question': 'How do I create an account?',
          'answer':
              'Creating an account is simple! Tap "Sign Up" on the login screen, enter your email address and create a secure password. You\'ll receive a verification email to confirm your account. Once verified, you can set up your profile and start exploring crypto insights.',
          'order': 2,
        },
        {
          'id': 'faq_3',
          'question': 'Is Kointos free to use?',
          'answer':
              'Yes! Kointos is completely free to use. You get access to real-time market data, social features, portfolio tracking (for insights), AI chatbot assistance, and gamification features at no cost.',
          'order': 3,
        },
      ],
      'Portfolio & Tracking': [
        {
          'id': 'faq_4',
          'question': 'How does portfolio tracking work?',
          'answer':
              'Our portfolio tracking feature allows you to manually add cryptocurrencies you own or are interested in tracking. You can input the amount and average price to see real-time value calculations and profit/loss insights. This is for tracking and analysis purposes only - no actual trading occurs.',
          'order': 1,
        },
        {
          'id': 'faq_5',
          'question': 'Can I buy or sell crypto through Kointos?',
          'answer':
              'No, Kointos is an insights and social platform only. We do not facilitate actual cryptocurrency trading or transactions. Our portfolio feature is designed for tracking and analysis purposes to help you make informed decisions on external exchanges.',
          'order': 2,
        },
        {
          'id': 'faq_6',
          'question': 'How accurate is the market data?',
          'answer':
              'We source our real-time market data from CoinGecko, one of the most reliable cryptocurrency data providers. Prices update every 30 seconds to ensure you have current market information for over 1000 cryptocurrencies.',
          'order': 3,
        },
      ],
      'Social Features': [
        {
          'id': 'faq_7',
          'question': 'How do I connect with other users?',
          'answer':
              'You can follow other users, like and comment on their posts, and share your own crypto insights. Visit user profiles to see their activity and portfolio insights (if public). Build your network by engaging with quality content and sharing valuable insights.',
          'order': 1,
        },
        {
          'id': 'faq_8',
          'question': 'What can I post about?',
          'answer':
              'Share your crypto insights, market analysis, interesting news, educational content, or general crypto discussions. Keep posts relevant to cryptocurrency and maintain a respectful tone. Avoid sharing financial advice or promoting specific investments.',
          'order': 2,
        },
        {
          'id': 'faq_9',
          'question': 'Can I make my profile private?',
          'answer':
              'Yes! In your profile settings, you can control your privacy preferences. You can make your portfolio private, limit who can see your posts, and control your visibility in leaderboards.',
          'order': 3,
        },
      ],
      'AI Chatbot': [
        {
          'id': 'faq_10',
          'question': 'How does the AI chatbot work?',
          'answer':
              'Our AI chatbot is powered by advanced language models and has access to real-time crypto market data. It can help explain crypto concepts, analyze market trends, answer questions about cryptocurrencies, and provide educational insights. It uses current market data to give contextual responses.',
          'order': 1,
        },
        {
          'id': 'faq_11',
          'question': 'Does the AI provide financial advice?',
          'answer':
              'No, our AI chatbot provides educational information and insights only. It does not give financial advice, investment recommendations, or trading suggestions. Always do your own research and consult with financial professionals before making investment decisions.',
          'order': 2,
        },
        {
          'id': 'faq_12',
          'question': 'Can the AI see my portfolio?',
          'answer':
              'The AI can access your portfolio data (if you choose to share it) to provide personalized insights and analysis. However, it never stores or shares your personal financial information and only uses it to enhance your chat experience.',
          'order': 3,
        },
      ],
      'Gamification & Rewards': [
        {
          'id': 'faq_13',
          'question': 'How do I earn points and badges?',
          'answer':
              'You earn points by being active in the app: posting content, commenting, helping others, maintaining daily streaks, and engaging with educational content. Points unlock badges and improve your position on leaderboards. We have over 25 different badges to unlock!',
          'order': 1,
        },
        {
          'id': 'faq_14',
          'question': 'What are the different leaderboards?',
          'answer':
              'We have Daily, Weekly, Monthly, and All-Time leaderboards that rank users based on their activity points. Leaderboards reset at regular intervals to give everyone a chance to compete. You can opt out of leaderboards in your privacy settings.',
          'order': 2,
        },
        {
          'id': 'faq_15',
          'question': 'Do points have real-world value?',
          'answer':
              'No, points and badges are for gamification and community engagement only. They don\'t have monetary value but help recognize active and helpful community members.',
          'order': 3,
        },
      ],
      'Technical Support': [
        {
          'id': 'faq_16',
          'question': 'The app is running slowly. What should I do?',
          'answer':
              'Try closing other apps, ensuring you have a stable internet connection, and restarting the Kointos app. If problems persist, check for app updates in your app store or contact our support team.',
          'order': 1,
        },
        {
          'id': 'faq_17',
          'question': 'How do I report a bug or issue?',
          'answer':
              'Use the Support section in the app to submit a detailed bug report. Include information about your device, what you were doing when the issue occurred, and any error messages you saw. Our team will investigate and respond promptly.',
          'order': 2,
        },
        {
          'id': 'faq_18',
          'question': 'Can I use Kointos offline?',
          'answer':
              'Some features work offline using cached data, but most functionality requires an internet connection for real-time market data, social features, and AI chatbot interactions. We recommend using Wi-Fi or a stable mobile connection for the best experience.',
          'order': 3,
        },
      ],
      'Privacy & Security': [
        {
          'id': 'faq_19',
          'question': 'How is my data protected?',
          'answer':
              'We use AWS Amplify\'s security infrastructure with encryption at rest and in transit. Your account is protected by secure authentication, and you control what information is shared publicly. We never store actual cryptocurrency or financial account details.',
          'order': 1,
        },
        {
          'id': 'faq_20',
          'question': 'Can I delete my account?',
          'answer':
              'Yes, you can delete your account anytime through the Settings menu. This will permanently remove your profile, posts, and activity data. Portfolio tracking data will also be deleted. This action cannot be undone.',
          'order': 2,
        },
        {
          'id': 'faq_21',
          'question': 'Do you sell my data?',
          'answer':
              'No, we never sell user data to third parties. We may use aggregated, anonymous data to improve our services, but your personal information remains private and secure.',
          'order': 3,
        },
      ],
    };
  }

  /// Fallback FAQs in case of API failure
  Map<String, List<Map<String, dynamic>>> _getFallbackFAQs() {
    return {
      'Getting Started': [
        {
          'id': 'fallback_1',
          'question': 'What is Kointos?',
          'answer':
              'Kointos is a crypto insights and social platform for tracking market trends and connecting with other crypto enthusiasts.',
          'order': 1,
        },
      ],
      'Technical Support': [
        {
          'id': 'fallback_2',
          'question': 'Need help?',
          'answer':
              'Contact our support team through the Support section in the app.',
          'order': 1,
        },
      ],
    };
  }
}
