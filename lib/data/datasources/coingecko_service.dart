import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kointos/domain/entities/cryptocurrency.dart';

class CoinGeckoService {
  final String baseUrl;

  const CoinGeckoService({
    required this.baseUrl,
  });

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

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Cryptocurrency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load market data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getGlobalData() async {
    try {
      final uri = Uri.parse('$baseUrl/global');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load global data');
      }
    } catch (e) {
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

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prices = data['prices'] as List;
        return prices.map((price) => (price[1] as num).toDouble()).toList();
      } else {
        throw Exception('Failed to load historical prices');
      }
    } catch (e) {
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

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coins = data['coins'] as List;
        return coins
            .map((json) => Cryptocurrency.fromSearchJson(json))
            .toList();
      } else {
        throw Exception('Failed to search cryptocurrencies');
      }
    } catch (e) {
      rethrow;
    }
  }
}
