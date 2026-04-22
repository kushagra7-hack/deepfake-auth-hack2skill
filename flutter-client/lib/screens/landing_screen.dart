import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Design Tokens ---
const _kBg = Color(0xFF050505);
const _kPrimary = Color(0xFF00F0FF);
const _kSecondary = Color(0xFF8B5CF6);
const _kSurface = Color(0x08FFFFFF); // 3% white
const _kBorder = Color(0x14FFFFFF);  // 8% white

// Legacy mappings for backwards compatibility
const _kBlue = _kPrimary;
const _kPurple = _kSecondary;
const _kZinc400 = Color(0xFFA1A1AA);

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kBlue.withAlpha(20),
                boxShadow: [
                  BoxShadow(color: _kBlue.withAlpha(20), blurRadius: 150, spreadRadius: 150)
                ],
              ),
            ),
          ),
          Positioned(
            top: 400,
            right: -300,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kPurple.withAlpha(15), 
                boxShadow: [
                  BoxShadow(color: _kPurple.withAlpha(15), blurRadius: 200, spreadRadius: 200)
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const HeroSection(),
                    const SizedBox(height: 120),
                    InteractiveExplainerSection(key: _howItWorksKey),
                    const SizedBox(height: 120),
                    FeatureGridsSection(key: _productKey),
                    const SizedBox(height: 120),
                    const ThreeColumnFeatureStrip(),
                    const SizedBox(height: 120),
                    const TestimonialsCarousel(),
                    const SizedBox(height: 120),
                    CrossPlatformSection(key: _architectureKey),
                    const SizedBox(height: 80),
                    FooterSection(key: _contactKey),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                      gradient: const LinearGradient(
                        colors: [_kBlue, Color(0xFF1D4ED8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: _kBlue.withAlpha(80), blurRadius: 20, spreadRadius: -2)],
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'NEXUS_GATEWAY',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: isDesktop ? 18 : 14,
                      letterSpacing: isDesktop ? 2.0 : 1.0,
                    ),
                  ),
                  const Spacer(),
                  if (isDesktop) ...[
                    _navLink('Product', _productKey),
                    const SizedBox(width: 20),
                    _navLink('Architecture', _architectureKey),
                    const SizedBox(width: 20),
                    _navLink('How it works', _howItWorksKey),
                    const SizedBox(width: 20),
                    _navLink('API Docs', null),
                    const SizedBox(width: 20),
                    _navLink('Contact', _contactKey),
                    const SizedBox(width: 32),
                  ],
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: _kBlue.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _kBlue.withAlpha(100)),
                          boxShadow: [BoxShadow(color: _kBlue.withAlpha(40), blurRadius: 20)],
                        ),
                        child: Text(
                          isDesktop ? 'Deploy Now' : 'Login',
                          style: GoogleFonts.outfit(color: _kBlue, fontWeight: FontWeight.bold, fontSize: isDesktop ? 14 : 12, letterSpacing: 1.0),
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
  const _HoverNavLink({required this.title, this.globalKey});
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
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    final leftContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Super title
        Container(
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
        const SizedBox(height: 32),
        // Heading
        RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(
              fontSize: isDesktop ? 64 : 48,
              height: 1.2,
              letterSpacing: -1.5,
            ),
            children: const [
              TextSpan(
                text: 'NEXUS_GATEWAY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: ' —\nThe zero-trust\ndeepfake authentication\ngateway.',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Subtitle
        Text(
          'Upload media, analyze pixel-level anomalies via\nHugging Face, and verify context with Gemini AI.',
          style: GoogleFonts.inter(
            color: Colors.white60,
            fontSize: isDesktop ? 16 : 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        // CTA
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_kBlue, _kPurple]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: _kBlue.withAlpha(60), blurRadius: 40, offset: const Offset(0, 10))
                ],
              ),
              child: Text(
                'ENTER DASHBOARD',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final rightContent = SizedBox(
      width: isDesktop ? 500 : double.infinity,
      height: 500,
      child: const Center(child: _FloatingHologram()),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 100 : 60),
      child: isDesktop 
          ? Row(
              children: [
                Expanded(child: leftContent),
                const SizedBox(width: 40),
                rightContent,
              ],
            )
          : Column(
              children: [
                leftContent,
                const SizedBox(height: 60),
                rightContent,
              ],
            ),
    );
  }
}

