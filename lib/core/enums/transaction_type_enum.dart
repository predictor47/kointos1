enum TransactionTypeEnum {
  buy('BUY', 'Buy Orders'),
  sell('SELL', 'Sell Orders'),
  transferIn('TRANSFER_IN', 'Transfers In'),
  transferOut('TRANSFER_OUT', 'Transfers Out');

  const TransactionTypeEnum(this.value, this.displayName);

  final String value;
  final String displayName;

  static TransactionTypeEnum? fromString(String value) {
    for (final type in TransactionTypeEnum.values) {
      if (type.value == value) return type;
    }
    return null;
  }

  bool get isIncoming => this == buy || this == transferIn;
  bool get isOutgoing => this == sell || this == transferOut;
}
