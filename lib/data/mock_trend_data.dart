import 'package:currency_converter/model/trend_data.dart';

import 'dart:math';

class MockTrendData {
  static CurrencyTrend generateTrend(String fromCurrency, String toCurrency) {
    final random = Random();
    final now = DateTime.now();
    final baseRate = _getBaseRate(fromCurrency, toCurrency);
    
    // Generate 5 days of mock data
    final points = <TrendPoint>[];
    double currentRate = baseRate;
    
    for (int i = 4; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      
      // Generate realistic fluctuation (±3% per day)
      final changePercent = (random.nextDouble() - 0.5) * 6;
      currentRate = currentRate * (1 + (changePercent / 100));
      
      points.add(TrendPoint(
        date: date,
        value: currentRate,
        changePercent: changePercent,
      ));
    }
    
    // Calculate statistics
    final values = points.map((p) => p.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final avgValue = values.reduce((a, b) => a + b) / values.length;
    final totalChange = ((points.last.value - points.first.value) / points.first.value) * 100;
    
    return CurrencyTrend(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      points: points,
      minValue: minValue,
      maxValue: maxValue,
      avgValue: avgValue,
      totalChange: totalChange,
    );
  }
  
  static double _getBaseRate(String from, String to) {
    // Mock base rates for common currency pairs
    final rates = {
      'USD_EUR': 0.85,
      'EUR_USD': 1.18,
      'USD_GBP': 0.73,
      'GBP_USD': 1.37,
      'USD_JPY': 110.0,
      'JPY_USD': 0.009,
      'USD_INR': 74.5,
      'INR_USD': 0.013,
      'EUR_GBP': 0.86,
      'GBP_EUR': 1.16,
    };
    
    final key = '${from}_$to';
    return rates[key] ?? 1.0;
  }
}