class _FloatingHologram extends StatefulWidget {
  const _FloatingHologram();

  @override
  State<_FloatingHologram> createState() => _FloatingHologramState();
}

class _FloatingHologramState extends State<_FloatingHologram> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -15.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _kPrimary.withAlpha(200),
                  _kSecondary.withAlpha(100),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: _kPrimary.withAlpha(80),
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// INTERACTIVE EXPLAINER (Phase 2)
// ─────────────────────────────────────────────────────────────────────────────
class InteractiveExplainerSection extends StatelessWidget {
  const InteractiveExplainerSection({super.key});

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
          const SizedBox(height: 80),
          
          // Canvas area
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Connective dashed lines
                Positioned.fill(
                  child: CustomPaint(painter: _DashedLinePainter()),
                ),
                
                // Nodes
                const Positioned(
                  left: 0,
                  child: InteractiveExplainerNode(
                    title: 'FastAPI Backend',
                    description: 'Stateless asynchronous microservices handling high-throughput payload ingestion and routing securely.',
                    icon: Icons.api_rounded,
                  ),
                ),
                const Positioned(
                  top: 0,
                  right: 100,
                  child: InteractiveExplainerNode(
                    title: 'Hugging Face Inference',
                    description: 'Deploying custom fine-tuned visual transformers to locate pixel-level artifacting and noise models.',
                    icon: Icons.biotech_outlined,
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  right: 50,
                  child: InteractiveExplainerNode(
                    title: 'Gemini Multimodal',
                    description: 'Advanced LLM reasoning engine that validates contextual semantics and verifies environment constraints.',
                    icon: Icons.auto_awesome,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kBorder
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Draw some stylized paths. 
    // Just a placeholder drawing a few curves connecting areas
    final path = Path();
    path.moveTo(100, size.height / 2);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width - 200, 50);
    
    final path2 = Path();
    path2.moveTo(100, size.height / 2);
    path2.quadraticBezierTo(size.width / 2, size.height / 2, size.width - 150, size.height - 50);

    // (In a real app, use path_drawing package or draw manually over metrics)
    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InteractiveExplainerNode extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const InteractiveExplainerNode({
    super.key, 
    required this.title, 
    required this.description, 
    required this.icon
  });

  @override
  State<InteractiveExplainerNode> createState() => _InteractiveExplainerNodeState();
}

class _InteractiveExplainerNodeState extends State<InteractiveExplainerNode> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuart,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_expanded ? 16 : 32),
          boxShadow: _expanded
              ? [BoxShadow(color: _kPrimary.withAlpha(20), blurRadius: 40)]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_expanded ? 16 : 32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
              width: _expanded ? 320 : 64,
              height: _expanded ? 180 : 64,
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(_expanded ? 16 : 32),
                border: Border.all(
                  color: _expanded ? _kPrimary.withAlpha(100) : _kBorder,
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: _expanded
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(widget.icon, color: _kPrimary, size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.remove, color: _kZinc400, size: 20),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.description,
                              style: GoogleFonts.spaceGrotesk(
                                color: _kZinc400,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 24),
                      ),
              ),
            ),
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
  const FeatureGridsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final grid = _buildGrid();
    final whySection = _buildWhyNexus();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: grid),
                const SizedBox(width: 80),
                Expanded(flex: 2, child: whySection),
              ],
            )
          : Column(
              children: [
                whySection,
                const SizedBox(height: 60),
                grid,
              ],
            ),
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
              _gridCard('Zero-Trust Firebase Auth', 'Strict session verification and token-based telemetry logging.', Icons.lock_outline, isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              _gridCard('Encrypted Payload Transfer', 'Multi-part binary transport over SSL with dynamic signature generation.', Icons.shield_outlined, isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              _gridCard('Sub-pixel AI Detection', 'Fourier transform validation and facial boundary inconsistency checks.', Icons.auto_awesome, isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
              _gridCard('Stateless Processing', 'Horizontal scaling of prediction servers maintaining zero persistent payload data.', Icons.data_object, isMobile ? constraints.maxWidth : constraints.maxWidth / 2 - 12),
            ],
          );
        })
      ],
    );
  }

  Widget _gridCard(String title, String desc, IconData icon, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          width: width,
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
                child: Icon(icon, color: _kBlue, size: 24),
              ),
              const SizedBox(height: 24),
              Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(desc, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 14, height: 1.5)),
            ],
          ),
        ),
      ),
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

