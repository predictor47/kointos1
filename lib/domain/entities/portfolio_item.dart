import 'package:json_annotation/json_annotation.dart';

part 'portfolio_item.g.dart';

@JsonSerializable()
class PortfolioItem {
  final String id;
  final String userId;
  final String symbol;
  final String name;
  final double amount;
  final double averageBuyPrice;
  final double currentPrice;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get profitLoss => (currentPrice - averageBuyPrice) * amount;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get profitLossPercentage =>
      ((currentPrice - averageBuyPrice) / averageBuyPrice) * 100;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get totalValue => amount * currentPrice;

  final DateTime lastUpdated;
  final String? imageUrl;

  PortfolioItem({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.averageBuyPrice,
    required this.currentPrice,
    required this.lastUpdated,
    this.imageUrl,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioItemToJson(this);

  PortfolioItem copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? name,
    double? amount,
    double? averageBuyPrice,
    double? currentPrice,
    DateTime? lastUpdated,
    String? imageUrl,
  }) {
    return PortfolioItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      averageBuyPrice: averageBuyPrice ?? this.averageBuyPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory PortfolioItem.mock({
    required String id,
    required String userId,
    required String symbol,
    required String name,
    required double amount,
    required double averageBuyPrice,
    required double currentPrice,
    String? imageUrl,
  }) {
    return PortfolioItem(
      id: id,
      userId: userId,
      symbol: symbol,
      name: name,
      amount: amount,
      averageBuyPrice: averageBuyPrice,
      currentPrice: currentPrice,
      lastUpdated: DateTime.now(),
      imageUrl: imageUrl,
    );
  }
}
