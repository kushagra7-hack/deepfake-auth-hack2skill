import 'dart:math';
import 'package:flutter/material.dart';

class _Star {
  double x;
  double y;
  final double z; // depth 0.1 = far, 1.0 = close
  final double size;
  final double opacity;

  _Star({
    required this.x,
    required this.y,
    required this.z,
    required this.size,
    required this.opacity,
  });
}

class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key});

  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final Random _random = Random();

  Offset _mousePosition = Offset.zero;
  Offset _lastMousePosition = Offset.zero;
  double _speedBoost = 0.0; // extra speed multiplier when cursor moves fast

  static const int _starCount = 250;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_tick)..repeat();
  }

  void _initStars(Size size) {
    if (_stars.isEmpty) {
      for (int i = 0; i < _starCount; i++) {
        _stars.add(_Star(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          z: _random.nextDouble() * 0.9 + 0.1,
          size: _random.nextDouble() * 2.5 + 0.5,
          opacity: _random.nextDouble() * 0.7 + 0.3,
        ));
      }
    }
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      // Decay speed boost over time
      _speedBoost = (_speedBoost * 0.90).clamp(0.0, 8.0);
    });
  }

  void _onHover(PointerEvent event) {
    final dx = (event.position.dx - _lastMousePosition.dx).abs();
    final dy = (event.position.dy - _lastMousePosition.dy).abs();
    final speed = sqrt(dx * dx + dy * dy);
    _speedBoost = (speed * 0.3).clamp(0.0, 8.0);
    _lastMousePosition = event.position;
    _mousePosition = event.position;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: _onHover,
      onPointerMove: _onHover,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _initStars(size);
          return CustomPaint(
            painter: _StarfieldPainter(
              stars: _stars,
              size: size,
              speedBoost: _speedBoost,
              mousePosition: _mousePosition,
              random: _random,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final Size size;
  final double speedBoost;
  final Offset mousePosition;
  final Random random;

  _StarfieldPainter({
    required this.stars,
    required this.size,
    required this.speedBoost,
    required this.mousePosition,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final double baseSpeed = 0.12;
    final double totalSpeed = baseSpeed + speedBoost * 0.18;

    // Update star positions
    for (final star in stars) {
      // Drift downward at different speeds based on depth (parallax)
      star.y += totalSpeed * star.z;

      // Slight horizontal drift towards cursor
      if (mousePosition != Offset.zero) {
        final cx = canvasSize.width / 2;
        final cy = canvasSize.height / 2;
        final dx = (mousePosition.dx - cx) / canvasSize.width;
        final dy = (mousePosition.dy - cy) / canvasSize.height;
        star.x += dx * star.z * 0.3 * (1 + speedBoost * 0.1);
        star.y += dy * star.z * 0.1 * (1 + speedBoost * 0.1);
      }

      // Wrap stars around edges
      if (star.y > canvasSize.height + 2) {
        star.y = -2;
        star.x = random.nextDouble() * canvasSize.width;
      }
      if (star.x < -2) star.x = canvasSize.width + 2;
      if (star.x > canvasSize.width + 2) star.x = -2;
    }

    final paint = Paint()..isAntiAlias = true;

    for (final star in stars) {
      final alpha = (star.opacity * 255).toInt().clamp(0, 255);
      // Close stars are more blue-white, far stars are dim white
      final Color starColor = star.z > 0.6
          ? Color.fromARGB(alpha, 180, 230, 255)  // Close: light blue-white
          : Color.fromARGB(alpha, 140, 180, 220); // Far: dimmer blue

      paint.color = starColor;

      final double drawSize = star.size * star.z * (1 + speedBoost * 0.05);

      // At high speed, draw star streaks
      if (speedBoost > 2.0) {
        final streakLength = speedBoost * star.z * 2.5;
        paint.strokeWidth = drawSize * 0.7;
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(star.x, star.y),
          Offset(star.x, star.y - streakLength),
          paint,
        );
      } else {
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(star.x, star.y), drawSize.clamp(0.3, 3.0), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}
