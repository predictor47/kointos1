import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Performance optimization utilities for the Kointoss app
class PerformanceUtils {
  /// Debounce function to limit rapid function calls
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }

  /// Throttle function to limit function calls to a specific rate
  static Function throttle(Function func, Duration duration) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        func();
        isThrottled = true;
        Timer(duration, () => isThrottled = false);
      }
    };
  }

  /// Lazy load images with fade-in animation
  static Widget lazyLoadImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: child,
          );
        }
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.red),
            );
      },
    );
  }

  /// Memoize expensive computations
  static T Function() memoize<T>(T Function() func) {
    T? cachedResult;
    bool hasCached = false;

    return () {
      if (!hasCached) {
        cachedResult = func();
        hasCached = true;
      }
      return cachedResult as T;
    };
  }

  /// Batch API calls to reduce network overhead
  static Future<List<T>> batchApiCalls<T>(
    List<Future<T> Function()> apiCalls, {
    int batchSize = 5,
  }) async {
    final results = <T>[];

    for (int i = 0; i < apiCalls.length; i += batchSize) {
      final end =
          (i + batchSize < apiCalls.length) ? i + batchSize : apiCalls.length;

      final batch = apiCalls.sublist(i, end);
      final batchResults = await Future.wait(
        batch.map((call) => call()),
      );

      results.addAll(batchResults);
    }

    return results;
  }

  /// Optimize list rendering with pagination
  static Widget optimizedListView<T>({
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    ScrollController? controller,
    int itemsPerPage = 20,
    Widget? loadingWidget,
    Widget? emptyWidget,
  }) {
    if (items.isEmpty) {
      return emptyWidget ?? const Center(child: Text('No items found'));
    }

    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Add loading indicator at the end
        if (index == items.length - 1 && items.length % itemsPerPage == 0) {
          return Column(
            children: [
              itemBuilder(context, items[index]),
              loadingWidget ??
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
            ],
          );
        }
        return itemBuilder(context, items[index]);
      },
    );
  }

  /// Cache manager for temporary data
  static final Map<String, CacheEntry> _cache = {};

  static void cacheData(String key, dynamic data, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      ttl: ttl,
    );
  }

  static T? getCachedData<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    // Check if cache has expired
    if (entry.ttl != null) {
      final expiryTime = entry.timestamp.add(entry.ttl!);
      if (DateTime.now().isAfter(expiryTime)) {
        _cache.remove(key);
        return null;
      }
    }

    return entry.data as T?;
  }

  static void clearCache() {
    _cache.clear();
  }

  /// Preload critical assets
  static Future<void> preloadAssets(BuildContext context) async {
    // Preload images
    final imagesToPreload = [
      'assets/images/logo.png',
      'assets/images/onboarding1.png',
      'assets/images/onboarding2.png',
      'assets/images/onboarding3.png',
    ];

    await Future.wait(
      imagesToPreload.map((image) => precacheImage(AssetImage(image), context)),
    );
  }

  /// Optimize widget rebuilds
  static Widget optimizedBuilder({
    required Widget Function() builder,
    List<Object?>? dependencies,
  }) {
    return _OptimizedWidget(
      builder: builder,
      dependencies: dependencies ?? [],
    );
  }
}

/// Cache entry model
class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration? ttl;

  CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl,
  });
}

/// Optimized widget that only rebuilds when dependencies change
class _OptimizedWidget extends StatefulWidget {
  final Widget Function() builder;
  final List<Object?> dependencies;

  const _OptimizedWidget({
    required this.builder,
    required this.dependencies,
  });

  @override
  State<_OptimizedWidget> createState() => _OptimizedWidgetState();
}

class _OptimizedWidgetState extends State<_OptimizedWidget> {
  late Widget _cachedWidget;
  late List<Object?> _lastDependencies;

  @override
  void initState() {
    super.initState();
    _cachedWidget = widget.builder();
    _lastDependencies = List.from(widget.dependencies);
  }

  @override
  void didUpdateWidget(_OptimizedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if dependencies have changed
    bool shouldRebuild = false;
    if (widget.dependencies.length != _lastDependencies.length) {
      shouldRebuild = true;
    } else {
      for (int i = 0; i < widget.dependencies.length; i++) {
        if (widget.dependencies[i] != _lastDependencies[i]) {
          shouldRebuild = true;
          break;
        }
      }
    }

    if (shouldRebuild) {
      setState(() {
        _cachedWidget = widget.builder();
        _lastDependencies = List.from(widget.dependencies);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cachedWidget;
  }
}

/// Loading state manager
class LoadingStateManager extends ChangeNotifier {
  final Map<String, bool> _loadingStates = {};

  bool isLoading(String key) => _loadingStates[key] ?? false;

  void setLoading(String key, bool loading) {
    _loadingStates[key] = loading;
    notifyListeners();
  }

  void startLoading(String key) => setLoading(key, true);
  void stopLoading(String key) => setLoading(key, false);

  bool get hasAnyLoading => _loadingStates.values.any((loading) => loading);
}

/// Skeleton loader widget
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor = const Color(0xFF2A2A2A),
    this.highlightColor = const Color(0xFF3A3A3A),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Performance monitoring
class PerformanceMonitor {
  static final Map<String, List<int>> _metrics = {};

  static void startMeasure(String key) {
    _metrics[key] = [DateTime.now().millisecondsSinceEpoch];
  }

  static void endMeasure(String key) {
    final start = _metrics[key]?.first;
    if (start != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - start;
      if (kDebugMode) {
        print('Performance [$key]: ${duration}ms');
      }
      _metrics.remove(key);
    }
  }

  static Future<T> measureAsync<T>(
      String key, Future<T> Function() func) async {
    startMeasure(key);
    try {
      final result = await func();
      endMeasure(key);
      return result;
    } catch (e) {
      endMeasure(key);
      rethrow;
    }
  }

  static T measureSync<T>(String key, T Function() func) {
    startMeasure(key);
    try {
      final result = func();
      endMeasure(key);
      return result;
    } catch (e) {
      endMeasure(key);
      rethrow;
    }
  }
}
