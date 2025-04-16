import 'package:kointos/core/services/api_service.dart';
import 'package:kointos/domain/entities/interaction.dart';
import 'package:uuid/uuid.dart';

class InteractionRepository {
  final ApiService _apiService;
  final _uuid = const Uuid();

  InteractionRepository({
    required ApiService apiService,
  }) : _apiService = apiService;

  /// Create a like interaction
  Future<void> likeItem(String userId, String targetId) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      final interaction = Interaction(
        id: id,
        type: InteractionType.like,
        userId: userId,
        targetId: targetId,
        createdAt: now,
      );

      await _apiService.post('/interactions', interaction.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Remove a like interaction
  Future<void> unlikeItem(String userId, String targetId) async {
    try {
      await _apiService.delete('/interactions/like/$userId/$targetId');
    } catch (e) {
      rethrow;
    }
  }

  /// Check if a user has liked an item
  Future<bool> hasLiked(String userId, String targetId) async {
    try {
      final response =
          await _apiService.get('/interactions/like/$userId/$targetId');
      return response['hasLiked'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Create a comment interaction
  Future<Interaction> createComment(
      String userId, String targetId, String content) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();

      final interaction = Interaction(
        id: id,
        type: InteractionType.comment,
        userId: userId,
        targetId: targetId,
        content: content,
        createdAt: now,
      );

      final response =
          await _apiService.post('/interactions', interaction.toJson());
      return Interaction.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _apiService.delete('/interactions/$commentId');
    } catch (e) {
      rethrow;
    }
  }

  /// Get comments for an item
  Future<List<Interaction>> getComments(String targetId,
      {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService
          .get('/interactions/comments/$targetId', queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      final List<dynamic> comments = response['comments'];
      return comments.map((json) => Interaction.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get interaction count by type for a target
  Future<int> getInteractionCount(String targetId, InteractionType type) async {
    try {
      final typeStr = Interaction.typeToString(type);
      final response =
          await _apiService.get('/interactions/count/$targetId/$typeStr');
      return response['count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get all interactions for a user
  Future<List<Interaction>> getUserInteractions(String userId,
      {int page = 1, int limit = 20}) async {
    try {
      final response =
          await _apiService.get('/interactions/user/$userId', queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      final List<dynamic> interactions = response['interactions'];
      return interactions.map((json) => Interaction.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get recent interactions for a user's feed
  Future<List<Interaction>> getFeedInteractions(String userId,
      {int page = 1, int limit = 20}) async {
    try {
      final response =
          await _apiService.get('/interactions/feed/$userId', queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      });

      final List<dynamic> interactions = response['interactions'];
      return interactions.map((json) => Interaction.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
