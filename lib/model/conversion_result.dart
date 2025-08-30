class ConversionResult {
  final String base;
  final double amount;
  final double convertedAmount;
  final double rate;
  final int ms;

  const ConversionResult({
    required this.base,
    required this.amount,
    required this.convertedAmount,
    required this.rate,
    required this.ms,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>;
    final resultEntry = result.entries.first;
    
    return ConversionResult(
      base: json['base'] as String,
      amount: double.parse(json['amount'].toString()),
      convertedAmount: double.parse(resultEntry.value.toString()),
      rate: double.parse(result['rate'].toString()),
      ms: json['ms'] as int,
    );
  }
}