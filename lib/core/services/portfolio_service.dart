import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:kointos/core/services/logger_service.dart';

/// Service for managing user portfolios using Amplify Gen 2
class PortfolioService {
  /// Create a new portfolio for the current user
  Future<String?> createPortfolio({
    required String name,
    String? description,
    bool isPublic = false,
  }) async {
    try {
      final user = await Amplify.Auth.getCurrentUser();

      final request = GraphQLRequest<String>(
        document: '''
          mutation CreatePortfolio(\$input: CreatePortfolioInput!) {
            createPortfolio(input: \$input) {
              id
              name
              description
              isPublic
              totalValue
              createdAt
            }
          }
        ''',
        variables: {
          'input': {
            'name': name,
            'description': description,
            'isPublic': isPublic,
            'userId': user.userId,
            'totalValue': 0.0,
          }
        },
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to create portfolio', response.errors);
        return null;
      }

      LoggerService.info('Portfolio created successfully');
      return response.data;
    } catch (e, stackTrace) {
      LoggerService.error('Error creating portfolio', e, stackTrace);
      return null;
    }
  }

  /// Get all portfolios for the current user
  Future<List<Map<String, dynamic>>> getUserPortfolios() async {
    try {
      await Amplify.Auth.getCurrentUser(); // Ensure user is authenticated

      final request = GraphQLRequest<String>(
        document: '''
          query ListPortfolios(\$filter: ModelPortfolioFilterInput) {
            listPortfolios(filter: \$filter) {
              items {
                id
                name
                description
                totalValue
                isPublic
                createdAt
                updatedAt
              }
            }
          }
        ''',
      );

      final response = await Amplify.API.query(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to fetch portfolios', response.errors);
        return [];
      }

      // Parse response data here
      // This is a simplified example - in practice you'd parse the JSON response
      return [];
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching portfolios', e, stackTrace);
      return [];
    }
  }

  /// Add a cryptocurrency holding to a portfolio
  Future<bool> addHolding({
    required String portfolioId,
    required String cryptoSymbol,
    required double amount,
    required double averageBuyPrice,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreatePortfolioHolding(\$input: CreatePortfolioHoldingInput!) {
            createPortfolioHolding(input: \$input) {
              id
              portfolioId
              cryptoSymbol
              amount
              averageBuyPrice
              currentValue
            }
          }
        ''',
        variables: {
          'input': {
            'portfolioId': portfolioId,
            'cryptoSymbol': cryptoSymbol,
            'amount': amount,
            'averageBuyPrice': averageBuyPrice,
            'currentValue': amount * averageBuyPrice,
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to add holding', response.errors);
        return false;
      }

      LoggerService.info('Holding added successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error adding holding', e, stackTrace);
      return false;
    }
  }

  /// Record a transaction
  Future<bool> recordTransaction({
    required String portfolioId,
    required String cryptoSymbol,
    required String type, // 'BUY', 'SELL', 'TRANSFER_IN', 'TRANSFER_OUT'
    required double amount,
    required double price,
    double fees = 0.0,
    String? notes,
  }) async {
    try {
      final request = GraphQLRequest<String>(
        document: '''
          mutation CreateTransaction(\$input: CreateTransactionInput!) {
            createTransaction(input: \$input) {
              id
              portfolioId
              cryptoSymbol
              type
              amount
              price
              totalValue
              fees
              transactionDate
            }
          }
        ''',
        variables: {
          'input': {
            'portfolioId': portfolioId,
            'cryptoSymbol': cryptoSymbol,
            'type': type,
            'amount': amount,
            'price': price,
            'totalValue': amount * price,
            'fees': fees,
            'notes': notes,
            'transactionDate': DateTime.now().toIso8601String(),
          }
        },
      );

      final response = await Amplify.API.mutate(request: request).response;

      if (response.hasErrors) {
        LoggerService.error('Failed to record transaction', response.errors);
        return false;
      }

      LoggerService.info('Transaction recorded successfully');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Error recording transaction', e, stackTrace);
      return false;
    }
  }
}
