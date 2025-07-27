import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/services/kointos_ai_chatbot_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/presentation/screens/kointos_bot_screen.dart';

/// Floating AI Assistant that appears on main screens
/// Provides quick access to the AI chatbot functionality
class FloatingAIAssistant extends StatefulWidget {
  const FloatingAIAssistant({super.key});

  @override
  State<FloatingAIAssistant> createState() => _FloatingAIAssistantState();
}

class _FloatingAIAssistantState extends State<FloatingAIAssistant>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isMinimized = false;
  final List<QuickChatMessage> _quickMessages = [];
  final TextEditingController _quickController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _pulseController;
  late AnimationController _expandController;
  late final KointosAIChatbotService _chatbotService;

  bool _isQuickTyping = false;

  @override
  void initState() {
    super.initState();
    _chatbotService = getService<KointosAIChatbotService>();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _addQuickWelcome();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _expandController.dispose();
    _quickController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addQuickWelcome() {
    final welcomeMessage = QuickChatMessage(
      text: "👋 Quick question? I'm here to help with crypto insights!",
      isUser: false,
      timestamp: DateTime.now(),
      quickActions: [
        "BTC price?",
        "Market trends?",
        "Portfolio tips?",
        "Open full chat"
      ],
    );

    setState(() {
      _quickMessages.add(welcomeMessage);
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isMinimized = false;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _minimize() {
    setState(() {
      _isMinimized = true;
      _isExpanded = false;
    });
    _expandController.reverse();
  }

  void _openFullChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const KointosBotScreen(),
      ),
    );
  }

  void _handleQuickAction(String action) {
    if (action == "Open full chat") {
      _openFullChat();
      return;
    }

    _quickController.text = action;
    _sendQuickMessage();
  }

  Future<void> _sendQuickMessage() async {
    final text = _quickController.text.trim();
    if (text.isEmpty) return;

    final userMessage = QuickChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _quickMessages.add(userMessage);
      _isQuickTyping = true;
    });

    _quickController.clear();
    _scrollToBottom();

    try {
      final response = await _chatbotService.processMessage(text);

      final botMessage = QuickChatMessage(
        text: response.text.length > 200
            ? '${response.text.substring(0, 200)}...\n\n💬 Tap "Full Chat" for complete response!'
            : response.text,
        isUser: false,
        timestamp: response.timestamp,
        quickActions: response.text.length > 200
            ? ["Full Chat", "Another question?"]
            : response.suggestedActions.take(3).toList(),
      );

      setState(() {
        _quickMessages.add(botMessage);
        _isQuickTyping = false;
      });
    } catch (e) {
      final errorMessage = QuickChatMessage(
        text:
            "🔧 Quick response failed. Try the full chat for better assistance!",
        isUser: false,
        timestamp: DateTime.now(),
        quickActions: ["Full Chat", "Try again"],
      );

      setState(() {
        _quickMessages.add(errorMessage);
        _isQuickTyping = false;
      });
    }

    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    if (_isMinimized) {
      return _buildMinimizedIndicator();
    }

    return Stack(
      children: [
        // Expanded quick chat
        if (_isExpanded)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 80,
            right: 16,
            child: _buildQuickChat(),
          ),

        // Floating button
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildFloatingButton(),
        ),
      ],
    );
  }

  Widget _buildMinimizedIndicator() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () => setState(() => _isMinimized = false),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.cryptoGold.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cryptoGold.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.smart_toy_rounded,
            color: AppTheme.pureWhite,
            size: 24,
          ),
        ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 2000.ms,
            color: AppTheme.pureWhite.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildQuickChat() {
    return Container(
      width: 320,
      height: 400,
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.cryptoGold.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildQuickHeader(),
          Expanded(child: _buildQuickMessageList()),
          _buildQuickInput(),
        ],
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildQuickHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: AppTheme.cryptoGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.pureWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.pureWhite,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick AI Chat',
                  style: TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fast crypto insights',
                  style: TextStyle(
                    color: AppTheme.pureWhite.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _openFullChat,
            icon: const Icon(Icons.open_in_full,
                color: AppTheme.pureWhite, size: 18),
            tooltip: 'Open full chat',
          ),
          IconButton(
            onPressed: _minimize,
            icon:
                const Icon(Icons.minimize, color: AppTheme.pureWhite, size: 18),
          ),
          IconButton(
            onPressed: _toggleExpanded,
            icon: const Icon(Icons.close, color: AppTheme.pureWhite, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _quickMessages.length + (_isQuickTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isQuickTyping && index == _quickMessages.length) {
          return _buildQuickTypingIndicator();
        }

        final message = _quickMessages[index];
        return _buildQuickMessageBubble(message);
      },
    );
  }

  Widget _buildQuickMessageBubble(QuickChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppTheme.cryptoGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: AppTheme.pureWhite,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? AppTheme.pureWhite
                        : AppTheme.secondaryBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? AppTheme.primaryBlack
                          : AppTheme.pureWhite,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              if (message.isUser) ...[
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppTheme.pureWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryBlack,
                    size: 14,
                  ),
                ),
              ],
            ],
          ),
          if (!message.isUser && message.quickActions.isNotEmpty)
            _buildQuickActions(message.quickActions),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildQuickActions(List<String> actions) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 32),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => _handleQuickAction(action),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.cryptoGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.cryptoGold.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                action,
                style: const TextStyle(
                  color: AppTheme.cryptoGold,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppTheme.cryptoGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.pureWhite,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thinking',
                  style: TextStyle(
                    color: AppTheme.greyText,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _quickController,
                style: const TextStyle(color: AppTheme.pureWhite, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Quick question...',
                  hintStyle: TextStyle(color: AppTheme.greyText, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                maxLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendQuickMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendQuickMessage,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                gradient: AppTheme.cryptoGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: AppTheme.pureWhite,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppTheme.cryptoGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cryptoGold.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.smart_toy_rounded,
          color: AppTheme.pureWhite,
          size: 28,
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
              duration: 2000.ms,
              color: AppTheme.pureWhite.withValues(alpha: 0.3))
          .then()
          .scale(duration: 200.ms, curve: Curves.easeOut),
    );
  }
}

/// Quick chat message model
class QuickChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> quickActions;

  const QuickChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickActions = const [],
  });
}
