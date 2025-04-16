import 'package:flutter/material.dart';
import 'package:kointos/core/theme/app_theme.dart';
import 'package:kointos/domain/entities/portfolio_item.dart';
import 'package:kointos/presentation/widgets/portfolio_summary_card.dart';
import 'package:kointos/presentation/widgets/portfolio_asset_item.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  bool _isPrivateMode = false;
  String _timeFilter = '24h';

  // Mock data for demonstration - in a real app, this would come from a repository
  final List<PortfolioItem> _mockPortfolioItems = [
    PortfolioItem.mock(
      id: '1',
      userId: 'user1',
      symbol: 'BTC',
      name: 'Bitcoin',
      amount: 0.25,
      averageBuyPrice: 38500.0,
      currentPrice: 42000.0,
    ),
    PortfolioItem.mock(
      id: '2',
      userId: 'user1',
      symbol: 'ETH',
      name: 'Ethereum',
      amount: 3.5,
      averageBuyPrice: 2800.0,
      currentPrice: 3200.0,
    ),
    PortfolioItem.mock(
      id: '3',
      userId: 'user1',
      symbol: 'SOL',
      name: 'Solana',
      amount: 50.0,
      averageBuyPrice: 120.0,
      currentPrice: 135.0,
    ),
    PortfolioItem.mock(
      id: '4',
      userId: 'user1',
      symbol: 'ADA',
      name: 'Cardano',
      amount: 1500.0,
      averageBuyPrice: 0.45,
      currentPrice: 0.52,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // In a real app, we would fetch portfolio data here
  }

  Future<void> _refreshPortfolio() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  double _getTotalPortfolioValue() {
    return _mockPortfolioItems.fold(
        0.0, (total, item) => total + item.totalValue);
  }

  double _getTotalProfitLoss() {
    return _mockPortfolioItems.fold(
        0.0, (total, item) => total + item.profitLoss);
  }

  double _getTotalProfitLossPercentage() {
    final totalInvestment = _mockPortfolioItems.fold(
        0.0, (total, item) => total + (item.amount * item.averageBuyPrice));
    final totalCurrentValue = _getTotalPortfolioValue();

    if (totalInvestment == 0) return 0;
    return ((totalCurrentValue - totalInvestment) / totalInvestment) * 100;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final totalValue = _getTotalPortfolioValue();
    final totalProfitLoss = _getTotalProfitLoss();
    final totalProfitLossPercentage = _getTotalProfitLossPercentage();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isPrivateMode ? Icons.visibility_off : Icons.visibility,
              color: _isPrivateMode
                  ? AppTheme.textSecondaryColor
                  : AppTheme.primaryColor,
            ),
            onPressed: () {
              setState(() {
                _isPrivateMode = !_isPrivateMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.history, color: AppTheme.textPrimaryColor),
            onPressed: () {
              // Navigate to transaction history
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPortfolio,
        color: AppTheme.primaryColor,
        backgroundColor: AppTheme.cardColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Portfolio summary
                    PortfolioSummaryCard(
                      totalValue: totalValue,
                      profitLoss: totalProfitLoss,
                      profitLossPercentage: totalProfitLossPercentage,
                      isPrivateMode: _isPrivateMode,
                      timeFilter: _timeFilter,
                      onTimeFilterChanged: (filter) {
                        setState(() {
                          _timeFilter = filter;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Assets section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Assets',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          DropdownButton<String>(
                            value: 'Balance',
                            dropdownColor: AppTheme.cardColor,
                            style: TextStyle(color: AppTheme.primaryColor),
                            underline: Container(height: 0),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: AppTheme.primaryColor),
                            items: ['Balance', 'Profit/Loss', 'Name', 'Price']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              // Sort assets by selected value
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Assets list
                    _mockPortfolioItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 64,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Your portfolio is empty',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start adding your crypto assets to track your portfolio',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to add asset screen
                                    },
                                    child: const Text('Add Asset'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _mockPortfolioItems.length,
                            itemBuilder: (context, index) {
                              final item = _mockPortfolioItems[index];
                              return PortfolioAssetItem(
                                portfolioItem: item,
                                isPrivateMode: _isPrivateMode,
                              );
                            },
                          ),

                    const SizedBox(height: 16),

                    // Allocation section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Portfolio Allocation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Allocation chart (placeholder)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Allocation Chart',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Performance section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Performance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Performance chart (placeholder)
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Performance Chart',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 80), // Extra space for bottom navigation bar
                  ],
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
