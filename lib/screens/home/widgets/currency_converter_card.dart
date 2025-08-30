import 'package:currency_converter/bloc/currencyconverter/currency_converter_bloc.dart';
import 'package:currency_converter/bloc/currencyconverter/currency_converter_event.dart';
import 'package:currency_converter/bloc/currencyconverter/currency_converter_state.dart';
import 'package:currency_converter/data/currency_data.dart';
import 'package:currency_converter/model/currency.dart';
import 'package:currency_converter/screens/home/widgets/animated_counter.dart';
import 'package:currency_converter/screens/home/widgets/bouncer_wrapper.dart';
import 'package:currency_converter/screens/home/widgets/currency_chip.dart';
import 'package:currency_converter/screens/home/widgets/currency_picker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyConverterCard extends StatefulWidget {
  const CurrencyConverterCard({super.key});

  @override
  State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<CurrencyConverterCard>
    with TickerProviderStateMixin {
  late AnimationController _swapController;
  late AnimationController _resultController;
  late Animation<double> _swapAnimation;
  late Animation<double> _resultScaleAnimation;
  late Animation<Offset> _resultSlideAnimation;
  late TextEditingController _amountController;

  bool _hasInvalidInput = false;

  @override
  void initState() {
    super.initState();

    _swapController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _swapAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _swapController,
      curve: Curves.easeInOut,
    ));

    _resultScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.elasticOut,
    ));

    _resultSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutCubic,
    ));

    final state = context.read<CurrencyConversionBloc>().state;
    _amountController =
        TextEditingController(text: state.amount.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _swapController.dispose();
    _resultController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    _swapController.forward().then((_) {
      context.read<CurrencyConversionBloc>().add(const SwapCurrenciesEvent());
      _swapController.reverse();
    });
  }

  void _showCurrencyPicker({required bool isFromCurrency}) {
    final state = context.read<CurrencyConversionBloc>().state;
    final selectedCurrency = CurrencyData.getCurrencyByCode(
      isFromCurrency ? state.fromCurrency : state.toCurrency,
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencyPickerModal(
        selectedCurrency: selectedCurrency,
        onCurrencySelected: (currency) {
          if (isFromCurrency) {
            context
                .read<CurrencyConversionBloc>()
                .add(UpdateFromCurrencyEvent(currency.code));
          } else {
            context
                .read<CurrencyConversionBloc>()
                .add(UpdateToCurrencyEvent(currency.code));
          }
        },
      ),
    );
  }

  void _validateAndUpdateAmount(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue == null || parsedValue < 0) {
      setState(() => _hasInvalidInput = true);
      HapticFeedback.lightImpact();
    } else {
      setState(() => _hasInvalidInput = false);
      context
          .read<CurrencyConversionBloc>()
          .add(UpdateAmountEvent(parsedValue));
    }
  }

  String _formatCurrency(double amount, String currencyCode) {
    final currency = CurrencyData.getCurrencyByCode(currencyCode);
    return '${currency.symbol}${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CurrencyConversionBloc, CurrencyConversionState>(
      listener: (context, state) {
        if (state.status == ConversionStatus.success && state.result != null) {
          _resultController.forward();
        } else {
          _resultController.reset();
        }
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<CurrencyConversionBloc, CurrencyConversionState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Currency Converter',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // From Currency Section
                  _buildCurrencySection(
                    label: 'From',
                    currency:
                        CurrencyData.getCurrencyByCode(state.fromCurrency),
                    isInput: true,
                    onCurrencyTap: () =>
                        _showCurrencyPicker(isFromCurrency: true),
                    state: state,
                  ),

                  const SizedBox(height: 16),

                  // Swap Button
                  Center(
                    child: AnimatedBuilder(
                      animation: _swapAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _swapAnimation.value * 3.14159,
                          child: IconButton.filled(
                            onPressed: _swapCurrencies,
                            icon: const Icon(Icons.swap_vert),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // To Currency Section
                  _buildCurrencySection(
                    label: 'To',
                    currency: CurrencyData.getCurrencyByCode(state.toCurrency),
                    isInput: false,
                    onCurrencyTap: () =>
                        _showCurrencyPicker(isFromCurrency: false),
                    state: state,
                  ),

                  const SizedBox(height: 24),

                  // Convert Button with loading states
                  _buildConvertButton(state),

                  // Result Card
                  if (state.result != null) ...[
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _resultSlideAnimation,
                      child: ScaleTransition(
                        scale: _resultScaleAnimation,
                        child: _buildResultCard(state),
                      ),
                    ),
                  ],

                  // Error handling
                  if (state.status == ConversionStatus.failure) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Failed to convert currency. Please try again.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencySection({
    required String label,
    required Currency currency,
    required bool isInput,
    required VoidCallback onCurrencyTap,
    required CurrencyConversionState state,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CurrencyChip(
                currency: currency,
                onTap: onCurrencyTap,
                heroTag: '${label}_currency_chip',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isInput)
            BounceWrapper(
              shouldBounce: _hasInvalidInput,
              onBounceComplete: () => setState(() => _hasInvalidInput = false),
              child: TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _hasInvalidInput ? theme.colorScheme.error : null,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.00',
                  prefix: Text(
                    currency.symbol,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  suffixIcon: _hasInvalidInput
                      ? Icon(Icons.error, color: theme.colorScheme.error)
                      : null,
                ),
                onChanged: _validateAndUpdateAmount,
              ),
            )
          else if (state.result != null)
            AnimatedCounter(
              value: state.result!.convertedAmount,
              prefix: currency.symbol,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            )
          else
            Text(
              '${currency.symbol}0.00',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConvertButton(CurrencyConversionState state) {
    final theme = Theme.of(context);
    final isLoading = state.status == ConversionStatus.loading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading
            ? null
            : () {
                if (state.amount > 0) {
                  context.read<CurrencyConversionBloc>().add(
                        ConvertCurrencyEvent(
                          fromCurrency: state.fromCurrency,
                          toCurrency: state.toCurrency,
                          amount: state.amount,
                        ),
                      );
                }
              },
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : const Icon(Icons.currency_exchange),
        label: Text(isLoading ? 'Converting...' : 'Convert'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isLoading ? 0 : 2,
        ),
      ),
    );
  }

  Widget _buildResultCard(CurrencyConversionState state) {
    final theme = Theme.of(context);
    final result = state.result!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Conversion Result',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exchange Rate:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
              Text(
                '1 ${state.fromCurrency} = ${result.rate.toStringAsFixed(4)} ${state.toCurrency}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Processing Time:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
              Text(
                '${result.ms}ms',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}