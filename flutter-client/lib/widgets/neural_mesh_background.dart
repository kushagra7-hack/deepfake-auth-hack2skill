import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });
}

class NeuralMeshBackground extends StatefulWidget {
  const NeuralMeshBackground({super.key});

  @override
  State<NeuralMeshBackground> createState() => _NeuralMeshBackgroundState();
}

class _NeuralMeshBackgroundState extends State<NeuralMeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _rnd = Random();
  Offset? _mousePos;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    
    // Defer particle initialization until we have constraints in CustomPaint
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    for (int i = 0; i < 60; i++) {
      _particles.add(Particle(
        x: _rnd.nextDouble() * size.width,
        y: _rnd.nextDouble() * size.height,
        vx: (_rnd.nextDouble() - 0.5) * 1.5,
        vy: (_rnd.nextDouble() - 0.5) * 1.5,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('neural-mesh'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _controller.stop();
        } else if (!_controller.isAnimating) {
          _controller.repeat();
        }
      },
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            _mousePos = e.localPosition;
          });
        },
        onExit: (e) {
          setState(() {
            _mousePos = null;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                _initParticles(size);
                return CustomPaint(
                  size: size,
                  painter: _NeuralMeshPainter(
                    particles: _particles,
                    mousePos: _mousePos,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NeuralMeshPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePos;
  
  _NeuralMeshPainter({required this.particles, this.mousePos});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (var p in particles) {
      // Repulsion logic
      if (mousePos != null) {
        double dx = p.x - mousePos!.dx;
        double dy = p.y - mousePos!.dy;
        double dist = sqrt(dx * dx + dy * dy);
        
        if (dist < 150) {
          double force = (150 - dist) / 150;
          p.x += (dx / dist) * force * 2;
          p.y += (dy / dist) * force * 2;
        }
      }

      // Update positions
      p.x += p.vx;
      p.y += p.vy;

      // Bounce
      if (p.x < 0) { p.x = 0; p.vx *= -1; }
      if (p.x > size.width) { p.x = size.width; p.vx *= -1; }
      if (p.y < 0) { p.y = 0; p.vy *= -1; }
      if (p.y > size.height) { p.y = size.height; p.vy *= -1; }

      // Draw particle
      canvas.drawCircle(Offset(p.x, p.y), 1.5, paint);
    }

    // Draw lines
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        double dx = particles[i].x - particles[j].x;
        double dy = particles[i].y - particles[j].y;
        double dist = sqrt(dx * dx + dy * dy);

        if (dist < 100) {
          double opacity = 1.0 - (dist / 100);
          linePaint.color = Colors.cyanAccent.withOpacity(opacity * 0.5);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralMeshPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
