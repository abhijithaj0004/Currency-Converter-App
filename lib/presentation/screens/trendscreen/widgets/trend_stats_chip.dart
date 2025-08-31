import 'package:currency_converter/model/trend_data.dart';
import 'package:flutter/material.dart';


class TrendStatsChips extends StatefulWidget {
  final CurrencyTrend trend;

  const TrendStatsChips({
    super.key,
    required this.trend,
  });

  @override
  State<TrendStatsChips> createState() => _TrendStatsChipsState();
}

class _TrendStatsChipsState extends State<TrendStatsChips>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered animations
    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          1.0,
          curve: Curves.easeInOut,
        ),
      ));
    });

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final stats = [
      {'label': 'MIN', 'value': widget.trend.minValue.toStringAsFixed(4), 'color': theme.colorScheme.error},
      {'label': 'AVG', 'value': widget.trend.avgValue.toStringAsFixed(4), 'color': theme.colorScheme.primary},
      {'label': 'MAX', 'value': widget.trend.maxValue.toStringAsFixed(4), 'color': theme.colorScheme.tertiary},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          final stat = stats[index];
          
          return SlideTransition(
            position: _slideAnimations[index],
            child: FadeTransition(
              opacity: _fadeAnimations[index],
              child: _StatChip(
                label: stat['label'] as String,
                value: stat['value'] as String,
                color: stat['color'] as Color,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}