class TrendPoint {
  final DateTime date;
  final double value;
  final double changePercent;

  const TrendPoint({
    required this.date,
    required this.value,
    required this.changePercent,
  });
}

class CurrencyTrend {
  final String fromCurrency;
  final String toCurrency;
  final List<TrendPoint> points;
  final double minValue;
  final double maxValue;
  final double avgValue;
  final double totalChange;

  const CurrencyTrend({
    required this.fromCurrency,
    required this.toCurrency,
    required this.points,
    required this.minValue,
    required this.maxValue,
    required this.avgValue,
    required this.totalChange,
  });
}