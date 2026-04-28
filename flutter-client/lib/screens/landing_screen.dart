import 'dart:ui';
import 'dart:math'; // For pi
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/starfield_background.dart';
import '../widgets/constellation_background.dart';
import '../widgets/trust_button.dart';

// --- Design Tokens ---
const _kBg = Color(0xFF000000);
const _kPrimary = Color(0xFFFFFFFF);
const _kSecondary = Color(0xFFFFFFFF);
const _kSurface = Color(0x1AFFFFFF); // 10% white
const _kBorder = Color(0x33FFFFFF);  // 20% white

// Legacy mappings for backwards compatibility
const _kBlue = Color(0xFF00E5FF); // Cyber Blue accent
const _kPurple = _kSecondary;
const _kZinc400 = Color(0xFFA1A1AA);

class MouseParallax extends StatelessWidget {
  final Widget child;
  final Offset mousePosition;
  final double depth;

  const MouseParallax({
    super.key,
    required this.child,
    required this.mousePosition,
    this.depth = 0.0002,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    final centerX = width / 2;
    final centerY = height / 2;
    
    final rotX = (mousePosition.dy - centerY) * depth; 
    final rotY = (mousePosition.dx - centerX) * -depth;
    
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(rotX)
        ..rotateY(rotY),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _productKey = GlobalKey();
  final GlobalKey _architectureKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  
  Offset _mousePosition = Offset.zero;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: MouseRegion(
        onHover: (event) => setState(() => _mousePosition = event.position),
        child: Stack(
          children: [
          const ConstellationBackground(),

          // Main Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    HeroSection(mousePosition: _mousePosition),
                    const SizedBox(height: 60),
                    InteractiveExplainerSection(key: _howItWorksKey, mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    FeatureGridsSection(key: _productKey, mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    ThreeColumnFeatureStrip(mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    TestimonialsCarousel(mousePosition: _mousePosition),
                    const SizedBox(height: 120),
                    CrossPlatformSection(key: _architectureKey, mousePosition: _mousePosition),
                    const SizedBox(height: 80),
                    FooterSection(key: _contactKey),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: _kBg.withAlpha(210),
              border: const Border(bottom: BorderSide(color: _kBorder)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withAlpha(80)),
                      boxShadow: [BoxShadow(color: Colors.white.withAlpha(40), blurRadius: 20, spreadRadius: -2)],
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      'NEXUS_GATEWAY',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: isDesktop ? 18 : 14,
                        letterSpacing: isDesktop ? 2.0 : 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isDesktop) ...[
                    const Spacer(),
                    _navLink('Product', _productKey),
                    const SizedBox(width: 12),
                    _navLink('Architecture', _architectureKey),
                    const SizedBox(width: 12),
                    _navLink('How it works', _howItWorksKey),
                    const SizedBox(width: 12),
                    _HoverNavLink(
                      title: 'API Docs',
                      onTapOverride: () {
                        Navigator.pushNamed(context, '/api_docs');
                      },
                    ),
                    const SizedBox(width: 12),
                    _navLink('Contact', _contactKey),
                    const SizedBox(width: 24),
                  ] else
                    const Spacer(),
                  AnimatedScaleHoverWrapper(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withAlpha(100)),
                          boxShadow: [BoxShadow(color: Colors.white.withAlpha(40), blurRadius: 20)],
                        ),
                        child: Text(
                          isDesktop ? 'Deploy Now' : 'Login',
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isDesktop ? 14 : 12, letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _navLink(String title, GlobalKey? key) {
    return _HoverNavLink(title: title, globalKey: key);
  }
}

class _HoverNavLink extends StatefulWidget {
  final String title;
  final GlobalKey? globalKey;
  final VoidCallback? onTapOverride;
  const _HoverNavLink({required this.title, this.globalKey, this.onTapOverride});
  @override
  State<_HoverNavLink> createState() => _HoverNavLinkState();
}

class _HoverNavLinkState extends State<_HoverNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.onTapOverride != null) {
            widget.onTapOverride!();
            return;
          }
          if (widget.globalKey != null && widget.globalKey!.currentContext != null) {
            Scrollable.ensureVisible(
              widget.globalKey!.currentContext!,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              alignment: 0.1,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? _kBlue.withAlpha(15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? _kBlue.withAlpha(40) : Colors.transparent,
            ),
          ),
          child: Text(
            widget.title,
            style: GoogleFonts.outfit(
              color: _hovered ? Colors.white : _kZinc400,
              fontSize: 14,
              fontWeight: _hovered ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION (Phase 1)
// ─────────────────────────────────────────────────────────────────────────────

class HeroSection extends StatelessWidget {
  final Offset mousePosition;
  const HeroSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isTabletOrMobile = screenWidth < 950; // Breakpoint for tablet
    final isDesktop = !isTabletOrMobile;

    // 3D Antigravity Parallax Calculations
    final centerX = screenWidth / 2;
    final centerY = height / 2;
    
    // Calculate rotation angles (pitch and yaw)
    final rotX = (mousePosition.dy - centerY) * 0.0003; 
    final rotY = (mousePosition.dx - centerX) * -0.0003;
    
    final transformMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001); // No base tilt or mouse rotation

    final leftContent = Transform(
      transform: transformMatrix,
      alignment: FractionalOffset.center,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Super title badge — FittedBox prevents overflow on narrow screens
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _kBlue.withAlpha(15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _kBlue.withAlpha(50)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: _kBlue, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(
                  'ENTERPRISE SECURITY',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white, letterSpacing: 2.0, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Heading
        _InteractiveElement(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: isDesktop ? 72 : 48,
                height: 1.1,
                letterSpacing: -2.0,
              ),
              children: const [
                TextSpan(
                  text: 'Detect The \n',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'Undetectable',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Subtitle
        _InteractiveElement(
          child: Text(
            'Upload media, analyze pixel-level anomalies via\nHugging Face, and verify context with Gemini AI.',
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: isDesktop ? 18 : 15,
              height: 1.6,
            ),
            softWrap: true,
          ),
        ),
        const SizedBox(height: 48),
        // CTA
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.start,
          children: [
            TrustButton(
              label: 'ENTER DASHBOARD',
              isForwardAction: true,
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ],
      ),
    );

    final rightContent = Center(
      child: _CinematicFeatureCard(mousePosition: mousePosition),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 100 : 60),
      child: isDesktop 
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: leftContent),
                const SizedBox(width: 40),
                Expanded(flex: 12, child: rightContent),
              ],
            )
          : Column(
              children: [
                leftContent,
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: rightContent,
                ),
              ],
            ),
    );
  }
}

class _CinematicFeatureCard extends StatefulWidget {
  final Offset mousePosition;
  const _CinematicFeatureCard({required this.mousePosition});

  @override
  State<_CinematicFeatureCard> createState() => _CinematicFeatureCardState();
}

class _CinematicFeatureCardState extends State<_CinematicFeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Calculate relative tilt based on mouse position
    // We assume the card is roughly in the center-right of the screen
    final size = MediaQuery.of(context).size;
    final cardCenterX = size.width * 0.7; // Estimated center of the card
    final cardCenterY = size.height * 0.5;

    final dx = (widget.mousePosition.dx - cardCenterX) / (size.width * 0.3);
    final dy = (widget.mousePosition.dy - cardCenterY) / (size.height * 0.3);

    // Full 360-degree rotation based on mouse position (Full Physics)
    final tiltX = _hovered ? (-dy * pi * 2).clamp(-pi * 2, pi * 2) : 0.0;
    final tiltY = _hovered ? (dx * pi * 2).clamp(-pi * 2, pi * 2) : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.elasticOut,
        transformAlignment: Alignment.center, // Ensures centered rotation
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX)
          ..rotateY(tiltY),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha(_hovered ? 30 : 15),
              blurRadius: _hovered ? 100 : 40,
              spreadRadius: 0,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Stack(
              children: [
                // ── Image with cinematic treatment ──
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Image
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          1.2, 0, 0, 0, -20,
                          0, 1.2, 0, 0, -20,
                          0, 0, 1.2, 0, -20,
                          0, 0, 0, 1, 0,
                        ]),
                        child: Image.asset(
                          'assets/images/hero_feature.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.black,
                            child: const Center(child: Icon(Icons.image_not_supported, color: Colors.white10)),
                          ),
                        ),
                      ),
                      // Vignette
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(180),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Reflection overlay that follows mouse
                      Positioned.fill(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(tiltY, tiltX),
                              end: Alignment(-tiltY, -tiltX),
                              colors: [
                                Colors.white.withAlpha(20),
                                Colors.transparent,
                                Colors.black.withAlpha(40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Inner Glow Border ──
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withAlpha(_hovered ? 50 : 20),
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// INTERACTIVE EXPLAINER (Phase 2)
// ─────────────────────────────────────────────────────────────────────────────
class InteractiveExplainerSection extends StatefulWidget {
  final Offset mousePosition;
  const InteractiveExplainerSection({super.key, required this.mousePosition});

  @override
  State<InteractiveExplainerSection> createState() => _InteractiveExplainerSectionState();
}

class _InteractiveExplainerSectionState extends State<InteractiveExplainerSection>
    with SingleTickerProviderStateMixin {
  // null = none locked, otherwise index of the locked node
  int? _lockedIndex;
  late AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  void _onNodeTap(int index) {
    setState(() {
      // Toggle: tap again to close, tap different to switch
      _lockedIndex = (_lockedIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'RELIABLE PROTECTION',
            style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(
            'How it works',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1),
          ),
          const SizedBox(height: 16),
          Text(
            'A fully distributed architectural pipeline designed to identify manipulations\nin real-time via clustered AI modules.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Instruction hint
          AnimatedOpacity(
            opacity: _lockedIndex == null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, color: _kZinc400, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Hover to preview · Click to lock open',
                  style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),

          // Canvas area — desktop: Positioned stack; mobile: simple Column
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            if (isMobile) {
              return Column(
                children: [
                  InteractiveExplainerNode(
                    index: 0, lockedIndex: _lockedIndex,
                    title: 'FastAPI Backend',
                    description: 'Stateless asynchronous microservices handling high-throughput payload ingestion and routing securely.',
                    icon: Icons.api_rounded, onTap: _onNodeTap,
                  ),
                  const SizedBox(height: 16),
                  InteractiveExplainerNode(
                    index: 1, lockedIndex: _lockedIndex,
                    title: 'Hugging Face Inference',
                    description: 'Deploying custom fine-tuned visual transformers to locate pixel-level artifacting and noise models.',
                    icon: Icons.biotech_outlined, onTap: _onNodeTap,
                  ),
                  const SizedBox(height: 16),
                  InteractiveExplainerNode(
                    index: 2, lockedIndex: _lockedIndex,
                    title: 'Gemini Multimodal',
                    description: 'Advanced LLM reasoning engine that validates contextual semantics and verifies environment constraints.',
                    icon: Icons.auto_awesome, onTap: _onNodeTap,
                  ),
                ],
              );
            }
            return MouseParallax(
              mousePosition: widget.mousePosition,
              depth: 0.00015,
              child: SizedBox(
                height: 420,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Connective animated flow lines
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _flowController,
                        builder: (context, _) => CustomPaint(
                          painter: _AnimatedFlowLinePainter(phase: _flowController.value),
                        ),
                      ),
                    ),
                    // Node 0 — FastAPI Backend
                    Positioned(
                      left: 0, top: 120,
                      child: InteractiveExplainerNode(
                        index: 0, lockedIndex: _lockedIndex,
                        title: 'FastAPI Backend',
                        description: 'Stateless asynchronous microservices handling high-throughput payload ingestion and routing securely.',
                        icon: Icons.api_rounded, onTap: _onNodeTap,
                      ),
                    ),
                    // Node 1 — Hugging Face
                    Positioned(
                      top: 0, right: 80,
                      child: InteractiveExplainerNode(
                        index: 1, lockedIndex: _lockedIndex,
                        title: 'Hugging Face Inference',
                        description: 'Deploying custom fine-tuned visual transformers to locate pixel-level artifacting and noise models.',
                        icon: Icons.biotech_outlined, onTap: _onNodeTap,
                      ),
                    ),
                    // Node 2 — Gemini Multimodal
                    Positioned(
                      bottom: 10, right: 30,
                      child: InteractiveExplainerNode(
                        index: 2, lockedIndex: _lockedIndex,
                        title: 'Gemini Multimodal',
                        description: 'Advanced LLM reasoning engine that validates contextual semantics and verifies environment constraints.',
                        icon: Icons.auto_awesome, onTap: _onNodeTap,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AnimatedFlowLinePainter extends CustomPainter {
  final double phase; // 0.0 → 1.0 repeating
  _AnimatedFlowLinePainter({required this.phase});

  void _drawShiningPulse(Canvas canvas, Path path, Color color, double phaseOffset) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final totalLength = metric.length;

    // ── 1. Dim static base line ──────────────────────────────────────
    canvas.drawPath(path, Paint()
      ..color = color.withAlpha(35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);

    // ── 2. Position of the orb on the path (0..1 offset applied) ─────
    final double t = ((phase + phaseOffset) % 1.0);
    final double orbPos = t * totalLength;

    // ── 3. Comet tail — a lit segment behind the orb ──────────────────
    const double tailLength = 80.0;
    final double tailStart = (orbPos - tailLength).clamp(0.0, totalLength);
    if (tailStart < orbPos) {
      final tailPath = metric.extractPath(tailStart, orbPos);
      // Outer soft glow tail
      canvas.drawPath(tailPath, Paint()
        ..shader = null
        ..color = color.withAlpha(60)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      // Inner brighter tail
      canvas.drawPath(tailPath, Paint()
        ..color = color.withAlpha(120)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round);
    }

    // ── 4. The bright orb at the front ───────────────────────────────
    final tangent = metric.getTangentForOffset(orbPos);
    if (tangent == null) return;
    final orbCenter = tangent.position;

    // Outermost aura
    canvas.drawCircle(orbCenter, 12, Paint()
      ..color = color.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    // Mid glow
    canvas.drawCircle(orbCenter, 6, Paint()
      ..color = color.withAlpha(120)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    // Bright core
    canvas.drawCircle(orbCenter, 3, Paint()
      ..color = color
      ..style = PaintingStyle.fill);
    // White hot center
    canvas.drawCircle(orbCenter, 1.5, Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const nodeLeft = 32.0;
    const nodeTop  = 32.0;

    final path1 = Path();
    path1.moveTo(nodeLeft, size.height / 2);
    path1.quadraticBezierTo(
      size.width / 2, size.height / 2,
      size.width - 170, nodeTop,
    );

    final path2 = Path();
    path2.moveTo(nodeLeft, size.height / 2);
    path2.quadraticBezierTo(
      size.width / 2, size.height / 2,
      size.width - 120, size.height - 42,
    );

    // path1: cyan pulse, path2: purple pulse staggered by 0.5
    _drawShiningPulse(canvas, path1, _kPrimary,   0.0);
    _drawShiningPulse(canvas, path2, _kSecondary, 0.5);
  }

  @override
  bool shouldRepaint(covariant _AnimatedFlowLinePainter old) => old.phase != phase;
}


class InteractiveExplainerNode extends StatefulWidget {
  final int index;
  final int? lockedIndex;
  final String title;
  final String description;
  final IconData icon;
  final void Function(int) onTap;

  const InteractiveExplainerNode({
    super.key,
    required this.index,
    required this.lockedIndex,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<InteractiveExplainerNode> createState() => _InteractiveExplainerNodeState();
}

class _InteractiveExplainerNodeState extends State<InteractiveExplainerNode>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  bool get _isExpanded {
    // Show card if: this node is hovered OR locked
    if (widget.lockedIndex == widget.index) return true;
    if (_isHovered && widget.lockedIndex == null) return true;
    return false;
  }

  bool get _isLocked => widget.lockedIndex == widget.index;
  bool get _isDimmed => widget.lockedIndex != null && widget.lockedIndex != widget.index;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(covariant InteractiveExplainerNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isExpanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!_isLocked && widget.lockedIndex == null) _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!_isLocked) _animController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _isDimmed ? 0.35 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Main node circle / card ─────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutQuart,
                width: _isExpanded ? 300 : 64,
                height: _isExpanded ? 240 : 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 32),
                  color: _kSurface,
                  border: Border.all(
                    color: _isLocked
                        ? _kPrimary.withAlpha(180)
                        : _isHovered
                            ? _kPrimary.withAlpha(80)
                            : _kBorder,
                    width: _isLocked ? 1.5 : 1.0,
                  ),
                  boxShadow: _isExpanded
                      ? [
                          BoxShadow(
                            color: _kPrimary.withAlpha(_isLocked ? 60 : 30),
                            blurRadius: 30,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: _isExpanded
                        ? FadeTransition(
                            opacity: _fadeAnim,
                            child: ScaleTransition(
                              scale: _scaleAnim,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _kPrimary.withAlpha(20),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(widget.icon, color: _kPrimary, size: 18),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            widget.title,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (_isLocked)
                                          Icon(Icons.lock_outline, color: _kPrimary, size: 14)
                                        else
                                          Icon(Icons.visibility_outlined, color: _kZinc400, size: 14),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      widget.description,
                                      style: GoogleFonts.spaceGrotesk(
                                        color: _kZinc400,
                                        fontSize: 13,
                                        height: 1.55,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isHovered
                                  ? Icon(widget.icon, color: _kPrimary, size: 24, key: const ValueKey('icon'))
                                  : const Icon(Icons.add, color: Colors.white54, size: 22, key: ValueKey('plus')),
                            ),
                          ),
                  ),
                ),
              ),

              // ── Locked badge ────────────────────────────────────────────
              if (_isLocked)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _kPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _kPrimary.withAlpha(120), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.lock, color: Colors.black, size: 11),
                  ),
                ),

              // ── Pulsing ring on hover (collapsed state only) ────────────
              if (_isHovered && !_isExpanded)
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: 1.35),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, scale, _) => Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _kPrimary.withAlpha(60), width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// FEATURE GRIDS (Phase 3)
// ─────────────────────────────────────────────────────────────────────────────
class FeatureGridsSection extends StatelessWidget {
  final Offset mousePosition;
  const FeatureGridsSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final grid = _buildGrid();
    final whySection = _buildWhyNexus();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return Column(
            children: [
              whySection,
              const SizedBox(height: 60),
              grid,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: MouseParallax(mousePosition: mousePosition, depth: 0.0001, child: grid)),
            const SizedBox(width: 80),
            Expanded(flex: 2, child: MouseParallax(mousePosition: mousePosition, depth: -0.0001, child: whySection)),
          ],
        );
      }),
    );
  }

  Widget _buildGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(builder: (ctx, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              FeatureGridCard(title: 'Zero-Trust Firebase Auth', desc: 'Strict session verification and token-based telemetry logging.', icon: Icons.lock_outline, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Encrypted Payload Transfer', desc: 'Multi-part binary transport over SSL with dynamic signature generation.', icon: Icons.shield_outlined, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Sub-pixel AI Detection', desc: 'Fourier transform validation and facial boundary inconsistency checks.', icon: Icons.auto_awesome, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              FeatureGridCard(title: 'Stateless Processing', desc: 'Horizontal scaling of prediction servers maintaining zero persistent payload data.', icon: Icons.data_object, width: isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
            ],
          );
        })
      ],
    );
  }

  Widget _buildWhyNexus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHY NEXUS_GATEWAY?',
          style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
        ),
        const SizedBox(height: 16),
        Text(
          'Deepfake threats compromise enterprise integrity.',
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 24),
        Text(
          'Nexus leverages state-of-the-art anomaly resolution engines that are impossible to fool. With hybrid detection paradigms mapping spatial distortion alongside metadata falsification, your digital assets remain absolutely secure.',
          style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 48),
        _whyBanner('Real-time Processing'),
        const SizedBox(height: 16),
        _whyBanner('Cross-Platform UI'),
        const SizedBox(height: 16),
        _whyBanner('Google Cloud Native'),
      ],
    );
  }

  Widget _whyBanner(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: _kBlue, width: 3)),
        color: _kSurface,
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: _kBlue, size: 20),
          const SizedBox(width: 16),
          Text(text, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class FeatureGridCard extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;
  final double width;

  const FeatureGridCard({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
    required this.width,
  });

  @override
  State<FeatureGridCard> createState() => _FeatureGridCardState();
}

