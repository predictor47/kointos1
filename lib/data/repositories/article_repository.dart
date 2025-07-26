import 'dart:io';
import 'package:kointos/core/services/auth_service.dart';
import 'package:kointos/core/services/storage_interface.dart';
import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/domain/entities/article.dart';
import 'package:uuid/uuid.dart';

class ArticleRepository {
  final AuthService _authService;
  final StorageInterface _storageService;
  final ApiService _apiService;
  final _uuid = const Uuid();

  ArticleRepository({
    required AuthService authService,
    required StorageInterface storageService,
    required ApiService apiService,
  })  : _authService = authService,
        _storageService = storageService,
        _apiService = apiService;

  // Factory constructor to create instance with dependencies from service locator
  factory ArticleRepository.fromServiceLocator() {
    return ArticleRepository(
      authService: serviceLocator<AuthService>(),
      storageService: serviceLocator<StorageInterface>(),
      apiService: serviceLocator<ApiService>(),
    );
  }

  Future<Article> getArticle(String articleId) async {
    try {
      final articleData = await _apiService.getArticle(articleId);
      if (articleData == null) {
        throw Exception('Article not found');
      }

      // Download content from storage
      String content = '';
      try {
        content = await _storageService.downloadData(articleData['contentKey']);
      } catch (e) {
        // If content can't be downloaded, use empty string
        content = '';
      }

      return Article(
        id: articleData['id'],
        authorId: articleData['authorId'],
        authorName: articleData['authorName'],
        title: articleData['title'],
        content: content,
        summary: articleData['summary'] ?? '',
        coverImageUrl: articleData['coverImageUrl'],
        tags: List<String>.from(articleData['tags'] ?? []),
        images: List<String>.from(articleData['images'] ?? []),
        createdAt: DateTime.parse(articleData['createdAt']),
        updatedAt: DateTime.parse(articleData['updatedAt']),
        likesCount: articleData['likesCount'] ?? 0,
        commentsCount: articleData['commentsCount'] ?? 0,
        isLiked: false, // This would need to be fetched separately
        status: ArticleStatus.values.firstWhere(
          (status) =>
              status.name.toUpperCase() == articleData['status'].toUpperCase(),
          orElse: () => ArticleStatus.draft,
        ),
        contentKey: articleData['contentKey'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> getArticles({
    String? authorId,
    ArticleStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final articlesData = await _apiService.getArticles(
        authorId: authorId,
        status: status?.name.toUpperCase(),
        limit: limit,
      );

      final articles = <Article>[];
      for (final articleData in articlesData) {
        try {
          final article = Article(
            id: articleData['id'],
            authorId: articleData['authorId'],
            authorName: articleData['authorName'],
            title: articleData['title'],
            content: '', // Content is loaded separately when needed
            summary: articleData['summary'] ?? '',
            coverImageUrl: articleData['coverImageUrl'],
            tags: List<String>.from(articleData['tags'] ?? []),
            images: List<String>.from(articleData['images'] ?? []),
            createdAt: DateTime.parse(articleData['createdAt']),
            updatedAt: DateTime.parse(articleData['updatedAt']),
            likesCount: articleData['likesCount'] ?? 0,
            commentsCount: articleData['commentsCount'] ?? 0,
            isLiked: false,
            status: ArticleStatus.values.firstWhere(
              (status) =>
                  status.name.toUpperCase() ==
                  articleData['status'].toUpperCase(),
              orElse: () => ArticleStatus.draft,
            ),
            contentKey: articleData['contentKey'],
          );
          articles.add(article);
        } catch (e) {
          // Skip invalid articles
          continue;
        }
      }

      return articles;
    } catch (e) {
      rethrow;
    }
  }

  Future<Article> createArticle() async {
    try {
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile to get the actual user name
      String userName = 'User';
      try {
        final userProfile = await _apiService.getUserProfile(userId);
        if (userProfile != null) {
          userName =
              userProfile['displayName'] ?? userProfile['username'] ?? 'User';
        }
      } catch (e) {
        // Use fallback name if profile can't be fetched
        userName = 'User $userId';
      }

      final articleId = _uuid.v4();
      final contentKey = 'articles/$userId/$articleId/content.md';

      // Initialize article content in storage
      await _storageService.uploadData(contentKey, '');

      // Create article metadata in API
      final articleData = await _apiService.createArticle(
        authorId: userId,
        authorName: userName,
        title: 'Untitled Article',
        contentKey: contentKey,
        status: 'DRAFT',
        isPublic: false,
      );

      if (articleData == null) {
        throw Exception('Failed to create article');
      }

      return Article(
        id: articleData['id'],
        authorId: articleData['authorId'],
        authorName: articleData['authorName'],
        title: articleData['title'],
        content: '',
        summary: articleData['summary'] ?? '',
        coverImageUrl: articleData['coverImageUrl'],
        tags: List<String>.from(articleData['tags'] ?? []),
        images: List<String>.from(articleData['images'] ?? []),
        createdAt: DateTime.parse(articleData['createdAt']),
        updatedAt: DateTime.parse(articleData['updatedAt']),
        likesCount: 0,
        commentsCount: 0,
        isLiked: false,
        status: ArticleStatus.draft,
        contentKey: contentKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Article> updateArticle(
    Article article, {
    String? title,
    String? content,
    String? summary,
    String? coverImageUrl,
    List<String>? tags,
    List<String>? images,
    ArticleStatus? status,
  }) async {
    try {
      // Update content in storage if provided
      if (content != null) {
        await _storageService.uploadData(article.contentKey, content);
      }

      // Update article metadata in API
      final updatedData = await _apiService.updateArticle(
        id: article.id,
        title: title,
        summary: summary,
        coverImageUrl: coverImageUrl,
        tags: tags,
        images: images,
        status: status?.name.toUpperCase(),
      );

      if (updatedData == null) {
        throw Exception('Failed to update article');
      }

      return article.copyWith(
        title: title,
        content: content,
        summary: summary,
        coverImageUrl: coverImageUrl,
        tags: tags,
        images: images,
        status: status,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteArticle(Article article) async {
    try {
      // Delete content from storage
      await _storageService.removeFile(article.contentKey);

      // Delete article metadata from API
      final success = await _apiService.deleteArticle(article.id);
      if (!success) {
        throw Exception('Failed to delete article from database');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> searchArticles(
    String query, {
    ArticleStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // For now, we'll get all articles and filter by title/content
      // In a real implementation, you'd want server-side search
      final articles = await getArticles(
        status: status,
        limit: limit * 2, // Get more articles to account for filtering
      );

      final filteredArticles = articles.where((article) {
        final queryLower = query.toLowerCase();
        return article.title.toLowerCase().contains(queryLower) ||
            article.summary.toLowerCase().contains(queryLower) ||
            article.tags.any((tag) => tag.toLowerCase().contains(queryLower));
      }).toList();

      // Return only the requested number of articles
      return filteredArticles.take(limit).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Article> uploadArticleImage(String articleId, String imagePath) async {
    try {
      final file = File(imagePath);
      final userId = await _authService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final key =
          'articles/$userId/$articleId/images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      await _storageService.uploadFile(key, file);

      // Get current article and update with new image
      final article = await getArticle(articleId);
      final updatedImages = [...article.images, key];

      final updatedData = await _apiService.updateArticle(
        id: articleId,
        images: updatedImages,
      );

      if (updatedData == null) {
        throw Exception('Failed to update article with new image');
      }

      return article.copyWith(images: updatedImages);
    } catch (e) {
      rethrow;
    }
  }
}
