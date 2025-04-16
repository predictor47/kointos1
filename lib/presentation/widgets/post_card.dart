import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
              if (post.images.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildImages(),
              ],
              const SizedBox(height: 12),
              _buildInteractions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: post.authorAvatar.isNotEmpty
              ? NetworkImage(post.authorAvatar)
              : null,
          backgroundColor: AppTheme.primaryWithAlpha(25),
          child: post.authorAvatar.isEmpty
              ? Text(
                  post.authorName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(post.createdAt),
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.content,
          style: const TextStyle(fontSize: 16),
        ),
        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWithAlpha(25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildImages() {
    if (post.images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < post.images.length - 1 ? 8 : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.images[index],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractions() {
    return Row(
      children: [
        _buildInteractionButton(
          icon: Icons.thumb_up_outlined,
          count: post.likesCount,
          onTap: onLike,
          isActive: post.isLiked,
        ),
        const SizedBox(width: 16),
        _buildInteractionButton(
          icon: Icons.comment_outlined,
          count: post.commentsCount,
          onTap: onComment,
        ),
        const SizedBox(width: 16),
        _buildInteractionButton(
          icon: Icons.share_outlined,
          onTap: onShare,
        ),
      ],
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    int? count,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    final color =
        isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
