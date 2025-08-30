class Currency {
  final String code;
  final String name;
  final String flag;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.flag,
    required this.symbol,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}