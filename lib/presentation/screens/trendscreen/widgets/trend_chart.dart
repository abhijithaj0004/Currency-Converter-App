import 'package:currency_converter/model/trend_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
// import 'dart:math' as math;

class TrendChart extends StatefulWidget {
  final CurrencyTrend trend;
  final Function(TrendPoint?)? onPointTap;

  const TrendChart({
    super.key,
    required this.trend,
    this.onPointTap,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late AnimationController _pointController;
  late Animation<double> _lineAnimation;
  late Animation<double> _pointAnimation;
  
  TrendPoint? _selectedPoint;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    
    _lineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pointController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _lineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.easeOutCubic,
    ));
    
    _pointAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pointController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _lineController.forward();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _pointController.forward();
    });
  }

  @override
  void dispose() {
    _lineController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 240),
            painter: TrendChartPainter(
              trend: widget.trend,
              lineAnimation: _lineAnimation,
              pointAnimation: _pointAnimation,
              selectedPoint: _selectedPoint,
              theme: theme,
            ),
          ),
          
          // Invisible overlay for touch detection
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) {
                _handleTap(details.localPosition);
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          
          // Tooltip
          if (_selectedPoint != null && _tapPosition != null)
            _buildTooltip(theme),
        ],
      ),
    );
  }
  
  void _handleTap(Offset position) {
    const padding = 20.0;
    final chartWidth = MediaQuery.of(context).size.width - 72; // Account for padding
    // final chartHeight = 200.0;
    
    // Calculate which point was tapped
    final pointWidth = chartWidth / (widget.trend.points.length - 1);
    final tappedIndex = ((position.dx - padding) / pointWidth).round();
    
    if (tappedIndex >= 0 && tappedIndex < widget.trend.points.length) {
      setState(() {
        _selectedPoint = widget.trend.points[tappedIndex];
        _tapPosition = position;
      });
      
      widget.onPointTap?.call(_selectedPoint);
      
      // Auto-hide tooltip after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _selectedPoint = null;
            _tapPosition = null;
          });
        }
      });
    }
  }
  
  Widget _buildTooltip(ThemeData theme) {
    final formatter = intl.DateFormat('MMM d');
    
    return Positioned(
      left: _tapPosition!.dx - 60,
      top: _tapPosition!.dy - 80,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.inverseSurface,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatter.format(_selectedPoint!.date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _selectedPoint!.value.toStringAsFixed(4),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selectedPoint!.changePercent >= 0 ? '+' : ''}${_selectedPoint!.changePercent.toStringAsFixed(2)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _selectedPoint!.changePercent >= 0 
                      ? Colors.green 
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrendChartPainter extends CustomPainter {
  final CurrencyTrend trend;
  final Animation<double> lineAnimation;
  final Animation<double> pointAnimation;
  final TrendPoint? selectedPoint;
  final ThemeData theme;

  TrendChartPainter({
    required this.trend,
    required this.lineAnimation,
    required this.pointAnimation,
    this.selectedPoint,
    required this.theme,
  }) : super(repaint: lineAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = theme.colorScheme.outline.withOpacity(0.2)
      ..strokeWidth = 1;

    const padding = 20.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    // Draw grid lines
    _drawGrid(canvas, size, gridPaint, padding, chartWidth, chartHeight);

    // Calculate points
    final points = _calculatePoints(chartWidth, chartHeight, padding);

    // Draw animated line
    _drawLine(canvas, points, paint);

    // Draw points with animation
    _drawPoints(canvas, points);

    // Draw labels
    _drawLabels(canvas, size, padding, chartWidth, chartHeight);
  }

  void _drawGrid(Canvas canvas, Size size, Paint gridPaint, double padding, 
                 double chartWidth, double chartHeight) {
    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = padding + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(padding, y),
        Offset(padding + chartWidth, y),
        gridPaint,
      );
    }

    // Vertical grid lines
    for (int i = 0; i < trend.points.length; i++) {
      final x = padding + (chartWidth / (trend.points.length - 1)) * i;
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, padding + chartHeight),
        gridPaint,
      );
    }
  }

  List<Offset> _calculatePoints(double chartWidth, double chartHeight, double padding) {
    final points = <Offset>[];
    final minValue = trend.minValue;
    final maxValue = trend.maxValue;
    final range = maxValue - minValue;

    for (int i = 0; i < trend.points.length; i++) {
      final x = padding + (chartWidth / (trend.points.length - 1)) * i;
      final normalizedValue = range > 0 ? (trend.points[i].value - minValue) / range : 0.5;
      final y = padding + chartHeight - (normalizedValue * chartHeight);
      points.add(Offset(x, y));
    }

    return points;
  }

  void _drawLine(Canvas canvas, List<Offset> points, Paint paint) {
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    // Create smooth curve using cubic bezier
    for (int i = 1; i < points.length; i++) {
      final currentPoint = points[i];
      final previousPoint = points[i - 1];
      
      final controlPoint1 = Offset(
        previousPoint.dx + (currentPoint.dx - previousPoint.dx) * 0.3,
        previousPoint.dy,
      );
      final controlPoint2 = Offset(
        currentPoint.dx - (currentPoint.dx - previousPoint.dx) * 0.3,
        currentPoint.dy,
      );

      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        currentPoint.dx, currentPoint.dy,
      );
    }

    // Animate line drawing
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final animatedPath = pathMetric.extractPath(
      0.0,
      pathMetric.length * lineAnimation.value,
    );

    canvas.drawPath(animatedPath, paint);
  }

  void _drawPoints(Canvas canvas, List<Offset> points) {
    final pointPaint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.fill;

    final outerPointPaint = Paint()
      ..color = theme.colorScheme.surface
      ..style = PaintingStyle.fill;

    final selectedPaint = Paint()
      ..color = theme.colorScheme.secondary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final trendPoint = trend.points[i];
      final isSelected = selectedPoint == trendPoint;
      
      final scale = pointAnimation.value;
      final radius = isSelected ? 8.0 * scale : 6.0 * scale;
      final outerRadius = radius + 3.0;

      // Draw outer circle
      canvas.drawCircle(point, outerRadius, outerPointPaint);
      
      // Draw main circle
      canvas.drawCircle(
        point, 
        radius, 
        isSelected ? selectedPaint : pointPaint,
      );
    }
  }

  void _drawLabels(Canvas canvas, Size size, double padding, 
                   double chartWidth, double chartHeight) {
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    
    if (textStyle == null) return;

    // Date labels
    final formatter =intl.DateFormat('MMM d');
    for (int i = 0; i < trend.points.length; i++) {
      final x = padding + (chartWidth / (trend.points.length - 1)) * i;
      final textPainter = TextPainter(
        text: TextSpan(text: formatter.format(trend.points[i].date), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 15),
      );
    }

    // Value labels
    final minText = trend.minValue.toStringAsFixed(3);
    final maxText = trend.maxValue.toStringAsFixed(3);
    
    final minPainter = TextPainter(
      text: TextSpan(text: minText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    
    final maxPainter = TextPainter(
      text: TextSpan(text: maxText, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    
    minPainter.paint(canvas, Offset(5, padding + chartHeight - 10));
    maxPainter.paint(canvas, Offset(5, padding - 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}