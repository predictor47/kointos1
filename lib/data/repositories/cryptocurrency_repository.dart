import 'dart:convert';
import 'package:kointos/core/constants/app_constants.dart';
import 'package:kointos/core/services/local_storage_service.dart';
import 'package:kointos/core/services/logger_service.dart';
import 'package:kointos/data/datasources/coingecko_service.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';

class CryptocurrencyRepository {
  final CoinGeckoService coinGeckoService;
  final LocalStorageService localStorageService;

  const CryptocurrencyRepository({
    required this.coinGeckoService,
    required this.localStorageService,
  });

  Future<List<Cryptocurrency>> getTopCryptocurrencies({
    int page = 1,
    int perPage = 100,
    String currency = 'usd',
  }) async {
    try {
      // Try to get cached data first
      final cachedData =
          await localStorageService.get(AppConstants.cryptoCacheKey);
      if (cachedData != null) {
        final List<dynamic> cached = json.decode(cachedData);
        final cryptos =
            cached.map((data) => Cryptocurrency.fromJson(data)).toList();
        return cryptos;
      }

      // If no cache, fetch from API
      final cryptos = await coinGeckoService.getMarketData(
        currency: currency,
        page: page,
        perPage: perPage,
      );

      // Cache the results
      await localStorageService.set(
        AppConstants.cryptoCacheKey,
        json.encode(cryptos.map((c) => c.toJson()).toList()),
        expiry: AppConstants.cryptoCacheDuration,
      );

      return cryptos;
    } catch (e) {
      // If API fails and no cache, return fallback data to prevent UI errors
      LoggerService.error('CoinGecko API failed, using fallback data: $e');
      return _getFallbackCryptoData();
    }
  }

  /// Provide fallback cryptocurrency data when API is unavailable
  List<Cryptocurrency> _getFallbackCryptoData() {
    return [
      Cryptocurrency(
        id: 'bitcoin',
        symbol: 'btc',
        name: 'Bitcoin',
        currentPrice: 45000.0, // Static fallback price
        marketCap: 850000000000.0,
        totalVolume: 25000000000.0,
        imageUrl:
            'https://assets.coingecko.com/coins/images/1/small/bitcoin.png',
        marketCapRank: 1,
        priceChangePercentage24h: 0.0, // Neutral change as fallback
      ),
      Cryptocurrency(
        id: 'ethereum',
        symbol: 'eth',
        name: 'Ethereum',
        currentPrice: 3000.0,
        marketCap: 360000000000.0,
        totalVolume: 15000000000.0,
        imageUrl:
            'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
        marketCapRank: 2,
        priceChangePercentage24h: 0.0,
      ),
    ];
  }

  Future<Map<String, dynamic>> getMarketStats() async {
    try {
      // Try to get cached data first
      final cachedData =
          await localStorageService.get(AppConstants.marketDataCacheKey);
      if (cachedData != null) {
        return json.decode(cachedData);
      }

      // If no cache, fetch from API
      final data = await coinGeckoService.getGlobalData();

      // Cache the results
      await localStorageService.set(
        AppConstants.marketDataCacheKey,
        json.encode(data),
        expiry: AppConstants.marketDataCacheDuration,
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Cryptocurrency>> searchCryptocurrencies(String query) async {
    try {
      return await coinGeckoService.searchCryptocurrencies(query);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<double>> getCryptocurrencyPriceHistory(
    String id,
    String currency,
    int days,
  ) async {
    try {
      return await coinGeckoService.getHistoricalPrices(
        id,
        currency,
        days,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCache() async {
    try {
      await localStorageService.remove(AppConstants.cryptoCacheKey);
      await localStorageService.remove(AppConstants.marketDataCacheKey);
    } catch (e) {
      rethrow;
    }
  }
}
