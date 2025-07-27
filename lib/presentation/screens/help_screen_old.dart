import 'package:flutter/material.dart';
import 'package:kointos/core/services/faq_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/support_ticket_service.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late final FAQService _faqService;
  late final SupportTicketService _supportService;
  late final TabController _tabController;

  Map<String, List<Map<String, dynamic>>> _faqsByCategory = {};
  bool _isLoading = true;
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _faqService = getService<FAQService>();
    _supportService = getService<SupportTicketService>();
    _tabController = TabController(length: 2, vsync: this);
    _loadFAQs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFAQs() async {
    try {
      final faqsByCategory = await _faqService.getFAQsByCategory();
      setState(() {
        _faqsByCategory = faqsByCategory;
        _categories = faqsByCategory.keys.toList();
        _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Generate some sample FAQs for demo
      _faqs = _generateSampleFAQs();
    }
  }

  List<Map<String, dynamic>> _generateSampleFAQs() {
    return [
      {
        'id': '1',
        'question': 'How do I create an account?',
        'answer':
            'To create an account, tap the "Sign Up" button on the login screen and follow the instructions. You\'ll need to provide your email and create a secure password.',
        'category': 'Getting Started',
      },
      {
        'id': '2',
        'question': 'How do I add cryptocurrencies to my portfolio?',
        'answer':
            'Go to the Portfolio tab and tap the "+" button. Search for the cryptocurrency you want to add, enter the amount you own, and save.',
        'category': 'Trading',
      },
      {
        'id': '3',
        'question': 'Is my data secure?',
        'answer':
            'Yes, we use industry-standard encryption and security measures to protect your data. We never store your private keys or sensitive financial information.',
        'category': 'Security',
      },
      {
        'id': '4',
        'question': 'How do I enable two-factor authentication?',
        'answer':
            'Go to Settings > Security > Two-Factor Authentication and follow the setup instructions using your preferred authenticator app.',
        'category': 'Security',
      },
      {
        'id': '5',
        'question': 'How do I contact support?',
        'answer':
            'You can contact support through the Contact Support option in the Settings menu, or email us directly at support@kointos.com.',
        'category': 'Other',
      },
      {
        'id': '6',
        'question': 'Can I export my transaction history?',
        'answer':
            'Yes, you can export your transaction history from the Transaction History screen by tapping the export button.',
        'category': 'Account',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredFAQs {
    if (_selectedCategory == null) return _faqs;
    return _faqs.where((faq) => faq['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Guides'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFAQTab(),
          _buildGuidesTab(),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return Column(
      children: [
        // Category filter
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryChip('All', _selectedCategory == null);
              }
              final category = _categories[index - 1];
              return _buildCategoryChip(
                  category, _selectedCategory == category);
            },
          ),
        ),
        // FAQ list
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredFAQs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredFAQs.length,
                      itemBuilder: (context, index) {
                        final faq = _filteredFAQs[index];
                        return _buildFAQCard(faq);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildGuidesTab() {
    final guides = [
      {
        'title': 'Getting Started with Kointos',
        'description':
            'Learn the basics of using Kointos for crypto portfolio tracking',
        'icon': Icons.rocket_launch,
      },
      {
        'title': 'Portfolio Management',
        'description':
            'How to effectively track and manage your cryptocurrency investments',
        'icon': Icons.pie_chart,
      },
      {
        'title': 'Security Best Practices',
        'description':
            'Keep your account and data safe with these security tips',
        'icon': Icons.security,
      },
      {
        'title': 'Understanding Market Data',
        'description':
            'Learn how to read and interpret cryptocurrency market information',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Social Features',
        'description':
            'Connect with other crypto enthusiasts and share insights',
        'icon': Icons.people,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Icon(guide['icon'] as IconData,
                  color: Theme.of(context).primaryColor),
            ),
            title: Text(guide['title'] as String),
            subtitle: Text(guide['description'] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showHelpGuide(guide);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory =
                selected ? (category == 'All' ? null : category) : null;
          });
        },
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No FAQs Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedCategory != null
                ? 'No FAQs found for the selected category'
                : 'Check back later for helpful information',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq['question'] ?? 'Question',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['answer'] ?? 'Answer',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (faq['category'] != null) ...[
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(faq['category']),
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpGuide(Map<String, dynamic> guide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              guide['icon'] as IconData,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(guide['title'] as String)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(guide['description'] as String),
              const SizedBox(height: 16),
              const Text(
                'Detailed Help:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_getDetailedHelpContent(guide['title'] as String)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getDetailedHelpContent(String title) {
    switch (title) {
      case 'Getting Started':
        return '''
1. Create your account or log in
2. Set up your profile with your preferences
3. Explore the market to discover cryptocurrencies
4. Start building your portfolio
5. Join the community discussions
''';
      case 'Trading Basics':
        return '''
• Market Orders: Buy/sell immediately at current price
• Limit Orders: Set your desired price and wait
• Stop Loss: Protect your investments from large losses
• Portfolio Diversification: Don't put all eggs in one basket
• Research before investing: Use our analysis tools
''';
      case 'Portfolio Management':
        return '''
• Track your holdings in real-time
• Set price alerts for your cryptocurrencies
• Review performance metrics regularly
• Rebalance your portfolio periodically
• Use our tools to analyze your investment strategy
''';
      case 'Security Best Practices':
        return '''
• Enable two-factor authentication
• Use a strong, unique password
• Never share your login credentials
• Be aware of phishing attempts
• Keep your app updated to the latest version
''';
      case 'Understanding Fees':
        return '''
• Trading fees: Small percentage on each transaction
• Network fees: Required for blockchain transactions
• No hidden fees: All costs are transparent
• Fee discounts available for high-volume traders
• Premium features may have additional costs
''';
      default:
        return 'Comprehensive help content for $title is available. Please check our documentation or contact support for more details.';
    }
  }
}
