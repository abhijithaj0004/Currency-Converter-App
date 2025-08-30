import 'package:currency_converter/model/conversion_result.dart';

import '../services/api_client.dart';

class CurrencyRepository {
  final ApiClient _apiClient;

  CurrencyRepository(this._apiClient);

  Future<ConversionResult> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final response = await _apiClient.dio.get('/convert', queryParameters: {
        'from': from,
        'to': to,
        'amount': amount.toString(),
      });

      return ConversionResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }
}