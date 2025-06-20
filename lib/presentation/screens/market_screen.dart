import 'package:flutter/material.dart';
import 'package:kointos/core/services/service_locator.dart';
import 'package:kointos/data/repositories/cryptocurrency_repository.dart';
import 'package:kointos/domain/entities/cryptocurrency.dart';
import 'package:kointos/presentation/screens/crypto_detail_screen.dart';
import 'package:kointos/presentation/widgets/crypto_list_item.dart';
import 'package:kointos/presentation/widgets/market_header.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _cryptoRepository = getService<CryptocurrencyRepository>();
  final _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasError = false;
  String _sortBy = 'market_cap_desc';
  Map<String, dynamic>? _marketStats;
  List<Cryptocurrency> _cryptocurrencies = [];
  final Set<String> _favorites = {};

  int _currentPage = 1;
  static const _itemsPerPage = 50;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final cryptos = await _cryptoRepository.getTopCryptocurrencies(
        page: _currentPage,
        perPage: _itemsPerPage,
      );

      final stats = await _cryptoRepository.getMarketStats();

      setState(() {
        if (_currentPage == 1) {
          _cryptocurrencies = cryptos;
        } else {
          _cryptocurrencies.addAll(cryptos);
        }
        _marketStats = stats;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    _currentPage = 1;
    await _loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadData();
    }
  }

  void _onSortChanged(String value) {
    setState(() {
      _sortBy = value;
      _currentPage = 1;
      _cryptocurrencies.clear();
    });
    _loadData();
  }

  void _onToggleFavorite(Cryptocurrency crypto, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        _favorites.add(crypto.id);
      } else {
        _favorites.remove(crypto.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: MarketHeader(
                marketData: _marketStats,
                sortBy: _sortBy,
                onSortChanged: _onSortChanged,
              ),
            ),
            if (_hasError)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load data'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _cryptocurrencies.length) {
                      final crypto = _cryptocurrencies[index];
                      return CryptoListItem(
                        cryptocurrency: crypto.copyWith(
                          isFavorite: _favorites.contains(crypto.id),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CryptoDetailScreen(
                                cryptocurrency: crypto,
                              ),
                            ),
                          );
                        },
                        onToggleFavorite: (isFavorite) {
                          _onToggleFavorite(crypto, isFavorite);
                        },
                      );
                    }

                    if (_isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return null;
                  },
                  childCount: _isLoading
                      ? _cryptocurrencies.length + 1
                      : _cryptocurrencies.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
