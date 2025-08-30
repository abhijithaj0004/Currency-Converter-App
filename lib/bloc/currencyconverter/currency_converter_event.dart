abstract class CurrencyConversionEvent {
  const CurrencyConversionEvent();
}

class ConvertCurrencyEvent extends CurrencyConversionEvent {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const ConvertCurrencyEvent({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });
}

class SwapCurrenciesEvent extends CurrencyConversionEvent {
  const SwapCurrenciesEvent();
}

class UpdateFromCurrencyEvent extends CurrencyConversionEvent {
  final String currency;

  const UpdateFromCurrencyEvent(this.currency);
}

class UpdateToCurrencyEvent extends CurrencyConversionEvent {
  final String currency;

  const UpdateToCurrencyEvent(this.currency);
}

class UpdateAmountEvent extends CurrencyConversionEvent {
  final double amount;

  const UpdateAmountEvent(this.amount);
}