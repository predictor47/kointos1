import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

class PerformanceOptimizationService {
  static final PerformanceOptimizationService _instance =
      PerformanceOptimizationService._internal();

  factory PerformanceOptimizationService() => _instance;

  PerformanceOptimizationService._internal();

  // Cache management
  final Map<String, _CacheEntry> _cache = {};
  final int _maxCacheSize = 1000;
  final int _cacheExpiryHours = 2;

  // Memory management
  final Queue<String> _cacheKeys = Queue<String>();
  Timer? _cleanupTimer;

  // Performance metrics
  final Map<String, List<double>> _performanceMetrics = {};
  final Map<String, DateTime> _operationTimestamps = {};

  // Error tracking
  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTimestamps = {};

  void initialize() {
    _startPeriodicCleanup();
    if (kDebugMode) {
      debugPrint('PerformanceOptimizationService initialized');
    }
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _cache.clear();
    _cacheKeys.clear();
    _performanceMetrics.clear();
    _operationTimestamps.clear();
    _errorCounts.clear();
    _lastErrorTimestamps.clear();
  }

  // Cache Management
  T? getCachedData<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (_isCacheEntryExpired(entry)) {
      _removeFromCache(key);
      return null;
    }

    entry.lastAccessed = DateTime.now();
    entry.accessCount++;
    return entry.data as T?;
  }

  void setCachedData<T>(String key, T data, {Duration? customExpiry}) {
    final expiry = customExpiry ?? Duration(hours: _cacheExpiryHours);

    // Remove oldest entries if cache is full
    if (_cache.length >= _maxCacheSize) {
      _evictLeastRecentlyUsed();
    }

    final entry = _CacheEntry(
      data: data,
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      expiresAt: DateTime.now().add(expiry),
    );

    _cache[key] = entry;
    _cacheKeys.remove(key); // Remove if exists
    _cacheKeys.addLast(key); // Add to end

    if (kDebugMode) {
      debugPrint('Cached data for key: $key');
    }
  }

  void invalidateCache(String key) {
    _removeFromCache(key);
  }

  void clearCache() {
    _cache.clear();
    _cacheKeys.clear();
    if (kDebugMode) {
      debugPrint('Cache cleared');
    }
  }

  void _removeFromCache(String key) {
    _cache.remove(key);
    _cacheKeys.remove(key);
  }

  bool _isCacheEntryExpired(_CacheEntry entry) {
    return DateTime.now().isAfter(entry.expiresAt);
  }

  void _evictLeastRecentlyUsed() {
    if (_cacheKeys.isEmpty) return;

    // Find the least recently used entry
    String? lruKey;
    DateTime? oldestAccess;

    for (final key in _cacheKeys) {
      final entry = _cache[key];
      if (entry != null) {
        if (oldestAccess == null || entry.lastAccessed.isBefore(oldestAccess)) {
          oldestAccess = entry.lastAccessed;
          lruKey = key;
        }
      }
    }

    if (lruKey != null) {
      _removeFromCache(lruKey);
      if (kDebugMode) {
        debugPrint('Evicted LRU cache entry: $lruKey');
      }
    }
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      _cleanupExpiredEntries();
      _cleanupOldMetrics();
    });
  }

  void _cleanupExpiredEntries() {
    final keysToRemove = <String>[];

    for (final entry in _cache.entries) {
      if (_isCacheEntryExpired(entry.value)) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _removeFromCache(key);
    }

    if (kDebugMode && keysToRemove.isNotEmpty) {
      debugPrint('Cleaned up ${keysToRemove.length} expired cache entries');
    }
  }

  // Performance Monitoring
  void recordOperationStart(String operationName) {
    _operationTimestamps[operationName] = DateTime.now();
  }

  void recordOperationEnd(String operationName) {
    final startTime = _operationTimestamps[operationName];
    if (startTime == null) return;

    final duration =
        DateTime.now().difference(startTime).inMilliseconds.toDouble();
    _operationTimestamps.remove(operationName);

    _performanceMetrics.putIfAbsent(operationName, () => <double>[]);
    final metrics = _performanceMetrics[operationName]!;

    metrics.add(duration);

    // Keep only last 100 measurements
    if (metrics.length > 100) {
      metrics.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('$operationName completed in ${duration}ms');
    }
  }

  double? getAveragePerformance(String operationName) {
    final metrics = _performanceMetrics[operationName];
    if (metrics == null || metrics.isEmpty) return null;

    return metrics.reduce((a, b) => a + b) / metrics.length;
  }

  Map<String, double> getAllAveragePerformances() {
    final result = <String, double>{};

    for (final entry in _performanceMetrics.entries) {
      if (entry.value.isNotEmpty) {
        result[entry.key] =
            entry.value.reduce((a, b) => a + b) / entry.value.length;
      }
    }

    return result;
  }

  void _cleanupOldMetrics() {
    final cutoffDate = DateTime.now().subtract(const Duration(hours: 24));
    final keysToRemove = <String>[];

    for (final entry in _operationTimestamps.entries) {
      if (entry.value.isBefore(cutoffDate)) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _operationTimestamps.remove(key);
      _performanceMetrics.remove(key);
    }
  }

  // Error Tracking
  void recordError(String operationName, dynamic error) {
    _errorCounts[operationName] = (_errorCounts[operationName] ?? 0) + 1;
    _lastErrorTimestamps[operationName] = DateTime.now();

    if (kDebugMode) {
      debugPrint('Error recorded for $operationName: $error');
    }
  }

  int getErrorCount(String operationName) {
    return _errorCounts[operationName] ?? 0;
  }

  DateTime? getLastErrorTime(String operationName) {
    return _lastErrorTimestamps[operationName];
  }

  Map<String, int> getAllErrorCounts() {
    return Map.from(_errorCounts);
  }

  void resetErrorTracking() {
    _errorCounts.clear();
    _lastErrorTimestamps.clear();
  }

  // Memory Management
  Map<String, dynamic> getMemoryStats() {
    return {
      'cacheSize': _cache.length,
      'maxCacheSize': _maxCacheSize,
      'cacheUtilization':
          (_cache.length / _maxCacheSize * 100).toStringAsFixed(1),
      'totalOperationsTracked': _performanceMetrics.length,
      'totalErrorsTracked': _errorCounts.length,
    };
  }

  void optimizeMemoryUsage() {
    // Clear half of the cache if it's getting full
    if (_cache.length > _maxCacheSize * 0.8) {
      final keysToRemove = _cacheKeys.take(_cache.length ~/ 2).toList();
      for (final key in keysToRemove) {
        _removeFromCache(key);
      }

      if (kDebugMode) {
        debugPrint(
            'Optimized memory usage: removed ${keysToRemove.length} cache entries');
      }
    }

    // Clean up old performance metrics
    _cleanupOldMetrics();

    // Reset error counts if they're getting large
    if (_errorCounts.length > 100) {
      resetErrorTracking();
    }
  }

  // Utility Methods
  Future<T> withPerformanceTracking<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    recordOperationStart(operationName);

    try {
      final result = await operation();
      recordOperationEnd(operationName);
      return result;
    } catch (error) {
      recordError(operationName, error);
      recordOperationEnd(operationName);
      rethrow;
    }
  }

  T withCaching<T>(
    String cacheKey,
    T Function() operation, {
    Duration? cacheExpiry,
  }) {
    // Try to get from cache first
    final cachedResult = getCachedData<T>(cacheKey);
    if (cachedResult != null) {
      return cachedResult;
    }

    // Execute operation and cache result
    final result = operation();
    setCachedData(cacheKey, result, customExpiry: cacheExpiry);

    return result;
  }

  Future<T> withCachingAsync<T>(
    String cacheKey,
    Future<T> Function() operation, {
    Duration? cacheExpiry,
  }) async {
    // Try to get from cache first
    final cachedResult = getCachedData<T>(cacheKey);
    if (cachedResult != null) {
      return cachedResult;
    }

    // Execute operation and cache result
    final result = await operation();
    setCachedData(cacheKey, result, customExpiry: cacheExpiry);

    return result;
  }

  void preloadCache(Map<String, dynamic> data) {
    for (final entry in data.entries) {
      setCachedData(entry.key, entry.value);
    }

    if (kDebugMode) {
      debugPrint('Preloaded ${data.length} cache entries');
    }
  }

  // Debug Information
  Map<String, dynamic> getDebugInfo() {
    return {
      'cacheStats': getMemoryStats(),
      'performanceMetrics': getAllAveragePerformances(),
      'errorCounts': getAllErrorCounts(),
      'cacheKeys': _cacheKeys.toList(),
      'activeOperations': _operationTimestamps.keys.toList(),
    };
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime createdAt;
  DateTime lastAccessed;
  final DateTime expiresAt;
  int accessCount;

  _CacheEntry({
    required this.data,
    required this.createdAt,
    required this.lastAccessed,
    required this.expiresAt,
  }) : accessCount = 1;
}

// Extension methods for easy integration
extension PerformanceExtensions on Future {
  Future<T> withTracking<T>(String operationName) async {
    return PerformanceOptimizationService().withPerformanceTracking(
      operationName,
      () => this as Future<T>,
    );
  }
}

extension CachingExtensions on String {
  String get cacheKey => 'cache_$this';
  String get performanceKey => 'perf_$this';
  String get errorKey => 'error_$this';
}
