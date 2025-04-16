// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portfolio _$PortfolioFromJson(Map<String, dynamic> json) => Portfolio(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PortfolioToJson(Portfolio instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
      'totalValue': instance.totalValue,
    };
