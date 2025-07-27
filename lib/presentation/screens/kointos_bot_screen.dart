import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/services/kointos_ai_chatbot_service.dart';
import 'package:kointos/core/theme/modern_theme.dart';

/// Advanced AI Assistant Screen for Kointos
/// Features real-time market data integration, user context, and LLM responses
class KointosBotScreen extends StatefulWidget {
  const KointosBotScreen({super.key});

  @override
  State<KointosBotScreen> createState() => _KointosBotScreenState();
}

class _KointosBotScreenState extends State<KointosBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  late final KointosAIChatbotService _chatbotService;
  late AnimationController _typingController;
  late AnimationController _pulseController;

  bool _isTyping = false;
  final bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _chatbotService = KointosAIChatbotService();

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _typingController.dispose();
    _pulseController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text:
          "👋 Hey there! I'm KryptoBot, your intelligent crypto companion powered by real-time market data!\n\n"
          "I can help you with:\n"
          "📊 Live market analysis\n"
          "💼 Portfolio insights\n"
          "📚 Crypto education\n"
          "🎯 Community sentiment\n"
          "📝 Article recommendations\n\n"
          "What would you like to explore today?",
      isUser: false,
      timestamp: DateTime.now(),
      isWelcome: true,
      suggestedActions: [
        "What's Bitcoin's price?",
        "Analyze my portfolio",
        "Explain DeFi to me",
        "Show market sentiment"
      ],
    );

    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();
    _startTypingAnimation();

    try {
      // Process message with AI service
      final response = await _chatbotService.processMessage(text);

      // Add bot response
      final botMessage = ChatMessage(
        text: response.text,
        isUser: false,
        timestamp: response.timestamp,
        confidence: response.confidence,
        hasContext: response.hasContext,
        suggestedActions: response.suggestedActions,
        relatedTopics: response.relatedTopics,
        metadata: response.metadata,
      );

      setState(() {
        _messages.add(botMessage);
        _isTyping = false;
      });
    } catch (e) {
      // Add error message
      final errorMessage = ChatMessage(
        text:
            "🔧 I'm experiencing some technical difficulties. Let me try a different approach!\n\n"
            "In the meantime, check out the Market tab for live prices or browse the latest articles.",
        isUser: false,
        timestamp: DateTime.now(),
        isError: true,
        suggestedActions: [
          "Check market prices",
          "Browse articles",
          "View portfolio"
        ],
      );

      setState(() {
        _messages.add(errorMessage);
        _isTyping = false;
      });
    }

    _stopTypingAnimation();
    _scrollToBottom();
  }

  void _startTypingAnimation() {
    _typingController.repeat();
  }

  void _stopTypingAnimation() {
    _typingController.stop();
    _typingController.reset();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildConnectionStatus(),
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.cardBlack,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              gradient: AppTheme.cryptoGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.pureWhite,
              size: 20,
            ),
          ).animate(onPlay: (controller) => controller.repeat()).shimmer(
              duration: 2000.ms,
              color: AppTheme.pureWhite.withValues(alpha: 0.3)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KryptoBot',
                  style: AppTheme.h3.copyWith(color: AppTheme.pureWhite),
                ),
                Text(
                  _isConnected
                      ? 'AI Assistant • Real-time data'
                      : 'Connecting...',
                  style: AppTheme.caption.copyWith(
                    color:
                        _isConnected ? AppTheme.cryptoGold : AppTheme.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showHelpDialog,
          icon: const Icon(Icons.help_outline, color: AppTheme.pureWhite),
        ),
        IconButton(
          onPressed: _clearChat,
          icon: const Icon(Icons.refresh, color: AppTheme.pureWhite),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    if (!_isConnected) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.orange.withValues(alpha: 0.2),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.orange, size: 16),
            const SizedBox(width: 8),
            Text(
              'Limited connectivity - responses may be delayed',
              style: AppTheme.caption.copyWith(color: Colors.orange),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == _messages.length) {
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                _buildBotAvatar(message),
                const SizedBox(width: 12),
              ],
              Flexible(
                child: _buildMessageContent(message),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 12),
                _buildUserAvatar(),
              ],
            ],
          ),
          if (!message.isUser && message.suggestedActions.isNotEmpty)
            _buildSuggestions(message.suggestedActions),
          if (!message.isUser && message.relatedTopics.isNotEmpty)
            _buildRelatedTopics(message.relatedTopics),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBotAvatar(ChatMessage message) {
    Color avatarColor = AppTheme.cryptoGold;
    IconData avatarIcon = Icons.smart_toy_rounded;

    if (message.isError) {
      avatarColor = Colors.red;
      avatarIcon = Icons.error_outline;
    } else if (message.hasContext) {
      avatarColor = Colors.green;
      avatarIcon = Icons.psychology_rounded;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: avatarColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        avatarIcon,
        color: AppTheme.pureWhite,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppTheme.pureWhite,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: AppTheme.primaryBlack,
        size: 20,
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: message.isUser
            ? AppTheme.pureWhite
            : message.isError
                ? Colors.red.withValues(alpha: 0.1)
                : AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: message.isWelcome
            ? Border.all(color: AppTheme.cryptoGold.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: AppTheme.body1.copyWith(
              color:
                  message.isUser ? AppTheme.primaryBlack : AppTheme.pureWhite,
              height: 1.4,
            ),
          ),
          if (!message.isUser && message.confidence > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  message.hasContext ? Icons.verified : Icons.info_outline,
                  size: 14,
                  color: message.hasContext ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  message.hasContext
                      ? 'With real-time data'
                      : 'General response',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.greyText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 48),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((suggestion) {
          return GestureDetector(
            onTap: () => _onSuggestionTap(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.cryptoGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.cryptoGold.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                suggestion,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.cryptoGold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelatedTopics(List<String> topics) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 48),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: topics.map((topic) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              topic,
              style: AppTheme.caption.copyWith(
                color: AppTheme.greyText,
                fontSize: 10,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppTheme.cryptoGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.pureWhite,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedBuilder(
              animation: _typingController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final animation =
                        Tween<double>(begin: 0.3, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _typingController,
                        curve: Interval(delay, delay + 0.4,
                            curve: Curves.easeInOut),
                      ),
                    );

                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.pureWhite
                                .withValues(alpha: animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBlack,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  style: AppTheme.body1.copyWith(color: AppTheme.pureWhite),
                  decoration: InputDecoration(
                    hintText: 'Ask me about crypto...',
                    hintStyle:
                        AppTheme.body1.copyWith(color: AppTheme.greyText),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: AppTheme.cryptoGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppTheme.pureWhite,
                  size: 20,
                ),
              ),
            )
                .animate(target: _messageController.text.isNotEmpty ? 1 : 0)
                .scale(duration: 200.ms),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        title: Text(
          'How to use KryptoBot',
          style: AppTheme.h3.copyWith(color: AppTheme.pureWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem('💰', 'Price queries',
                'Ask "What\'s Bitcoin\'s price?" or "Show me ETH"'),
            _buildHelpItem('📊', 'Market analysis',
                'Request "Analyze the market" or "Show trends"'),
            _buildHelpItem('💼', 'Portfolio help',
                'Say "Check my portfolio" or "Investment advice"'),
            _buildHelpItem(
                '📚', 'Education', 'Ask "Explain DeFi" or "What is staking?"'),
            _buildHelpItem('🎯', 'Sentiment',
                'Request "Market sentiment" or "Community opinion"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: AppTheme.body1.copyWith(color: AppTheme.cryptoGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.body1.copyWith(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.caption.copyWith(color: AppTheme.greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _addWelcomeMessage();
  }
}

/// Message model for chat interface
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final double confidence;
  final bool hasContext;
  final bool isWelcome;
  final bool isError;
  final List<String> suggestedActions;
  final List<String> relatedTopics;
  final Map<String, dynamic> metadata;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.confidence = 1.0,
    this.hasContext = false,
    this.isWelcome = false,
    this.isError = false,
    this.suggestedActions = const [],
    this.relatedTopics = const [],
    this.metadata = const {},
  });

  bool get isHighConfidence => confidence >= 0.8;
}
