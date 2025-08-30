import 'package:flutter/material.dart';

class BounceWrapper extends StatefulWidget {
  final Widget child;
  final bool shouldBounce;
  final VoidCallback? onBounceComplete;

  const BounceWrapper({
    super.key,
    required this.child,
    required this.shouldBounce,
    this.onBounceComplete,
  });

  @override
  State<BounceWrapper> createState() => _BounceWrapperState();
}

class _BounceWrapperState extends State<BounceWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(BounceWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldBounce && !oldWidget.shouldBounce) {
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          widget.onBounceComplete?.call();
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}