import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' hide MarkdownBody;
import 'package:kointos/core/theme/modern_theme.dart';
import 'package:kointos/core/utils/url_utils.dart';
import 'package:kointos/domain/entities/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildContent(),
                  const SizedBox(height: 16),
                  _buildInteractions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: article.coverImageUrl != null
            ? Image.network(
                article.coverImageUrl!,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppTheme.surfaceColor,
                child: const Center(
                  child: Icon(
                    Icons.article,
                    size: 64,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.pureWhite.withOpacity(0.25),
              child: Text(
                article.authorName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.pureWhite,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatDate(article.createdAt),
                    style: const TextStyle(
                      color: AppTheme.greyText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (article.tags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: article.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '#$tag',
                  style: const TextStyle(
                    color: AppTheme.pureWhite,
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

  Widget _buildContent() {
    return Markdown(
      data: article.content,
      selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          UrlUtils.launchURL(href);
        }
      },
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 16,
          height: 1.5,
        ),
        h1: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        h2: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        h3: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        blockquote: const TextStyle(
          color: AppTheme.greyText,
          fontSize: 16,
          height: 1.5,
        ),
        code: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontSize: 14,
          fontFamily: 'monospace',
          backgroundColor: AppTheme.surfaceColor,
        ),
        codeblockPadding: const EdgeInsets.all(16),
        codeblockDecoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildInteractions() {
    return Row(
      children: [
        _buildInteractionButton(
          icon: Icons.thumb_up_outlined,
          count: article.likesCount,
          isActive: article.isLiked,
        ),
        const SizedBox(width: 16),
        _buildInteractionButton(
          icon: Icons.comment_outlined,
          count: article.commentsCount,
        ),
        const SizedBox(width: 16),
        _buildInteractionButton(
          icon: Icons.share_outlined,
        ),
      ],
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    int? count,
    bool isActive = false,
  }) {
    final color =
        isActive ? AppTheme.pureWhite : AppTheme.greyText;

    return Row(
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
    );
  }
}
