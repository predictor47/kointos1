import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kointos/domain/entities/cryptocurrency.dart';
import 'package:kointos/core/services/logger_service.dart';

class CoinGeckoService {
  final String baseUrl;
  final http.Client _httpClient;
  final Map<String, dynamic> _cache = {};
  DateTime? _lastRequestTime;
  static const int _minRequestInterval = 1000; // 1 second between requests

  CoinGeckoService({
    required this.baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<void> _rateLimiting() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest =
          DateTime.now().difference(_lastRequestTime!).inMilliseconds;
      if (timeSinceLastRequest < _minRequestInterval) {
        await Future.delayed(
            Duration(milliseconds: _minRequestInterval - timeSinceLastRequest));
      }
    }
    _lastRequestTime = DateTime.now();
  }

  Future<http.Response> _makeRequest(Uri uri, {Duration? cacheDuration}) async {
    // Check cache first if cache duration is specified
    if (cacheDuration != null) {
      final cacheKey = uri.toString();
      final cachedData = _cache[cacheKey];
      if (cachedData != null &&
          DateTime.now()
                  .difference(cachedData['timestamp'])
                  .compareTo(cacheDuration) <
              0) {
        LoggerService.info('Returning cached data for: $cacheKey');
        return http.Response(cachedData['body'], 200);
      }
    }

    await _rateLimiting();

    try {
      final response = await _httpClient.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Kointos-App/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      // Cache successful responses
      if (response.statusCode == 200 && cacheDuration != null) {
        _cache[uri.toString()] = {
          'body': response.body,
          'timestamp': DateTime.now(),
        };
      }

      if (response.statusCode == 429) {
        LoggerService.warning('CoinGecko rate limit hit, retrying after delay');
        await Future.delayed(const Duration(seconds: 60));
        return await _makeRequest(uri, cacheDuration: cacheDuration);
      }

      return response;
    } catch (e) {
      LoggerService.error('CoinGecko API request failed: $e');
      rethrow;
    }
  }

  Future<List<Cryptocurrency>> getMarketData({
    String currency = 'usd',
    int page = 1,
    int perPage = 100,
    String? ids,
  }) async {
    try {
      final queryParams = {
        'vs_currency': currency,
        'order': 'market_cap_desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
        'sparkline': 'false',
      };

      if (ids != null) {
        queryParams['ids'] = ids;
      }

      final uri = Uri.parse('$baseUrl/coins/markets').replace(
        queryParameters: queryParams,
      );

      final response =
          await _makeRequest(uri, cacheDuration: const Duration(minutes: 2));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        LoggerService.info(
            'Successfully fetched ${data.length} cryptocurrencies from CoinGecko');
        return data.map((json) => Cryptocurrency.fromJson(json)).toList();
      } else {
        LoggerService.error(
            'CoinGecko API returned status ${response.statusCode}: ${response.body}');
        throw Exception(
            'Failed to load market data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error fetching market data from CoinGecko: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGlobalData() async {
    try {
      final uri = Uri.parse('$baseUrl/global');
      final response =
          await _makeRequest(uri, cacheDuration: const Duration(minutes: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LoggerService.info('Successfully fetched global crypto market data');
        return data['data'] as Map<String, dynamic>;
      } else {
        LoggerService.error(
            'CoinGecko global API returned status ${response.statusCode}: ${response.body}');
        throw Exception(
            'Failed to load global data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error fetching global data from CoinGecko: $e');
      rethrow;
    }
  }

  Future<List<double>> getHistoricalPrices(
    String id,
    String currency,
    int days,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/coins/$id/market_chart').replace(
        queryParameters: {
          'vs_currency': currency,
          'days': days.toString(),
          'interval': 'daily',
        },
      );

      final response =
          await _makeRequest(uri, cacheDuration: const Duration(hours: 1));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prices = data['prices'] as List;
        LoggerService.info(
            'Successfully fetched ${prices.length} historical prices for $id');
        return prices.map((price) => (price[1] as num).toDouble()).toList();
      } else {
        LoggerService.error(
            'CoinGecko historical API returned status ${response.statusCode}: ${response.body}');
        throw Exception(
            'Failed to load historical prices: HTTP ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error fetching historical prices for $id: $e');
      rethrow;
    }
  }

  Future<List<Cryptocurrency>> searchCryptocurrencies(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/search').replace(
        queryParameters: {
          'query': query,
        },
      );

      final response =
          await _makeRequest(uri, cacheDuration: const Duration(minutes: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coins = data['coins'] as List;
        LoggerService.info(
            'Successfully searched for "$query", found ${coins.length} results');
        return coins
            .map((json) => Cryptocurrency.fromSearchJson(json))
            .toList();
      } else {
        LoggerService.error(
            'CoinGecko search API returned status ${response.statusCode}: ${response.body}');
        throw Exception(
            'Failed to search cryptocurrencies: HTTP ${response.statusCode}');
      }
    } catch (e) {
      LoggerService.error('Error searching cryptocurrencies for "$query": $e');
      rethrow;
    }
  }

  void dispose() {
    _httpClient.close();
    _cache.clear();
  }
}