class _FeatureGridCardState extends State<FeatureGridCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _kBlue.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: _kBlue, size: 24),
                  ),
                  const SizedBox(height: 24),
                  Text(widget.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(widget.desc, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 14, height: 1.5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CROSS PLATFORM SHOWCASE (Phase 4)
// ─────────────────────────────────────────────────────────────────────────────
class CrossPlatformSection extends StatelessWidget {
  final Offset mousePosition;
  const CrossPlatformSection({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            padding: EdgeInsets.all(isDesktop ? 64 : 32),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: _kBorder),
              gradient: LinearGradient(
                colors: [_kSurface, Colors.white.withAlpha(40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return Column(
                  children: [
                    _buildTextContent(context),
                    const SizedBox(height: 60),
                    _buildMockups(),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: MouseParallax(mousePosition: mousePosition, depth: -0.00005, child: _buildTextContent(context))),
                  const SizedBox(width: 60),
                  Expanded(child: MouseParallax(mousePosition: mousePosition, depth: 0.0002, child: _buildMockups())),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withAlpha(10), borderRadius: BorderRadius.circular(6)),
          child: Text('NATIVE PERFORMANCE', style: GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        const SizedBox(height: 24),
        Text('Deploy everywhere from a single codebase.', style: GoogleFonts.outfit(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1.1)),
        const SizedBox(height: 24),
        Text('Built entirely in Flutter, Nexus Gateway compiles to a lightning-fast Web WebAssembly client and a native Android APK flawlessly.', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 18, height: 1.5)),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _storeButton(
              icon: Icons.language, 
              label: 'Launch Web Client', 
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            _storeButton(
              icon: Icons.android, 
              label: 'Download Android APK', 
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting to build server... APK download will start shortly.'),
                    backgroundColor: Color(0xFF8B5CF6), // Purple
                    duration: Duration(seconds: 3),
                  ),
                );
                // Placeholder external link to simulate download/github release
                final uri = Uri.parse('https://github.com/');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _storeButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return AnimatedScaleHoverWrapper(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _kBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockups() {
    return LayoutBuilder(builder: (context, constraints) {
      final scale = (constraints.maxWidth / 500).clamp(0.5, 1.0);
      return SizedBox(
        height: 400 * scale,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  width: 300 * scale,
                  height: 200 * scale,
                  decoration: BoxDecoration(
                    color: _kBg,
                    borderRadius: BorderRadius.circular(16 * scale),
                    border: Border.all(color: _kBlue.withAlpha(50), width: 2),
                    boxShadow: [BoxShadow(color: _kBlue.withAlpha(20), blurRadius: 40 * scale)],
                  ),
                  child: Center(child: Icon(Icons.web, color: _kBlue, size: 48 * scale)),
                ),
              ),
            ),
            Positioned(
              left: 20 * scale,
              top: 20 * scale,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: 160 * scale,
                  height: 320 * scale,
                  decoration: BoxDecoration(
                    color: _kSurface,
                    borderRadius: BorderRadius.circular(24 * scale),
                    border: Border.all(color: _kPurple.withAlpha(50), width: 2),
                    boxShadow: [BoxShadow(color: _kPurple.withAlpha(20), blurRadius: 40 * scale)],
                  ),
                  child: Center(child: Icon(Icons.smartphone, color: _kPurple, size: 48 * scale)),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FOOTER
// ─────────────────────────────────────────────────────────────────────────────
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 16,
        spacing: 16,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
              const SizedBox(width: 10),
              Text('© 2026 Nexus Gateway', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
            ],
          ),
          if (MediaQuery.of(context).size.width > 600)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Terms of Service', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
                const SizedBox(width: 24),
                Text('Privacy Policy', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.public, color: _kZinc400, size: 20),
              const SizedBox(width: 16),
              Icon(Icons.code, color: _kZinc400, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// THREE-COLUMN FEATURE STRIP (Phase 3)
// ─────────────────────────────────────────────────────────────────────────────

class ThreeColumnFeatureStrip extends StatelessWidget {
  final Offset mousePosition;
  const ThreeColumnFeatureStrip({super.key, required this.mousePosition});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final features = [
      _FeatureItem(
        icon: Icons.radar,
        title: 'Multimodal Analysis',
        desc: 'Simultaneous scanning of spatial anomalies and frequency artifacts across both audio and visual domains using synchronized transformer models.',
      ),
      _FeatureItem(
        icon: Icons.lock_outline,
        title: 'Zero-Trust Pipeline',
        desc: 'End-to-end payload encryption combined with strict Firebase authentication, ensuring your forensic data remains totally sandboxed.',
      ),
      _FeatureItem(
        icon: Icons.bolt,
        title: 'Sub-Second Latency',
        desc: 'Highly optimized inference routing on L40S accelerators ensures that you receive verifiable threat intelligence in real-time.',
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: Column(
        children: [
          Text(
            'WHY CHOOSE NEXUS?',
            style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Text(
            'Built for zero-tolerance environments',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width < 600) {
              return Column(
                children: features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildFeatureCol(f),
                )).toList(),
              );
            } else if (width < 1000) {
              return Wrap(
                spacing: 24,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: features.map((f) => SizedBox(
                  width: (width - 48) / 2,
                  child: _buildFeatureCol(f),
                )).toList(),
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.asMap().entries.map((e) {
                  final index = e.key;
                  final f = e.value;
                  final depth = index == 0 ? 0.0001 : (index == 1 ? 0.0002 : 0.0001);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MouseParallax(mousePosition: mousePosition, depth: depth, child: _buildFeatureCol(f)),
                    ),
                  );
                }).toList(),
              );
            }
          }),
          const SizedBox(height: 48),
          _PulsingCTAButton(
            label: 'SIGN UP NOW — FREE',
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCol(_FeatureItem f) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _kBlue.withAlpha(15),
            shape: BoxShape.circle,
            border: Border.all(color: _kBlue.withAlpha(40)),
          ),
          child: Icon(f.icon, color: _kBlue, size: 28),
        ),
        const SizedBox(height: 20),
        Text(
          f.title,
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          f.desc,
          style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 15, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureItem({required this.icon, required this.title, required this.desc});
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTIMONIALS CAROUSEL (Phase 3 — horizontal scroll + arrow controls)
// ─────────────────────────────────────────────────────────────────────────────
class TestimonialsCarousel extends StatefulWidget {
  final Offset mousePosition;
  const TestimonialsCarousel({super.key, required this.mousePosition});

  @override
  State<TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<TestimonialsCarousel> {
  final ScrollController _scrollCtrl = ScrollController();

  void _scrollBy(double offset) {
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset + offset).clamp(0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final testimonials = [
      _Testimonial(name: 'Sarah Chen', role: 'CISO, QuantumVault Inc.', quote: 'NEXUS_GATEWAY detected a deepfake board presentation that bypassed our existing tools. Game-changing threat intelligence.'),
      _Testimonial(name: 'Marcus Webb', role: 'Head of Security, DataForge', quote: 'The Gemini multimodal analysis gave us forensic-grade verdicts instantly. Our incident response time dropped by 80%.'),
      _Testimonial(name: 'Elena Volkov', role: 'VP Engineering, CyberShield', quote: 'We deployed NEXUS across web and mobile in a single sprint. The Flutter architecture is a force multiplier.'),
      _Testimonial(name: 'Raj Patel', role: 'AI Research Lead, NeuralTrust', quote: 'The Hugging Face pipeline catches sub-pixel artifacts that even our in-house models miss. Next-generation detection.'),
      _Testimonial(name: 'Priya Sharma', role: 'CTO, SecureMedia Global', quote: 'Zero-trust authentication combined with real-time AI scanning. NEXUS is the gold standard for media verification.'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRUSTED BY LEADERS', style: GoogleFonts.spaceGrotesk(color: _kBlue, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontSize: 13)),
                    const SizedBox(height: 12),
                    Text('They trust NEXUS_GATEWAY', style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1)),
                  ],
                ),
              ),
              Row(
                children: [
                  _arrowButton(Icons.arrow_back_ios_new, () => _scrollBy(-340)),
                  const SizedBox(width: 12),
                  _arrowButton(Icons.arrow_forward_ios, () => _scrollBy(340)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          MouseParallax(
            mousePosition: widget.mousePosition,
            depth: -0.0001,
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                controller: _scrollCtrl,
                scrollDirection: Axis.horizontal,
                itemCount: testimonials.length,
                itemBuilder: (ctx, i) {
                  final t = testimonials[i];
                  return Container(
                    width: 320,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _kSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _kBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote, color: _kBlue.withAlpha(80), size: 28),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(t.quote, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 14, height: 1.5)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _kBlue.withAlpha(25),
                                border: Border.all(color: _kBlue.withAlpha(60)),
                              ),
                              child: Center(
                                child: Text(
                                  t.name.split(' ').map((w) => w[0]).take(2).join(),
                                  style: GoogleFonts.outfit(color: _kBlue, fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(t.role, style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _kSurface,
          shape: BoxShape.circle,
          border: Border.all(color: _kBorder),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _Testimonial {
  final String name;
  final String role;
  final String quote;
  const _Testimonial({required this.name, required this.role, required this.quote});
}

class AnimatedScaleHoverWrapper extends StatefulWidget {
  final Widget child;
  const AnimatedScaleHoverWrapper({super.key, required this.child});

  @override
  State<AnimatedScaleHoverWrapper> createState() => _AnimatedScaleHoverWrapperState();
}

class _AnimatedScaleHoverWrapperState extends State<AnimatedScaleHoverWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PULSING CTA BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PulsingCTAButton({required this.label, required this.onTap});

  @override
  State<_PulsingCTAButton> createState() => _PulsingCTAButtonState();
}

class _PulsingCTAButtonState extends State<_PulsingCTAButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: false);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Repeating pulse ring ────────────────────────────────────
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, _) {
                  final scale = 1.0 + _pulseAnim.value * 0.5;
                  final opacity = (1.0 - _pulseAnim.value).clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 300,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _kPrimary.withAlpha((opacity * 100).toInt()),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── The main button ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBlue.withAlpha(80)),
                  boxShadow: [
                    BoxShadow(
                      color: _kBlue.withAlpha(_isHovered ? 80 : 40),
                      blurRadius: _isHovered ? 50 : 30,
                      spreadRadius: _isHovered ? 4 : 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.label,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _InteractiveElement extends StatefulWidget {
  final Widget child;
  const _InteractiveElement({required this.child});

  @override
  State<_InteractiveElement> createState() => _InteractiveElementState();
}

class _InteractiveElementState extends State<_InteractiveElement> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(_hovered ? 15.0 : 0.0, 0.0, 0.0), // Hover offset
        child: widget.child,
      ),
    );
  }
}
