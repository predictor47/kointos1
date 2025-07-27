import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'dart:async';

// Define required classes
enum MessageType { text, image, file }

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isCurrentUser;
  final MessageType messageType;
  final String? imageUrl;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isCurrentUser,
    this.messageType = MessageType.text,
    this.imageUrl,
  });
}

class RealTimeChatScreen extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String? recipientId;
  final String? recipientName;

  const RealTimeChatScreen({
    super.key,
    required this.chatId,
    required this.chatName,
    this.recipientId,
    this.recipientName,
  });

  @override
  State<RealTimeChatScreen> createState() => _RealTimeChatScreenState();
}

class _RealTimeChatScreenState extends State<RealTimeChatScreen>
    with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AuthService _authService = getService<AuthService>();
  late AnimationController _typingAnimationController;
  Timer? _messagePollingTimer;
  String? _currentUserId;
  bool _isTyping = false;
  bool _recipientTyping = false;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _initializeChat();
    _startMessagePolling();
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    _messagePollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    try {
      _currentUserId = await _authService.getCurrentUserId();
      await _loadChatHistory();
    } catch (e) {
      LoggerService.error('Error initializing chat: $e');
    }
  }

  void _startMessagePolling() {
    _messagePollingTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) => _pollForNewMessages(),
    );
  }

  Future<void> _loadChatHistory() async {
    try {
      // Simulate loading chat history
      setState(() {
        _messages.clear();
        _messages.addAll([
          ChatMessage(
            id: '1',
            senderId: widget.recipientId ?? 'other',
            senderName: widget.recipientName ?? 'CryptoTrader',
            content: 'Hey! How\'s your portfolio doing today?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            isCurrentUser: false,
            messageType: MessageType.text,
          ),
          ChatMessage(
            id: '2',
            senderId: _currentUserId ?? 'me',
            senderName: 'You',
            content: 'Pretty good! Bitcoin is up 5% today 🚀',
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
            isCurrentUser: true,
            messageType: MessageType.text,
          ),
        ]);
      });
      _scrollToBottom();
    } catch (e) {
      LoggerService.error('Error loading chat history: $e');
    }
  }

  Future<void> _pollForNewMessages() async {
    // Simulate polling for new messages
    if (mounted && _messages.isNotEmpty) {
      final random = DateTime.now().millisecond % 100;
      if (random < 5 && !_recipientTyping) {
        setState(() {
          _recipientTyping = true;
        });

        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _recipientTyping = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chatName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_recipientTyping)
              const Text(
                'typing...',
                style: TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showChatOptions,
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_recipientTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _recipientTyping) {
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment:
          message.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color:
              message.isCurrentUser ? AppTheme.pureWhite : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: message.isCurrentUser
                ? const Radius.circular(4)
                : const Radius.circular(18),
            bottomLeft: message.isCurrentUser
                ? const Radius.circular(18)
                : const Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isCurrentUser)
              Text(
                message.senderName,
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _typingAnimationController,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.3;
                    final animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _typingAnimationController,
                        curve: Interval(delay, delay + 0.3,
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
                            color: Colors.white
                                .withValues(alpha: 0.5 + 0.5 * animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _showAttachmentOptions,
              icon: const Icon(Icons.attach_file, color: Colors.white70),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlack,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _messageController,
                  onChanged: _onMessageChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: _sendMessage,
                icon: Icon(
                  Icons.send,
                  color: _messageController.text.trim().isNotEmpty
                      ? AppTheme.pureWhite
                      : Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMessageChanged(String text) {
    if (text.trim().isNotEmpty && !_isTyping) {
      setState(() {
        _isTyping = true;
      });

      // Simulate sending typing indicator
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
          });
        }
      });
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _currentUserId ?? 'me',
      senderName: 'You',
      content: message,
      timestamp: DateTime.now(),
      isCurrentUser: true,
      messageType: MessageType.text,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    _scrollToBottom();

    // Generate intelligent response based on message content
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        final response = _generateIntelligentResponse(message);

        final responseMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: widget.recipientId ?? 'other',
          senderName: widget.recipientName ?? 'CryptoTrader',
          content: response,
          timestamp: DateTime.now(),
          isCurrentUser: false,
          messageType: MessageType.text,
        );

        setState(() {
          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    });
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

  String _generateIntelligentResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Crypto-related responses
    if (lowerMessage.contains('bitcoin') || lowerMessage.contains('btc')) {
      return 'Bitcoin is always an exciting topic! 🚀 What\'s your take on its current trend?';
    }
    if (lowerMessage.contains('ethereum') || lowerMessage.contains('eth')) {
      return 'Ethereum has so much potential with its smart contracts! Are you following any DeFi projects?';
    }
    if (lowerMessage.contains('portfolio') ||
        lowerMessage.contains('trading')) {
      return 'Nice! How\'s your portfolio performing? I\'d love to learn from your strategy! 📈';
    }
    if (lowerMessage.contains('price') ||
        lowerMessage.contains('pump') ||
        lowerMessage.contains('dump')) {
      return 'Market movements can be crazy! What indicators are you watching?';
    }
    if (lowerMessage.contains('bullish') || lowerMessage.contains('bearish')) {
      return 'Interesting perspective! What\'s driving your sentiment?';
    }

    // General conversation responses
    if (lowerMessage.contains('?')) {
      return 'That\'s a great question! Let me think about that... 🤔';
    }
    if (lowerMessage.contains('thanks') || lowerMessage.contains('thank you')) {
      return 'You\'re welcome! Happy to chat with fellow crypto enthusiasts! 😊';
    }
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      return 'Hey there! How\'s the crypto market treating you today?';
    }

    // Default responses based on sentiment
    final positiveWords = [
      'good',
      'great',
      'awesome',
      'amazing',
      'love',
      'like',
      'yes'
    ];
    final negativeWords = ['bad', 'terrible', 'hate', 'no', 'down', 'loss'];

    if (positiveWords.any((word) => lowerMessage.contains(word))) {
      return 'That\'s fantastic! 🎉 The crypto space needs more positive energy!';
    }
    if (negativeWords.any((word) => lowerMessage.contains(word))) {
      return 'I hear you... the market can be tough sometimes. But hodling strong! 💪';
    }

    // Fallback responses
    final fallbacks = [
      'That\'s really interesting! Tell me more about your thoughts on this.',
      'I see what you mean! The crypto world is full of surprises.',
      'Thanks for sharing! What made you think about this?',
      'That\'s a solid point! How long have you been following crypto?',
      'Absolutely! The community here is amazing for these discussions.',
    ];

    return fallbacks[DateTime.now().millisecond % fallbacks.length];
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.search, color: Colors.white70),
                title:
                    const Text('Search', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading:
                    const Icon(Icons.notifications_off, color: Colors.white70),
                title:
                    const Text('Mute', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block User',
                    style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.white70),
                title:
                    const Text('Photo', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white70),
                title:
                    const Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.white70),
                title: const Text('Document',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