// ─────────────────────────────────────────────────────────────────────────────
// CROSS PLATFORM SHOWCASE (Phase 4)
// ─────────────────────────────────────────────────────────────────────────────
class CrossPlatformSection extends StatelessWidget {
  const CrossPlatformSection({super.key});

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
                colors: [_kSurface, _kPrimary.withAlpha(20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            ),
            child: isDesktop 
                ? Row(
                    children: [
                      Expanded(child: _buildTextContent()),
                      const SizedBox(width: 60),
                      Expanded(child: _buildMockups()),
                    ],
                  )
                : Column(
                    children: [
                      _buildTextContent(),
                      const SizedBox(height: 60),
                      _buildMockups(),
                    ],
                  )
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
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
            _storeButton(Icons.language, 'Launch Web Client'),
            _storeButton(Icons.android, 'Download Android APK'),
          ],
        )
      ],
    );
  }

  Widget _storeButton(IconData icon, String label) {
    return Container(
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
    );
  }

  Widget _buildMockups() {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBlue.withAlpha(50), width: 2),
                  boxShadow: [BoxShadow(color: _kBlue.withAlpha(20), blurRadius: 40)],
                ),
                child: const Center(child: Icon(Icons.web, color: _kBlue, size: 48)),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 160,
                height: 320,
                decoration: BoxDecoration(
                  color: _kSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _kPurple.withAlpha(50), width: 2),
                  boxShadow: [BoxShadow(color: _kPurple.withAlpha(20), blurRadius: 40)],
                ),
                child: const Center(child: Icon(Icons.smartphone, color: _kPurple, size: 48)),
              ),
            ),
          ),
        ],
      ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
              const SizedBox(width: 10),
              Text('© 2026 Nexus Gateway', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
            ],
          ),
          if (MediaQuery.of(context).size.width > 600)
            Row(
              children: [
                Text('Terms of Service', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
                const SizedBox(width: 24),
                Text('Privacy Policy', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13)),
              ],
            ),
          Row(
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
  const ThreeColumnFeatureStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final features = [
      _FeatureItem(
        icon: Icons.verified_user_outlined,
        title: 'Reliable Protection',
        desc: 'Enterprise-grade AI inference pipelines that never miss a manipulated payload, backed by multi-model consensus.',
      ),
      _FeatureItem(
        icon: Icons.rocket_launch_outlined,
        title: 'Easy to Set Up',
        desc: 'One-click deployment with Firebase integration. Upload, scan, verify — operational in under 60 seconds.',
      ),
      _FeatureItem(
        icon: Icons.shield_outlined,
        title: 'Virus Protection',
        desc: 'All ingested media is sandboxed and scanned for embedded malware before AI analysis begins.',
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
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: features.map((f) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildFeatureCol(f),
                    ),
                  )).toList(),
                )
              : Column(
                  children: features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _buildFeatureCol(f),
                  )).toList(),
                ),
          const SizedBox(height: 48),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_kBlue, _kPurple]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: _kBlue.withAlpha(50), blurRadius: 30, offset: const Offset(0, 8)),
                  ],
                ),
                child: Text(
                  'SIGN UP NOW',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1.5),
                ),
              ),
            ),
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
  const TestimonialsCarousel({super.key});

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
          SizedBox(
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
