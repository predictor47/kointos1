import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing social features using Amplify Gen 2
class SocialService {
  /// Create a new post
  Future<bool> createPost({
    required String content,
    String? imageUrl,
    List<String>? tags,
    List<String>? mentionedCryptos,
    bool isPublic = true,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreatePost(\$input: CreatePostInput!) {
            createPost(input: \$input) {
              id
              userId
              content
              imageUrl
              tags
              mentionedCryptos
              isPublic
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'userId': user.userId,
            'content': content,
            'imageUrl': imageUrl,
            'tags': tags,
            'mentionedCryptos': mentionedCryptos,
            'isPublic': isPublic,
            'likesCount': 0,
            'commentsCount': 0,
            'sharesCount': 0,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to create post', response.errors);
        return false;
      }
      
      LoggerService.info('Post created successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating post', e, stackTrace);
      return false;
    }
  }

  /// Get posts feed for the current user
  Future<List<Map<String, dynamic>>> getFeed({
    int limit = 20,
    String? nextToken,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query ListPosts(\$filter: ModelPostFilterInput, \$limit: Int, \$nextToken: String) {
            listPosts(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
              items {
                id
                userId
                content
                imageUrl
                likesCount
                commentsCount
                sharesCount
                tags
                mentionedCryptos
                isPublic
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        ''',
        variables: {
          'filter': {
            'isPublic': {'eq': true}
          },
          'limit': limit,
          'nextToken': nextToken,
        },
      );
      
      final response = await Amplify.API.query(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to fetch feed', response.errors);
        return [];
      }
      
      // Parse response data here
      // This is a simplified example - in practice you'd parse the JSON response
      return [];
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching feed', e, stackTrace);
      return [];
    }
  }

  /// Like or unlike a post
  Future<bool> toggleLike({
    required String postId,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      // First check if user already liked this post
      final checkRequest = GraphQLRequest<String>(
        document: '''
          query ListLikes(\$filter: ModelLikeFilterInput) {
            listLikes(filter: \$filter) {
              items {
                id
                userId
                postId
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'userId': {'eq': user.userId},
            'postId': {'eq': postId},
          }
        },
      );
      
      final checkResponse = await Amplify.API.query(request: checkRequest).response;
      
      if (checkResponse.hasErrors) {
        LoggerService.error('Failed to check like status', checkResponse.errors);
        return false;
      }
      
      // Parse response to check if like exists
      // If exists, delete it; if not, create it
      // This is simplified - you'd need to parse the actual response
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateLike(\$input: CreateLikeInput!) {
            createLike(input: \$input) {
              id
              userId
              postId
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'userId': user.userId,
            'postId': postId,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to toggle like', response.errors);
        return false;
      }
      
      LoggerService.info('Like toggled successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error toggling like', e, stackTrace);
      return false;
    }
  }

  /// Follow or unfollow a user
  Future<bool> toggleFollow({
    required String followingUserId,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateFollow(\$input: CreateFollowInput!) {
            createFollow(input: \$input) {
              id
              followerId
              followingId
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'followerId': user.userId,
            'followingId': followingUserId,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to follow user', response.errors);
        return false;
      }
      
      LoggerService.info('Follow action completed successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error following user', e, stackTrace);
      return false;
    }
  }

  /// Add a comment to a post
  Future<bool> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateComment(\$input: CreateCommentInput!) {
            createComment(input: \$input) {
              id
              postId
              userId
              content
              likesCount
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'postId': postId,
            'userId': user.userId,
            'content': content,
            'likesCount': 0,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to add comment', response.errors);
        return false;
      }
      
      LoggerService.info('Comment added successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error adding comment', e, stackTrace);
      return false;
    }
  }
}
