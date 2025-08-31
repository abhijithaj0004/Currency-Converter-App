
// lib/widgets/trend_bottom_sheet.dart
import 'package:currency_converter/data/mock_trend_data.dart';
import 'package:currency_converter/model/trend_data.dart';
import 'package:currency_converter/presentation/screens/trendscreen/trend_screen.dart';
import 'package:currency_converter/presentation/screens/trendscreen/widgets/trend_stats_chip.dart';
import 'package:flutter/material.dart';
import '../widgets/trend_chart.dart';
import 'package:intl/intl.dart';

class TrendBottomSheet extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;

  const TrendBottomSheet({
    super.key,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  State<TrendBottomSheet> createState() => _TrendBottomSheetState();
}

class _TrendBottomSheetState extends State<TrendBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _sheetController;
  late AnimationController _contentController;
  late Animation<double> _sheetAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  
  late CurrencyTrend _trend;

  @override
  void initState() {
    super.initState();
    
    _trend = MockTrendData.generateTrend(
      widget.fromCurrency,
      widget.toCurrency,
    );
    
    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _sheetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    ));
    
    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
    
    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _sheetController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AnimatedBuilder(
      animation: _sheetAnimation,
      builder: (context, child) {
        return Container(
          height: screenHeight * 0.85 * _sheetAnimation.value,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          SlideTransition(
            position: _contentSlideAnimation,
            child: FadeTransition(
              opacity: _contentFadeAnimation,
              child: _buildHeader(theme),
            ),
          ),

          // Content
          Expanded(
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: FadeTransition(
                opacity: _contentFadeAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      
                      // Trend summary
                      _buildTrendSummary(theme),
                      
                      const SizedBox(height: 20),
                      
                      // Chart
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TrendChart(
                          trend: _trend,
                          onPointTap: (point) {
                            if (point != null) {
                              _showPointDetails(context, point);
                            }
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Statistics
                      TrendStatsChips(trend: _trend),
                      
                      const SizedBox(height: 20),
                      
                      // Action buttons
                      _buildActionButtons(theme),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.trending_up,
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.fromCurrency} → ${widget.toCurrency}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '5-Day Trend Analysis',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSummary(ThemeData theme) {
    final isPositive = _trend.totalChange >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive 
              ? [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)]
              : [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPositive 
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Change',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${isPositive ? '+' : ''}${_trend.totalChange.toStringAsFixed(2)}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrendScreen(
                      fromCurrency: widget.fromCurrency,
                      toCurrency: widget.toCurrency,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.fullscreen),
              label: const Text('Full View'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                // Share functionality
                _shareTrend();
              },
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPointDetails(BuildContext context, TrendPoint point) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('Rate Details'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', DateFormat('MMMM d, yyyy').format(point.date)),
            _buildDetailRow('Rate', point.value.toStringAsFixed(4)),
            _buildDetailRow('Change', '${point.changePercent >= 0 ? '+' : ''}${point.changePercent.toStringAsFixed(2)}%'),
            _buildDetailRow('Pair', '${widget.fromCurrency} → ${widget.toCurrency}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _shareTrend() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trend data copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Show trend bottom sheet function
void showTrendBottomSheet(
  BuildContext context, {
  required String fromCurrency,
  required String toCurrency,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TrendBottomSheet(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    ),
  );
}