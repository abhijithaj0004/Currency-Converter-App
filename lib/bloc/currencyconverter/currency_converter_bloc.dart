import 'package:currency_converter/bloc/currencyconverter/currency_converter_event.dart';
import 'package:currency_converter/bloc/currencyconverter/currency_converter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/currency_repository.dart';

class CurrencyConversionBloc extends Bloc<CurrencyConversionEvent, CurrencyConversionState> {
  final CurrencyRepository _repository;

  CurrencyConversionBloc(this._repository) : super(const CurrencyConversionState()) {
    on<ConvertCurrencyEvent>(_onConvertCurrency);
    on<SwapCurrenciesEvent>(_onSwapCurrencies);
    on<UpdateFromCurrencyEvent>(_onUpdateFromCurrency);
    on<UpdateToCurrencyEvent>(_onUpdateToCurrency);
    on<UpdateAmountEvent>(_onUpdateAmount);
  }

  Future<void> _onConvertCurrency(
    ConvertCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) async {
    emit(state.copyWith(status: ConversionStatus.loading));

    try {
      final result = await _repository.convertCurrency(
        from: event.fromCurrency,
        to: event.toCurrency,
        amount: event.amount,
      );

      emit(state.copyWith(
        status: ConversionStatus.success,
        result: result,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ConversionStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void _onSwapCurrencies(
    SwapCurrenciesEvent event,
    Emitter<CurrencyConversionState> emit,
  ) {
    emit(state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
      result: null,
      status: ConversionStatus.initial,
    ));
  }

  void _onUpdateFromCurrency(
    UpdateFromCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) {
    emit(state.copyWith(
      fromCurrency: event.currency,
      result: null,
      status: ConversionStatus.initial,
    ));
  }

  void _onUpdateToCurrency(
    UpdateToCurrencyEvent event,
    Emitter<CurrencyConversionState> emit,
  ) {
    emit(state.copyWith(
      toCurrency: event.currency,
      result: null,
      status: ConversionStatus.initial,
    ));
  }

  void _onUpdateAmount(
    UpdateAmountEvent event,
    Emitter<CurrencyConversionState> emit,
  ) {
    emit(state.copyWith(
      amount: event.amount,
      result: null,
      status: ConversionStatus.initial,
    ));
  }
}