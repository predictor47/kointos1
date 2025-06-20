import 'package:json_annotation/json_annotation.dart';

part 'cryptocurrency.g.dart';

@JsonSerializable()
class Cryptocurrency {
  final String id;
  final String symbol;
  final String name;

  @JsonKey(name: 'current_price')
  final double currentPrice;

  @JsonKey(name: 'market_cap')
  final double marketCap;

  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;

  @JsonKey(name: 'total_volume')
  final double totalVolume;

  @JsonKey(name: 'high_24h')
  final double? high24h;

  @JsonKey(name: 'low_24h')
  final double? low24h;

  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;

  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;

  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;

  @JsonKey(name: 'total_supply')
  final double? totalSupply;

  @JsonKey(name: 'max_supply')
  final double? maxSupply;

  @JsonKey(name: 'image')
  final String imageUrl;

  @JsonKey(name: 'sparkline_in_7d')
  final Map<String, List<double>>? sparklineData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? description;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic>? additionalDetails;

  final bool isFavorite;

  Cryptocurrency({
    required this.id,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.marketCap,
    this.marketCapRank,
    required this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.imageUrl,
    this.sparklineData,
    this.description,
    this.additionalDetails,
    this.isFavorite = false,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) =>
      _$CryptocurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CryptocurrencyToJson(this);

  factory Cryptocurrency.fromSearchJson(Map<String, dynamic> json) {
    return Cryptocurrency(
      id: json['id'] as String,
      symbol: (json['symbol'] as String? ?? '').toLowerCase(),
      name: json['name'] as String? ?? '',
      currentPrice: 0, // Price not available in search results
      marketCap: 0, // Market cap not available in search results
      totalVolume: 0, // Volume not available in search results
      imageUrl: json['large'] as String? ??
          '', // 'large' is the image URL in search results
      marketCapRank: json['market_cap_rank'] as int?,
    );
  }

  Cryptocurrency copyWith({
    String? id,
    String? symbol,
    String? name,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? totalVolume,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? circulatingSupply,
    double? totalSupply,
    double? maxSupply,
    String? imageUrl,
    Map<String, List<double>>? sparklineData,
    String? description,
    Map<String, dynamic>? additionalDetails,
    bool? isFavorite,
  }) {
    return Cryptocurrency(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      totalVolume: totalVolume ?? this.totalVolume,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      maxSupply: maxSupply ?? this.maxSupply,
      imageUrl: imageUrl ?? this.imageUrl,
      sparklineData: sparklineData ?? this.sparklineData,
      description: description ?? this.description,
      additionalDetails: additionalDetails ?? this.additionalDetails,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Helper methods
  bool get hasPriceChange => priceChangePercentage24h != null;
  bool get hasPositivePriceChange =>
      hasPriceChange && priceChangePercentage24h! > 0;

  String get formattedMarketCap => marketCap >= 1000000000
      ? '${(marketCap / 1000000000).toStringAsFixed(2)}B'
      : marketCap >= 1000000
          ? '${(marketCap / 1000000).toStringAsFixed(2)}M'
          : marketCap.toStringAsFixed(2);

  String get formattedPriceChange {
    if (!hasPriceChange) return '0.00%';
    final change = priceChangePercentage24h!;
    final prefix = change >= 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(2)}%';
  }
}
