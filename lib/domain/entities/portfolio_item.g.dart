// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioItem _$PortfolioItemFromJson(Map<String, dynamic> json) =>
    PortfolioItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      averageBuyPrice: (json['averageBuyPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$PortfolioItemToJson(PortfolioItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'symbol': instance.symbol,
      'name': instance.name,
      'amount': instance.amount,
      'averageBuyPrice': instance.averageBuyPrice,
      'currentPrice': instance.currentPrice,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'imageUrl': instance.imageUrl,
    };
