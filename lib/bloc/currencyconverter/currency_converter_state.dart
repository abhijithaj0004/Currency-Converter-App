import 'package:currency_converter/model/conversion_result.dart';


enum ConversionStatus { initial, loading, success, failure }

class CurrencyConversionState {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final ConversionResult? result;
  final ConversionStatus status;
  final String? error;

  const CurrencyConversionState({
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.amount = 100.0,
    this.result,
    this.status = ConversionStatus.initial,
    this.error,
  });

  CurrencyConversionState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    ConversionResult? result,
    ConversionStatus? status,
    String? error,
  }) {
    return CurrencyConversionState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}