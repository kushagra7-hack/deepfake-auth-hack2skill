import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ConstellationBackground extends StatefulWidget {
  const ConstellationBackground({super.key});

  @override
  State<ConstellationBackground> createState() => _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<ConstellationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Cluster> _clusters = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _initSystem();
  }

  void _initSystem() {
    for (int i = 0; i < 50; i++) {
      _clusters.add(_Cluster());
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MorphingPainter(
            clusters: _clusters,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _Cluster {
  late Offset pos;
  late Offset velocity;
  late int size;
  final List<Offset> memberOffsets = [];
  final List<Offset> targetOffsets = [];
  double morphProgress = 0.0;
  bool isMorphing = false;

  _Cluster() {
    _reset(isInitial: true);
  }

  void _reset({bool isInitial = false}) {
    final random = Random();
    if (isInitial) {
      pos = Offset(random.nextDouble(), random.nextDouble());
    } else {
      pos = Offset(0.5 + (random.nextDouble() - 0.5) * 0.05, 0.5 + (random.nextDouble() - 0.5) * 0.05);
    }

    double angle = random.nextDouble() * 2 * pi;
    double speed = 0.0006 + random.nextDouble() * 0.0012;
    velocity = Offset(cos(angle) * speed, sin(angle) * speed);

    size = 4 + random.nextInt(4); // 4 to 8 stars for better shapes
    memberOffsets.clear();
    targetOffsets.clear();
    
    for (int i = 0; i < size; i++) {
      final offset = Offset((random.nextDouble() - 0.5) * 0.15, (random.nextDouble() - 0.5) * 0.15);
      memberOffsets.add(offset);
      targetOffsets.add(offset);
    }
    
    if (random.nextDouble() > 0.4) {
      _assignShape();
    }
  }

  void _assignShape() {
    final random = Random();
    int shapeType = random.nextInt(4); 
    targetOffsets.clear();
    
    // Abstract patterns that feel like shapes
    if (shapeType == 0) { // Fish shape
      targetOffsets.addAll([
        const Offset(0.05, 0), const Offset(0.01, 0.02), const Offset(0.01, -0.02),
        const Offset(-0.02, 0.03), const Offset(-0.02, -0.03), const Offset(-0.05, 0.04), const Offset(-0.05, -0.04)
      ]);
    } else if (shapeType == 1) { // Small Cat-like (with ears)
      targetOffsets.addAll([
        const Offset(-0.02, -0.04), const Offset(0.02, -0.04), // Ears
        const Offset(-0.03, -0.01), const Offset(0.03, -0.01), // Head edges
        const Offset(0, 0.02), // Nose
        const Offset(-0.02, 0.04), const Offset(0.02, 0.04) // Paws/Base
      ]);
    } else if (shapeType == 2) { // Bird-like
      targetOffsets.addAll([
        const Offset(0, 0), // Body
        const Offset(0.06, -0.03), const Offset(-0.06, -0.03), // Wing tips up
        const Offset(0, 0.04), // Tail
      ]);
    } else { // Human Face (Very abstract)
      targetOffsets.addAll([
        const Offset(-0.02, -0.03), const Offset(0.02, -0.03), // Eyes
        const Offset(0, 0), // Nose
        const Offset(-0.015, 0.03), const Offset(0, 0.04), const Offset(0.015, 0.03) // Smile
      ]);
    }
    
    // Resize collections to match
    while (memberOffsets.length < targetOffsets.length) {
      memberOffsets.add(Offset(random.nextDouble() * 0.1, random.nextDouble() * 0.1));
    }
    if (memberOffsets.length > targetOffsets.length) {
      memberOffsets.removeRange(targetOffsets.length, memberOffsets.length);
    }
    size = targetOffsets.length;
    isMorphing = true;
    morphProgress = 0.0;
  }

  void update() {
    pos += velocity;
    
    if (isMorphing) {
      morphProgress += 0.004;
      if (morphProgress >= 1.0) {
        morphProgress = 1.0;
        if (Random().nextDouble() > 0.99) isMorphing = false;
      }
    }

    if (pos.dx < -0.3 || pos.dx > 1.3 || pos.dy < -0.3 || pos.dy > 1.3) {
      _reset();
    }
  }
}

class _MorphingPainter extends CustomPainter {
  final List<_Cluster> clusters;
  final double progress;

  _MorphingPainter({required this.clusters, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    for (var cluster in clusters) {
      cluster.update();
      final cx = cluster.pos.dx * size.width;
      final cy = cluster.pos.dy * size.height;

      paint.strokeWidth = 0.35;
      for (int i = 0; i < cluster.size; i++) {
        for (int j = i + 1; j < cluster.size; j++) {
          final p1 = _getMemberPos(cluster, i);
          final p2 = _getMemberPos(cluster, j);
          
          paint.color = Colors.white.withOpacity(0.05);
          canvas.drawLine(
            Offset(cx + p1.dx * size.width, cy + p1.dy * size.height),
            Offset(cx + p2.dx * size.width, cy + p2.dy * size.height),
            paint,
          );
        }
      }

      for (int i = 0; i < cluster.size; i++) {
        final p = _getMemberPos(cluster, i);
        final mx = cx + p.dx * size.width;
        final my = cy + p.dy * size.height;

        paint.color = Colors.white.withOpacity(0.25);
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
        canvas.drawCircle(Offset(mx, my), 2.0, paint);
        
        paint.maskFilter = null;
        paint.color = Colors.white.withOpacity(0.6);
        canvas.drawCircle(Offset(mx, my), 1.0, paint);
      }
    }
  }

  Offset _getMemberPos(_Cluster cluster, int index) {
    if (index >= cluster.memberOffsets.length || index >= cluster.targetOffsets.length) {
      return Offset.zero;
    }

    if (!cluster.isMorphing) return cluster.memberOffsets[index];
    
    // CLAMP progress to [0, 1] to avoid Assertion Error in Curves
    final double clampedProgress = cluster.morphProgress.clamp(0.0, 1.0);
    
    return Offset.lerp(
      cluster.memberOffsets[index],
      cluster.targetOffsets[index],
      Curves.easeInOutCubic.transform(clampedProgress),
    )!;
  }

  @override
  bool shouldRepaint(covariant _MorphingPainter oldDelegate) => true;
}
