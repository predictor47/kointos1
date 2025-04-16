import 'package:json_annotation/json_annotation.dart';
import 'portfolio_item.dart';

part 'portfolio.g.dart';

@JsonSerializable()
class Portfolio {
  final String id;
  final String userId;
  final List<PortfolioItem> items;
  final double totalValue;

  Portfolio({
    required this.id,
    required this.userId,
    required this.items,
    this.totalValue = 0.0,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) =>
      _$PortfolioFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioToJson(this);

  Portfolio copyWith({
    String? id,
    String? userId,
    List<PortfolioItem>? items,
    double? totalValue,
  }) {
    return Portfolio(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalValue: totalValue ?? this.totalValue,
    );
  }

  Portfolio addItem(PortfolioItem item) {
    return copyWith(
      items: [...items, item],
    );
  }

  Portfolio removeItem(String itemId) {
    return copyWith(
      items: items.where((item) => item.id != itemId).toList(),
    );
  }

  Portfolio updateItem(PortfolioItem updatedItem) {
    return copyWith(
      items: items
          .map((item) => item.id == updatedItem.id ? updatedItem : item)
          .toList(),
    );
  }
}
