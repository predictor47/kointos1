import 'package:flutter/material.dart';
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Define the CommunityPost class if it doesn't exist elsewhere
class CommunityPost {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final String topicName;
  final DateTime timestamp;
  final int upvotes;
  final int downvotes;
  final int commentCount;
  final bool isUpvoted;
  final bool isDownvoted;
  final List<String> tags;

  const CommunityPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.topicName,
    required this.timestamp,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    this.isUpvoted = false,
    this.isDownvoted = false,
    this.tags = const [],
  });
}

class CommunityPostWidget extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const CommunityPostWidget({
    super.key,
    required this.post,
    required this.onUpvote,
    required this.onDownvote,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Author avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      (post.authorAvatar ?? (post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?')),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                // Author info and timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.authorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              post.topicName,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTimestamp(post.timestamp),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options
                IconButton(
                  onPressed: () => _showMoreOptions(context),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Content
                Text(
                  post.content,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Tags
                if (post.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: post.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    )).toList(),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          // Interaction bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Upvote button
                _buildInteractionButton(
                  icon: Icons.arrow_upward,
                  count: post.upvotes,
                  isActive: post.isUpvoted,
                  activeColor: Colors.green,
                  onTap: onUpvote,
                ),
                const SizedBox(width: 16),
                // Downvote button
                _buildInteractionButton(
                  icon: Icons.arrow_downward,
                  count: post.downvotes,
                  isActive: post.isDownvoted,
                  activeColor: Colors.red,
                  onTap: onDownvote,
                ),
                const Spacer(),
                // Comment button
                _buildInteractionButton(
                  icon: Icons.comment_outlined,
                  count: post.commentCount,
                  isActive: false,
                  activeColor: AppTheme.primaryColor,
                  onTap: onComment,
                  showCount: true,
                ),
                const SizedBox(width: 16),
                // Share button
                GestureDetector(
                  onTap: onShare,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: Colors.white54,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Share',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 0.3,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    ).fadeIn(duration: 400.ms);
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required int count,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
    bool showCount = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Colors.white54,
              size: 18,
            ),
            if (showCount && count > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: TextStyle(
                  color: isActive ? activeColor : Colors.white54,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Options
              _buildBottomSheetOption(
                context,
                icon: Icons.bookmark_outline,
                title: 'Save Post',
                onTap: () {
                  Navigator.pop(context);
                  // Implement save functionality
                },
              ),
              _buildBottomSheetOption(
                context,
                icon: Icons.report_outlined,
                title: 'Report Post',
                onTap: () {
                  Navigator.pop(context);
                  // Implement report functionality
                },
              ),
              _buildBottomSheetOption(
                context,
                icon: Icons.block_outlined,
                title: 'Hide Post',
                onTap: () {
                  Navigator.pop(context);
                  // Implement hide functionality
                },
              ),
              _buildBottomSheetOption(
                context,
                icon: Icons.person_off_outlined,
                title: 'Block User',
                onTap: () {
                  Navigator.pop(context);
                  // Implement block functionality
                },
                isDestructive: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
