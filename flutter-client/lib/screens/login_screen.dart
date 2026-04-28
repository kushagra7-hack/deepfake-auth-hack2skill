import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../main.dart'; // For HoverGlowText
import 'dart:async';

// ── Color tokens — Obsidian & Holographic Glass ─────────────────────────────
const _kBg         = Color(0xFF000000);  // Pure Black
const _kBgDeep     = Color(0xFF000000);  // Pure Black
const _kPrimary    = Color(0xFFFFFFFF);  // White
const _kSecondary  = Color(0xFFFFFFFF);  // White
const _kSurface    = Color(0x1AFFFFFF);  // 10% white
const _kBorderCol  = Color(0x33FFFFFF);  // 20% white
const _kNeutral400 = Color(0xFFA1A1AA);
const _kNeutral500 = Color(0xFF71717A);
const _kRed        = Color(0xFFFFFFFF);  // Use White for errors too (or White with opacity)
const _kRose       = Color(0xFFFFFFFF);
const trustAccent  = Color(0xFF4F46E5); // Deep Indigo
// Legacy aliases
const _kBlack      = _kBg;
const _kBlue       = _kPrimary;
const _kBlueDark   = _kSecondary;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController(); // for register mode
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _isRegisterMode = false; // toggles between login / create account
  bool _isPrimaryHovered = false;
  bool _isGoogleHovered = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.white70, size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: _kRed.withAlpha(200),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found for that email address.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  // ── Auth Actions ─────────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting login...');
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      debugPrint('AUTH LOG: Success');
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting register...');
    try {
      await _authService.registerWithEmailAndPassword(email, password);
      debugPrint('AUTH LOG: Success');
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('Registration failed. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    debugPrint('AUTH LOG: Attempting Google sign-in...');
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        debugPrint('AUTH LOG: Google sign-in success');
        if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        debugPrint('AUTH LOG: User cancelled sign-in');
      }
      // On success, AuthWrapper reacts to the auth state change automatically
    } on FirebaseAuthException catch (e) {
      _showError(_friendlyError(e));
      debugPrint('AUTH LOG Error: ${e.message}');
    } on TimeoutException catch (e) {
      _showError('Connection timed out. Please check your network.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } on FirebaseException catch (e) {
      _showError(e.message ?? 'A Firebase error occurred.');
      debugPrint('AUTH LOG Error: ${e.message}');
    } catch (e) {
      _showError('Google sign-in failed. Please try again.');
      debugPrint('AUTH LOG Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: _kBg,
      body: Stack(
        children: [
          // ── Radial gradient background ──────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [_kBgDeep, _kBg],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // ── Ambient violet glow (top-left) ──────────────────────────────
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kSecondary.withAlpha(30),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          // ── Ambient cyan glow (bottom-right) ────────────────────────────
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kPrimary.withAlpha(20),
                    blurRadius: 200,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          // ── Main layout ─────────────────────────────────────────────────
          isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ],
      ),
    );
  }

  // ── Wide layout: 45% form + 55% image (React parity) ─────────────────────────
  Widget _buildWideLayout() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: SingleChildScrollView(child: _buildFormSection()),
        ),
        Expanded(child: _buildImageSection()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(child: _buildFormSection());
  }

  // ── Left: Form Section ─────────────────────────────────────────────────────
  Widget _buildFormSection() {
    final width = MediaQuery.of(context).size.width;
    final hPad = width < 480 ? 24.0 : 56.0;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            border: Border(
              right: BorderSide(color: _kBorderCol),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo row
                  LayoutBuilder(builder: (context, logoConstraints) {
                    return Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_kPrimary, _kSecondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: _kPrimary.withAlpha(50),
                                  blurRadius: 16,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: const Icon(Icons.verified_user_outlined,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: width < 360 ? 16 : 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'NEXUS'),
                                TextSpan(
                                    text: '_',
                                    style: const TextStyle(color: _kPrimary)),
                                const TextSpan(text: 'GATEWAY'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 52),

                  // Headline
                  HoverGlowText(
                    _isRegisterMode
                        ? 'Begin your\njourney.'
                        : 'REALITY IS DATA.',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: width < 360 ? 28 : 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  HoverGlowText(
                    _isRegisterMode
                        ? 'Create an account to access our suite of advanced security tools and analytics.'
                        : 'TRUST IS EARNED. WE VERIFY BOTH.',
                    style: GoogleFonts.spaceGrotesk(
                      color: _kNeutral400,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Full name field (register only)
                  if (_isRegisterMode) ...[
                    _buildLabel('FULL NAME'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _nameCtrl,
                      hint: 'John Doe',
                      obscure: false,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Email
                  _buildLabel('EMAIL ADDRESS'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _emailCtrl,
                    hint: 'operator@nexus.io',
                    obscure: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  _buildLabel('PASSWORD'),
                  const SizedBox(height: 6),
                  _buildPasswordField(),

                  // Forgot link (login only)
                  if (!_isRegisterMode) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Recover authorization code',
                          style: GoogleFonts.spaceGrotesk(
                            color: _kPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // Primary CTA button
                  _buildPrimaryButton(),
                  const SizedBox(height: 28),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: 20),

                  // Google button
                  _buildGoogleButton(),
                  const SizedBox(height: 28),

                  // Toggle login ↔ register
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode
                            ? 'Already have an account? '
                            : 'Unregistered operator? ',
                        style: GoogleFonts.spaceGrotesk(
                            color: _kNeutral500, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _isRegisterMode = !_isRegisterMode;
                          _emailCtrl.clear();
                          _passwordCtrl.clear();
                          _nameCtrl.clear();
                        }),
                        child: Text(
                          _isRegisterMode ? 'Sign In' : 'Request Access',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withAlpha(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Right: Image Section ───────────────────────────────────────────────────
  Widget _buildImageSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background — deep neutral
        Container(color: const Color(0xFF111111)),

        // Network/circuit image via NetworkImage (matches React unsplash URL)
        Image.asset(
          'assets/images/login_bg.jpg',
          fit: BoxFit.cover,
          color: Colors.black.withAlpha(130),
          colorBlendMode: BlendMode.darken,
          errorBuilder: (context, error, stack) => const SizedBox.shrink(),
        ),

        // Left fade gradient (matches React `from-black via-black/80 to-transparent`)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 160,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_kBlack, _kBlack.withAlpha(200), Colors.transparent],
              ),
            ),
          ),
        ),

        // Top + bottom fade
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kBlack.withAlpha(150),
                Colors.transparent,
                _kBlack.withAlpha(150),
              ],
            ),
          ),
        ),

        // Floating glass card (bottom-right area, matching React decorative panel)
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.22,
          right: 80,
          child: Transform(
            transform: Matrix4.rotationZ(-0.035),
            child: _buildGlassCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard() {
    return Container(
      width: 272,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 30,
              spreadRadius: 2),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _kRose.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security_outlined,
                color: _kRose.withAlpha(200), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deepfake Vector Scans',
                    style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text('Status: Active Monitoring',
                    style: GoogleFonts.spaceGrotesk(
                      color: _kRose,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Form Widget Builders ───────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        color: _kNeutral500,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      cursorColor: _kBlue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.spaceGrotesk(color: Colors.white.withAlpha(35), fontSize: 14),
        filled: true,
        fillColor: _kSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorderCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(77), width: 1),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordCtrl,
      obscureText: !_showPassword,
      style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      cursorColor: _kBlue,
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle:
            GoogleFonts.spaceGrotesk(color: Colors.white.withAlpha(35), fontSize: 14),
        filled: true,
        fillColor: _kSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBorderCol),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withAlpha(77), width: 1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _kNeutral500,
            size: 20,
          ),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isPrimaryHovered = true),
      onExit: (_) => setState(() => _isPrimaryHovered = false),
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        height: 56,
        child: GestureDetector(
          onTap: _isLoading
              ? null
              : (_isRegisterMode ? _handleRegister : _handleLogin),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isPrimaryHovered ? trustAccent.withOpacity(0.1) : _kBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: trustAccent.withOpacity(0.8), width: 1),
              boxShadow: _isLoading
                  ? null
                  : [
                      BoxShadow(
                        color: trustAccent.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
            ),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode ? 'Create Account' : 'Initiate Handshake',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward,
                          size: 17, color: Colors.white),
                    ],
                  ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child:
                Divider(color: Colors.white.withAlpha(25), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            _isRegisterMode ? 'OR CONTINUE WITH' : 'OR AUTHENTICATE VIA',
            style: GoogleFonts.spaceGrotesk(
              color: _kNeutral500,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
            child:
                Divider(color: Colors.white.withAlpha(25), thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isGoogleHovered = true),
      onExit: (_) => setState(() => _isGoogleHovered = false),
      child: SizedBox(
        height: 56,
        child: OutlinedButton(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          style: OutlinedButton.styleFrom(
            backgroundColor: _kSurface,
            foregroundColor: Colors.white,
            side: BorderSide(color: _isGoogleHovered ? trustAccent.withOpacity(0.4) : _kBorderCol),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: _kNeutral400, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google 'G' logo — exact 4-path SVG coloured paths
                  _GoogleLogo(size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Google',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

// ── Google Logo (4-colour SVG paths, matches React) ───────────────────────────
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final blue = Paint()..color = Colors.white;
    final green = Paint()..color = Colors.white70;
    final yellow = Paint()..color = Colors.white60;
    final red = Paint()..color = Colors.white54;

    // Scale factor: React SVG viewBox is 24x24
    final scale = s / 24;
    canvas.scale(scale, scale);

    // Blue path (top-right)
    final pBlue = Path()
      ..moveTo(22.56, 12.25)
      ..cubicTo(22.56, 11.47, 22.49, 10.72, 22.36, 10.0)
      ..lineTo(12, 10.0)
      ..lineTo(12, 14.26)
      ..lineTo(17.92, 14.26)
      ..cubicTo(17.66, 15.63, 16.88, 16.79, 15.71, 17.57)
      ..lineTo(15.71, 20.34)
      ..lineTo(19.28, 20.34)
      ..cubicTo(21.36, 18.42, 22.56, 15.6, 22.56, 12.25)
      ..close();
    canvas.drawPath(pBlue, blue);

    // Green path (bottom)
    final pGreen = Path()
      ..moveTo(12, 23)
      ..cubicTo(14.97, 23, 17.46, 22.02, 19.28, 20.34)
      ..lineTo(15.71, 17.57)
      ..cubicTo(14.73, 18.23, 13.48, 18.63, 12, 18.63)
      ..cubicTo(9.14, 18.63, 6.71, 16.7, 5.84, 14.1)
      ..lineTo(2.18, 14.1)
      ..lineTo(2.18, 16.94)
      ..cubicTo(3.99, 20.53, 7.7, 23, 12, 23)
      ..close();
    canvas.drawPath(pGreen, green);

    // Yellow path (left)
    final pYellow = Path()
      ..moveTo(5.84, 14.09)
      ..cubicTo(5.62, 13.43, 5.49, 12.73, 5.49, 12)
      ..cubicTo(5.49, 11.27, 5.62, 10.57, 5.84, 9.91)
      ..lineTo(5.84, 7.07)
      ..lineTo(2.18, 7.07)
      ..cubicTo(1.43, 8.55, 1, 10.22, 1, 12)
      ..cubicTo(1, 13.78, 1.43, 15.45, 2.18, 16.93)
      ..lineTo(5.84, 14.09)
      ..close();
    canvas.drawPath(pYellow, yellow);

    // Red path (top-left)
    final pRed = Path()
      ..moveTo(12, 5.38)
      ..cubicTo(13.62, 5.38, 15.06, 5.94, 16.21, 7.02)
      ..lineTo(19.36, 3.87)
      ..cubicTo(17.45, 2.09, 14.97, 1, 12, 1)
      ..cubicTo(7.7, 1, 3.99, 3.47, 2.18, 7.07)
      ..lineTo(5.84, 9.91)
      ..cubicTo(6.71, 7.31, 9.14, 5.38, 12, 5.38)
      ..close();
    canvas.drawPath(pRed, red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
