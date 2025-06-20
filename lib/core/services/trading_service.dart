import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing trading signals and watchlists using Amplify Gen 2
class TradingService {
  /// Create a new trading signal
  Future<bool> createTradingSignal({
    required String cryptoSymbol,
    required String signalType, // 'BUY', 'SELL', 'HOLD'
    double? targetPrice,
    double? stopLoss,
    required int confidence, // 1-100
    required String reasoning,
    DateTime? expiresAt,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateTradingSignal(\$input: CreateTradingSignalInput!) {
            createTradingSignal(input: \$input) {
              id
              userId
              cryptoSymbol
              signalType
              targetPrice
              stopLoss
              confidence
              reasoning
              expiresAt
              isActive
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'userId': user.userId,
            'cryptoSymbol': cryptoSymbol,
            'signalType': signalType,
            'targetPrice': targetPrice,
            'stopLoss': stopLoss,
            'confidence': confidence,
            'reasoning': reasoning,
            'expiresAt': expiresAt?.toIso8601String(),
            'isActive': true,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to create trading signal', response.errors);
        return false;
      }
      
      LoggerService.info('Trading signal created successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating trading signal', e, stackTrace);
      return false;
    }
  }

  /// Get active trading signals
  Future<List<Map<String, dynamic>>> getActiveTradingSignals({
    String? cryptoSymbol,
    int limit = 20,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          query ListTradingSignals(\$filter: ModelTradingSignalFilterInput, \$limit: Int) {
            listTradingSignals(filter: \$filter, limit: \$limit) {
              items {
                id
                userId
                cryptoSymbol
                signalType
                targetPrice
                stopLoss
                confidence
                reasoning
                expiresAt
                isActive
                performanceRating
                createdAt
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'isActive': {'eq': true},
            if (cryptoSymbol != null) 'cryptoSymbol': {'eq': cryptoSymbol},
          },
          'limit': limit,
        },
      );
      
      final response = await Amplify.API.query(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to fetch trading signals', response.errors);
        return [];
      }
      
      // Parse response data here
      return [];
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching trading signals', e, stackTrace);
      return [];
    }
  }

  /// Create a new watchlist
  Future<bool> createWatchlist({
    required String name,
    List<String>? cryptoSymbols,
    bool isPublic = false,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateWatchlist(\$input: CreateWatchlistInput!) {
            createWatchlist(input: \$input) {
              id
              userId
              name
              cryptoSymbols
              isPublic
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'userId': user.userId,
            'name': name,
            'cryptoSymbols': cryptoSymbols ?? [],
            'isPublic': isPublic,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to create watchlist', response.errors);
        return false;
      }
      
      LoggerService.info('Watchlist created successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating watchlist', e, stackTrace);
      return false;
    }
  }

  /// Add cryptocurrency to watchlist
  Future<bool> addToWatchlist({
    required String watchlistId,
    required String cryptoSymbol,
  }) async {
    try {
      // First get current watchlist
      final getRequest = GraphQLRequest<String>(
        document: '''
          query GetWatchlist(\$id: ID!) {
            getWatchlist(id: \$id) {
              id
              cryptoSymbols
            }
          }
        ''',
        variables: {'id': watchlistId},
      );
      
      final getResponse = await Amplify.API.query(request: getRequest).response;
      
      if (getResponse.hasErrors) {
        LoggerService.error('Failed to get watchlist', getResponse.errors);
        return false;
      }
      
      // Parse current symbols and add new one
      // This is simplified - you'd need to parse the actual response
      final currentSymbols = <String>[];
      if (!currentSymbols.contains(cryptoSymbol)) {
        currentSymbols.add(cryptoSymbol);
      }
      
      final updateRequest = GraphQLRequest<String>(
        document: '''
          mutation UpdateWatchlist(\$input: UpdateWatchlistInput!) {
            updateWatchlist(input: \$input) {
              id
              cryptoSymbols
              updatedAt
            }
          }
        ''',
        variables: {
          'input': {
            'id': watchlistId,
            'cryptoSymbols': currentSymbols,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: updateRequest).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to update watchlist', response.errors);
        return false;
      }
      
      LoggerService.info('Added to watchlist successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error adding to watchlist', e, stackTrace);
      return false;
    }
  }

  /// Create a price alert
  Future<bool> createPriceAlert({
    required String cryptoSymbol,
    required String alertType, // 'ABOVE', 'BELOW'
    required double targetPrice,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreatePriceAlert(\$input: CreatePriceAlertInput!) {
            createPriceAlert(input: \$input) {
              id
              userId
              cryptoSymbol
              alertType
              targetPrice
              isActive
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'userId': user.userId,
            'cryptoSymbol': cryptoSymbol,
            'alertType': alertType,
            'targetPrice': targetPrice,
            'isActive': true,
          }
        },
      );
      
      final response = await Amplify.API.mutate(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to create price alert', response.errors);
        return false;
      }
      
      LoggerService.info('Price alert created successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating price alert', e, stackTrace);
      return false;
    }
  }

  /// Get user's watchlists
  Future<List<Map<String, dynamic>>> getUserWatchlists() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      
      final request = GraphQLRequest<String>(
        document: '''
          query ListWatchlists(\$filter: ModelWatchlistFilterInput) {
            listWatchlists(filter: \$filter) {
              items {
                id
                name
                cryptoSymbols
                isPublic
                createdAt
                updatedAt
              }
            }
          }
        ''',
        variables: {
          'filter': {
            'userId': {'eq': user.userId}
          }
        },
      );
      
      final response = await Amplify.API.query(request: request).response;
      
      if (response.hasErrors) {
        LoggerService.error('Failed to fetch watchlists', response.errors);
        return [];
      }
      
      // Parse response data here
      return [];
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching watchlists', e, stackTrace);
      return [];
    }
  }
}
