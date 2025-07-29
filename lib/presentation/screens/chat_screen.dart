import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/presentation/widgets/platform_widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String? avatarUrl;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.username,
    this.avatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _apiService = getService<ApiService>();
  final _authService = getService<AuthService>();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _currentUserId;

  late AnimationController _typingController;
  bool _isOtherUserTyping = false;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _loadMessages();
  }

  @override
  void dispose() {
    _typingController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    try {
      _currentUserId = await _authService.getCurrentUserId();

      // In a real app, this would load messages from the backend
      // For now, we'll simulate some messages
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _messages = _generateDemoMessages();
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading messages: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<ChatMessage> _generateDemoMessages() {
    return [
      ChatMessage(
        id: '1',
        senderId: widget.userId,
        receiverId: _currentUserId!,
        content:
            'Hey! I saw your article about DeFi protocols. Really insightful! 🚀',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: _currentUserId!,
        receiverId: widget.userId,
        content:
            'Thanks! I\'ve been researching DeFi for a while now. What did you think about the yield farming section?',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: widget.userId,
        receiverId: _currentUserId!,
        content:
            'The risk analysis was spot on. Have you tried any of the protocols you mentioned?',
        timestamp:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        senderId: _currentUserId!,
        receiverId: widget.userId,
        content:
            'Yes, I\'m currently providing liquidity on Uniswap V3. The concentrated liquidity feature is amazing but requires active management.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: '5',
        senderId: widget.userId,
        receiverId: _currentUserId!,
        content: 'That\'s interesting! What\'s your APY looking like? 📊',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
    ];
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      // Create temporary message
      final tempMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId!,
        receiverId: widget.userId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        isSending: true,
      );

      setState(() {
        _messages.add(tempMessage);
      });

      _messageController.clear();
      _scrollToBottom();

      // Simulate sending to backend
      await Future.delayed(const Duration(seconds: 1));

      // Update message status
      setState(() {
        final index = _messages.indexWhere((m) => m.id == tempMessage.id);
        if (index != -1) {
          _messages[index] = tempMessage.copyWith(isSending: false);
        }
      });

      // Simulate other user typing and responding
      _simulateOtherUserResponse();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _simulateOtherUserResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isOtherUserTyping = true);
        _typingController.repeat();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isOtherUserTyping = false;
          _messages.add(ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: widget.userId,
            receiverId: _currentUserId!,
            content: _getRandomResponse(),
            timestamp: DateTime.now(),
            isRead: false,
          ));
        });
        _typingController.stop();
        _scrollToBottom();
      }
    });
  }

  String _getRandomResponse() {
    final responses = [
      'That\'s a great point! I hadn\'t considered that angle.',
      'Interesting perspective. Have you looked into the latest market trends?',
      'I agree! The crypto space is evolving so rapidly.',
      'Thanks for sharing. I\'ll definitely check that out.',
      'What are your thoughts on the current market sentiment?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
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
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.cryptoGold),
                    ),
                  )
                : _buildMessageList(),
          ),
          if (_isOtherUserTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.cardBlack,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.pureWhite),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: AppTheme.cryptoGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.username[0].toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Active now',
                  style: TextStyle(
                    color: AppTheme.cryptoGold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppTheme.pureWhite),
          onPressed: () => _showChatOptions(),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == _currentUserId;
        return _buildMessageBubble(message, isMe);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: AppTheme.cryptoGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.cryptoGold : AppTheme.cardBlack,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? AppTheme.primaryBlack : AppTheme.pureWhite,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: isMe
                              ? AppTheme.primaryBlack.withValues(alpha: 0.7)
                              : AppTheme.greyText,
                          fontSize: 11,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isSending
                              ? Icons.access_time
                              : message.isRead
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 14,
                          color: AppTheme.primaryBlack.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(
          begin: isMe ? 0.1 : -0.1,
          end: 0,
        );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: AppTheme.cryptoGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.username[0].toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        curve: Interval(
                          delay,
                          delay + 0.4,
                          curve: Curves.easeInOut,
                        ),
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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppTheme.greyText),
              onPressed: () {
                // Implement file attachment
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBlack,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: AppTheme.pureWhite),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: AppTheme.greyText),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
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
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: AppTheme.cryptoGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSending ? Icons.hourglass_empty : Icons.send_rounded,
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

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: AppTheme.pureWhite),
              title: const Text(
                'View Profile',
                style: TextStyle(color: AppTheme.pureWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to user profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off,
                  color: AppTheme.pureWhite),
              title: const Text(
                'Mute Notifications',
                style: TextStyle(color: AppTheme.pureWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications muted')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text(
                'Block User',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        title: const Text(
          'Block User?',
          style: TextStyle(color: AppTheme.pureWhite),
        ),
        content: Text(
          'Are you sure you want to block ${widget.username}? You won\'t be able to send or receive messages from them.',
          style: const TextStyle(color: AppTheme.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.username} has been blocked'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final bool isSending;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.isSending = false,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    bool? isSending,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isSending: isSending ?? this.isSending,
    );
  }
}
