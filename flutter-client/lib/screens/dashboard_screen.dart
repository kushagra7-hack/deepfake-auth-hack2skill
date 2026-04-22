import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

// ── Color Palette ─────────────────────────────────────────────────────────────
const _kBg = Color(0xFF0B0B0F);
const _kCardBg = Color(0xFF151520);
const _kBorder = Color(0xFF1E1C2E);
const _kBlue = Color(0xFF3B82F6);
const _kRose = Color(0xFFE11D48);
const _kAmber = Color(0xFFF59E0B);
const _kEmerald = Color(0xFF10B981);
const _kPurple = Color(0xFF9333EA);
const _kMagenta = Color(0xFFEC4899);
const _kCyan = Color(0xFF22D3EE);
const _kViolet = Color(0xFF8B5CF6);
const _kZinc400 = Color(0xFFA1A1AA);
const _kZinc500 = Color(0xFF71717A);
const _kZinc600 = Color(0xFF52525B);



// ── Dashboard Screen ──────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  // Nav tab state
  int _navIndex = 0;

  // Current user (from Firebase)
  String? _userEmail;

  // ── Scan state ───────────────────────────────────────────────────────────────
  bool _isUploading = false;
  String? _lastFileName;
  String? _errorMessage;
  double _threatScore = 0.0;
  String _geminiVerdict = 'AWAITING PAYLOAD';
  String? _geminiReasoning;
  String _ingestionMediaType = 'image';

  List<ScanResult> _scanHistory = [];

  int get _totalScans => _scanHistory.length;
  int get _aiGeneratedCount => _scanHistory.where((s) => s.threatScore >= 50.0 || s.geminiVerdict == 'DEEPFAKE').length;
  int get _verifiedSafeCount => _scanHistory.where((s) => s.threatScore < 50.0 && s.geminiVerdict == 'AUTHENTIC').length;
  double get _globalThreatIndex => _scanHistory.isEmpty ? 0 : (_scanHistory.fold(0.0, (sum, item) => sum + item.threatScore) / _totalScans);

  // ── Boot-up animation ─────────────────────────────────────────────────────
  late final AnimationController _bootCtrl;
  late final Animation<double>   _bgFade;
  late final Animation<Offset>   _navSlide;
  late final Animation<Offset>   _leftSlide;
  late final Animation<double>   _leftFade;
  late final Animation<Offset>   _rightSlide;
  late final Animation<double>   _rightFade;
  late final Animation<Offset>   _bottomSlide;
  late final Animation<double>   _bottomFade;

  @override
  void initState() {
    super.initState();
    _userEmail = FirebaseAuth.instance.currentUser?.email;

    _bootCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Background fades in instantly
    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut)),
    );

    // Nav: 0.0 → 0.3, drops down with spring
    _navSlide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack)),
    );

    // Left panel: 0.2 → 0.6, slides from left + fades up
    _leftSlide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack)),
    );
    _leftFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.2, 0.5, curve: Curves.easeOut)),
    );

    // Right panel: 0.4 → 0.8, slides from right + fades up
    _rightSlide = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack)),
    );
    _rightFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.4, 0.7, curve: Curves.easeOut)),
    );

    // Bottom log: 0.6 → 1.0, slides up from bottom
    _bottomSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack)),
    );
    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bootCtrl, curve: const Interval(0.6, 0.9, curve: Curves.easeOut)),
    );

    _bootCtrl.forward();
  }

  @override
  void dispose() {
    _bootCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'mp4', 'mov', 'avi', 'mp3', 'wav', 'm4a'],
        withData: true,
      );
      if (result == null) {
        setState(() => _isUploading = false);
        return;
      }
      final file = result.files.first;
      setState(() => _lastFileName = file.name);

      final scan = await _apiService.scanMedia(file);
      setState(() {
        _threatScore = scan.threatScore;
        _geminiVerdict = scan.geminiVerdict ?? 'NO VERDICT';
        _geminiReasoning = scan.geminiReasoning;
        _scanHistory.insert(0, scan);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan complete: ${scan.geminiVerdict ?? 'Done'}', style: GoogleFonts.spaceGrotesk(color: Colors.white)),
            backgroundColor: scan.geminiVerdict == 'DEEPFAKE' ? _kRose : _kEmerald,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!, style: GoogleFonts.spaceGrotesk(color: Colors.white)),
            backgroundColor: _kRose.withAlpha(220),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _handleLogout() => _authService.signOut();

  // ══════════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            // ── Layer 0: Pure obsidian base ──────────────────────────────────
            Container(color: const Color(0xFF050505)),

            // ── Layer 1: Ambient cyan orb — top left ─────────────────────────
            Positioned(
              top: -200, left: -200,
              child: Container(
                width: 600, height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withAlpha(38),
                      blurRadius: 250, spreadRadius: 80,
                    ),
                  ],
                ),
              ),
            ),

            // ── Layer 2: Ambient violet orb — bottom right ───────────────────
            Positioned(
              bottom: -150, right: -150,
              child: Container(
                width: 500, height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withAlpha(38),
                      blurRadius: 250, spreadRadius: 80,
                    ),
                  ],
                ),
              ),
            ),

            // ── Layer 3: Mid violet orb — center left ────────────────────────
            Positioned(
              top: 300, left: 100,
              child: Container(
                width: 350, height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withAlpha(18),
                      blurRadius: 200, spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),

            // ── Layer 4: Foreground dashboard UI ────────────────────────────
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Upload zone: springs in from left + fades
                    FadeTransition(
                      opacity: _leftFade,
                      child: SlideTransition(
                        position: _leftSlide,
                        child: _buildUploadZone(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Analysis log: slides up from bottom + fades
                    FadeTransition(
                      opacity: _bottomFade,
                      child: SlideTransition(
                        position: _bottomSlide,
                        child: _buildAnalysisLog(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Floating Nav: springs down from top ──────────────────────────
            Positioned(
              top: 12, left: 0, right: 0,
              child: SlideTransition(
                position: _navSlide,
                child: _buildFloatingNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // FLOATING NAV BAR (Dribbble capsule)
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildFloatingNavBar() {
    final navItems = [
      (Icons.dashboard_rounded, 'Dashboard'),
      (Icons.radar_rounded, 'Exposures'),
      (Icons.warning_amber_rounded, 'Threats'),
      (Icons.cloud_upload_rounded, 'Ingest'),
      (Icons.analytics_rounded, 'Analytics'),
    ];

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF18182B).withAlpha(220),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: _kBorder),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(120), blurRadius: 40, spreadRadius: -4),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kViolet, _kMagenta],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: _kViolet.withAlpha(80), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 6),

                // Nav Items
                ...List.generate(navItems.length, (i) {
                  final isActive = _navIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _navIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: EdgeInsets.symmetric(
                        horizontal: isActive ? 16 : 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(colors: [_kViolet, _kMagenta])
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isActive
                            ? [BoxShadow(color: _kMagenta.withAlpha(40), blurRadius: 16)]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            navItems[i].$1,
                            color: isActive ? Colors.white : _kZinc500,
                            size: 16,
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 6),
                            Text(
                              navItems[i].$2,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // User avatar + logout
                GestureDetector(
                  onTap: _handleLogout,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _kRose.withAlpha(30),
                      shape: BoxShape.circle,
                      border: Border.all(color: _kRose.withAlpha(60)),
                    ),
                    child: Tooltip(
                  message: _userEmail ?? 'Logout',
                  child: Icon(Icons.person_outline, color: _kRose.withAlpha(180), size: 18),
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

  // ══════════════════════════════════════════════════════════════════════════════
  // ROW 0: AGGREGATE STATS (Dynamic Logic)
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildTopStatCard(String title, String value, IconData icon, Color color) {
    return _DashCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color.withAlpha(200), size: 28),
              const SizedBox(height: 12),
              Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
            ]
          )
        )
      )
    );
  }

  Widget _buildTopStatCards() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 900;
      final cards = [
        _buildTopStatCard('TOTAL PAYLOADS', _totalScans.toString(), Icons.analytics_outlined, _kCyan),
        _buildTopStatCard('AI GENERATED', _aiGeneratedCount.toString(), Icons.warning_amber_rounded, Colors.orange),
        _buildTopStatCard('VERIFIED SAFE', _verifiedSafeCount.toString(), Icons.verified_user_outlined, _kEmerald),
        _buildTopStatCard('THREAT INDEX', '${_globalThreatIndex.toStringAsFixed(1)}%', Icons.public, _kRose),
      ];

      if (isWide) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Expanded(child: cards[0]), const SizedBox(width: 20),
              Expanded(child: cards[1]), const SizedBox(width: 20),
              Expanded(child: cards[2]), const SizedBox(width: 20),
              Expanded(child: cards[3]),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            Row(children: [Expanded(child: cards[0]), const SizedBox(width: 12), Expanded(child: cards[1])]),
            const SizedBox(height: 12),
            Row(children: [Expanded(child: cards[2]), const SizedBox(width: 12), Expanded(child: cards[3])]),
          ]
        );
      }
    });
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ROW 1: EXPOSURES CARD + ACCESS METRICS CARD
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildRow1() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 900;
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildExposuresCard()),
            const SizedBox(width: 20),
            Expanded(flex: 2, child: _buildAccessMetricsCard()),
          ],
        );
      }
      return Column(children: [
        _buildExposuresCard(),
        const SizedBox(height: 20),
        _buildAccessMetricsCard(),
      ]);
    });
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // CARD 1: EXPOSURES — Area Chart + Exposure Status Bars
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildExposuresCard() {
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Open and resolved exposures overtime',
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(children: [
                    _legendDot(_kMagenta, 'New'),
                    const SizedBox(width: 4),
                    Text('108', style: GoogleFonts.spaceGrotesk(color: _kMagenta, fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 16),
                    _legendDot(_kViolet, 'Resolved'),
                    const SizedBox(width: 4),
                    Text('86h', style: GoogleFonts.spaceGrotesk(color: _kViolet, fontSize: 12, fontWeight: FontWeight.w700)),
                  ]),
                ],
              ),
              const Spacer(),
              // Time range pills
              _buildTimePills(),
            ],
          ),
          const SizedBox(height: 20),

          // ── The Main Area Chart ──────────────────────────────────
          LayoutBuilder(builder: (ctx, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildExposureAreaChart()),
                  const SizedBox(width: 24),
                  SizedBox(width: 220, child: _buildExposureStatusBars()),
                ],
              );
            }
            return Column(children: [
              _buildExposureAreaChart(),
              const SizedBox(height: 20),
              _buildExposureStatusBars(),
            ]);
          }),
        ],
      ),
    );
  }

  Widget _buildTimePills() {
    final items = ['1h', '1d', '7d', '1m', '6m', '1y'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((t) {
        final isActive = t == '1y';
        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? _kViolet.withAlpha(30) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: isActive ? _kViolet.withAlpha(60) : _kBorder),
            ),
            child: Text(t,
                style: GoogleFonts.spaceGrotesk(
                    color: isActive ? _kViolet : _kZinc500, fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExposureAreaChart() {
    final rng = math.Random(42);
    final pinkSpots = List.generate(12, (i) => FlSpot(i.toDouble(), 20 + rng.nextDouble() * 60));
    final violetSpots = List.generate(12, (i) => FlSpot(i.toDouble(), 10 + rng.nextDouble() * 50));

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withAlpha(6), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (val, _) => Text(
                  val.toInt().toString(),
                  style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 10),
                ),
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  final idx = val.toInt();
                  if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
                  return Text(months[idx], style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 9));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: pinkSpots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: _kMagenta,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_kMagenta.withAlpha(80), _kMagenta.withAlpha(0)],
                ),
              ),
            ),
            LineChartBarData(
              spots: violetSpots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: _kViolet,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_kViolet.withAlpha(50), _kViolet.withAlpha(0)],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => _kCardBg,
              tooltipBorder: const BorderSide(color: _kBorder),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExposureStatusBars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exposures status', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Row(children: [
          _legendDot(_kMagenta, 'Active'),
          const SizedBox(width: 12),
          _legendDot(_kViolet, 'Inactive'),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (val, _) {
                      const labs = ['M', 'T', 'W', 'T', 'F', 'S'];
                      final idx = val.toInt();
                      if (idx < 0 || idx >= labs.length) return const SizedBox.shrink();
                      return Text(labs[idx], style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 9));
                    },
                  ),
                ),
              ),
              barGroups: List.generate(6, (i) {
                final rng = math.Random(i * 7);
                return BarChartGroupData(x: i, barsSpace: 3, barRods: [
                  BarChartRodData(toY: 20 + rng.nextDouble() * 40, color: _kMagenta, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                  BarChartRodData(toY: 10 + rng.nextDouble() * 30, color: _kViolet.withAlpha(120), width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                ]);
              }),
              barTouchData: BarTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // CARD 2: ACCESS METRICS — Bar Chart + Identity Datastores + Identity Risk
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildAccessMetricsCard() {
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Access Type chart + Identity Risk gauge
          LayoutBuilder(builder: (ctx, constraints) {
            final isWide = constraints.maxWidth > 500;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAccessTypeChart()),
                  const SizedBox(width: 20),
                  SizedBox(width: 160, child: _buildIdentityRiskGauge()),
                ],
              );
            }
            return Column(children: [
              _buildAccessTypeChart(),
              const SizedBox(height: 20),
              _buildIdentityRiskGauge(),
            ]);
          }),
          const SizedBox(height: 20),
          // Identity Datastores
          _buildIdentityDatastores(),
        ],
      ),
    );
  }

  Widget _buildAccessTypeChart() {
    final rng = math.Random(99);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Access type', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            _legendDot(_kMagenta, 'Admin'),
            const SizedBox(width: 6),
            _legendDot(_kViolet, 'Analyst'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withAlpha(6), strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (val, _) {
                      const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                      final idx = val.toInt();
                      if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                      return Text(labels[idx], style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 9));
                    },
                  ),
                ),
              ),
              barGroups: List.generate(5, (i) {
                return BarChartGroupData(x: i, barsSpace: 3, barRods: [
                  BarChartRodData(toY: 10 + rng.nextDouble() * 35, color: _kMagenta, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                  BarChartRodData(toY: 5 + rng.nextDouble() * 25, color: _kViolet.withAlpha(140), width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
                ]);
              }),
              barTouchData: BarTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityRiskGauge() {
    return Column(
      children: [
        Text('Identity Risk', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 8,
                  color: Colors.white.withAlpha(8),
                  strokeCap: StrokeCap.round,
                ),
              ),
              SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(
                  value: 0.32,
                  strokeWidth: 8,
                  color: _kAmber,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('32', style: GoogleFonts.syne(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  Text('ELEVATED', style: GoogleFonts.spaceGrotesk(color: _kAmber, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityDatastores() {
    final datastores = [
      ('Firebase Auth', Icons.local_fire_department_rounded, _kAmber, 0.85),
      ('Google Cloud IAM', Icons.cloud_outlined, _kBlue, 0.72),
      ('Hugging Face', Icons.psychology_outlined, _kPurple, 0.55),
      ('Gemini AI Engine', Icons.auto_awesome_rounded, _kCyan, 0.92),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Identities datastore', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...datastores.map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: d.$3.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(d.$2, color: d.$3, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.$1, style: GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: d.$4,
                            color: d.$3,
                            backgroundColor: d.$3.withAlpha(15),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${(d.$4 * 100).toInt()}%', style: GoogleFonts.spaceGrotesk(color: d.$3, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
            )),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // ROW 2: HYGIENE CARD + IAM IDENTITIES
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildRow2() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 900;
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildHygieneCard()),
            const SizedBox(width: 20),
            Expanded(flex: 3, child: _buildIAMIdentitiesTable()),
          ],
        );
      }
      return Column(children: [
        _buildHygieneCard(),
        const SizedBox(height: 20),
        _buildIAMIdentitiesTable(),
      ]);
    });
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // CARD 3: HYGIENE — Datastores + Inactive Identities
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildHygieneCard() {
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Identities datastores', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildHygieneBarRow('AWS S3 Connector', [_kMagenta, _kViolet, _kBlue, _kCyan]),
          _buildHygieneBarRow('Azure AD Sync', [_kViolet, _kAmber, _kBlue, _kEmerald]),
          _buildHygieneBarRow('GCP IAM Bridge', [_kBlue, _kMagenta, _kCyan, _kPurple]),
          _buildHygieneBarRow('Firebase Auth', [_kAmber, _kViolet, _kMagenta, _kBlue]),
          const SizedBox(height: 20),
          // Hygiene & inactive identities
          Text('Hygiene & inactive identities 13200',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            _legendDot(_kEmerald, 'Overdue'),
            const SizedBox(width: 8),
            _legendDot(_kAmber, 'Stale'),
          ]),
          const SizedBox(height: 12),
          _buildInactiveRow('Earnest Service Key', 7, 3, 2),
          _buildInactiveRow('Earnest email idle', 5, 4, 1),
          _buildInactiveRow('Earnest access key', 3, 2, 3),
          _buildInactiveRow('Prompt API user', 4, 1, 2),
        ],
      ),
    );
  }

  Widget _buildHygieneBarRow(String label, List<Color> colors) {
    final rng = math.Random(label.hashCode);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 11), overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: colors.map((c) {
                    final w = 0.15 + rng.nextDouble() * 0.25;
                    return Expanded(
                      flex: (w * 100).toInt(),
                      child: Container(color: c),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveRow(String label, int d1, int d2, int d3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 11)),
          ),
          ...[d1, d2, d3].map((d) => Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    d,
                    (_) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color: _kMagenta,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _kMagenta.withAlpha(60), blurRadius: 4)],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // CARD 4: IAM IDENTITIES TABLE
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildIAMIdentitiesTable() {
    final identities = [
      _IAMIdentity(name: 'Earnest Serena Kim', email: 'serena.kim@corp.nexus.io', role: 'Admin', riskLevel: 'High', accessScore: 0.92, lastAccess: 'Aug 9, 2026'),
      _IAMIdentity(name: 'Lecia Alexander', email: 'lecia.a@cloud.nexus.io', role: 'Service Account', riskLevel: 'Medium', accessScore: 0.67, lastAccess: 'Aug 9, 2026'),
      _IAMIdentity(name: 'Kenneth Small Sir', email: 'kenneth.s@api.nexus.io', role: 'Access Key', riskLevel: 'Low', accessScore: 0.34, lastAccess: 'Aug 8, 2026'),
      _IAMIdentity(name: 'Maria Mckinley', email: 'maria.m@ops.nexus.io', role: 'Operator', riskLevel: 'Medium', accessScore: 0.55, lastAccess: 'Jul 23, 2026'),
      _IAMIdentity(name: 'Samarah Algaydi', email: 'samarah.a@sec.nexus.io', role: 'Analyst', riskLevel: 'High', accessScore: 0.88, lastAccess: 'Aug 9, 2026'),
      _IAMIdentity(name: 'Zul Irfan Basset Sam', email: 'zul.irfan@int.nexus.io', role: 'External', riskLevel: 'High', accessScore: 0.79, lastAccess: 'Jul 30, 2026'),
    ];

    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.fingerprint_outlined, color: _kViolet, size: 18),
              const SizedBox(width: 10),
              Text('IAM Identities',
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
              const Spacer(),
              // Search pill
              Container(
                width: 160,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _kBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: _kZinc500, size: 14),
                    const SizedBox(width: 6),
                    Text('Search identities…', style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kEmerald.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _kEmerald.withAlpha(40)),
                ),
                child: Text('${identities.length} ACTIVE',
                    style: GoogleFonts.spaceGrotesk(color: _kEmerald, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.white.withAlpha(5)),
              dataRowColor: WidgetStateProperty.all(Colors.transparent),
              dividerThickness: 0.5,
              headingTextStyle: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w600),
              columns: const [
                DataColumn(label: Text('IDENTITY')),
                DataColumn(label: Text('EMAIL')),
                DataColumn(label: Text('CREATED')),
                DataColumn(label: Text('LAST USED')),
                DataColumn(label: Text('RISK')),
                DataColumn(label: Text('PLATFORM')),
              ],
              rows: identities.map((id) {
                return DataRow(cells: [
                  DataCell(UserAvatarRow(name: id.name, email: '')),
                  DataCell(Text(id.email, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 11))),
                  DataCell(Text(id.lastAccess, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 11))),
                  DataCell(Text(id.lastAccess, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 11))),
                  DataCell(RiskBadge(
                    label: id.riskLevel.toUpperCase(),
                    color: id.riskLevel == 'High' ? _kRose : id.riskLevel == 'Medium' ? _kAmber : _kEmerald,
                  )),
                  DataCell(_buildPlatformIcons()),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcons() {
    final platforms = [
      (Icons.cloud_outlined, _kBlue),
      (Icons.local_fire_department_rounded, _kAmber),
      (Icons.psychology_outlined, _kPurple),
      (Icons.auto_awesome_rounded, _kCyan),
    ];
    final rng = math.Random();
    final count = 2 + rng.nextInt(3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: platforms.take(count).map((p) => Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: p.$2.withAlpha(15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: p.$2.withAlpha(30)),
            ),
            child: Icon(p.$1, size: 12, color: p.$2),
          )).toList(),
    );
  }



  // ══════════════════════════════════════════════════════════════════════════════
  // UPLOAD / SCAN ZONE
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildUploadZone() {
    final hasResult = _threatScore > 0;
    final isDeepfake = _geminiVerdict == 'DEEPFAKE';
    final verdictColor = isDeepfake ? _kRose : (_geminiVerdict == 'AWAITING PAYLOAD' ? _kZinc500 : _kEmerald);
    final threatBarColor = _threatScore >= 70 ? _kRose : (_threatScore >= 30 ? _kAmber : _kEmerald);

    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 700;
      final uploadCard = _DashCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _kViolet.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: _kViolet.withAlpha(40), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.cloud_upload_outlined, color: _kViolet, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payload Ingestion', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('DEEPFAKE DETECTION ENGINE', style: GoogleFonts.spaceGrotesk(color: _kViolet.withAlpha(180), fontSize: 9, letterSpacing: 2)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isUploading ? null : _handleUpload,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                decoration: BoxDecoration(
                  color: _isUploading ? _kViolet.withAlpha(15) : (_lastFileName != null ? _kMagenta.withAlpha(8) : Colors.black.withAlpha(80)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isUploading ? _kViolet.withAlpha(130) : (_lastFileName != null ? _kMagenta.withAlpha(100) : Colors.white.withAlpha(30)),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isUploading) ...[
                      const SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: _kViolet, strokeWidth: 2)),
                      const SizedBox(height: 12),
                      Text('NEURAL PROCESSING…', style: GoogleFonts.spaceGrotesk(color: _kViolet, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ] else ...[
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: Colors.black.withAlpha(100), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withAlpha(10))),
                        child: const Icon(Icons.folder_open_outlined, size: 28, color: _kZinc600),
                      ),
                      const SizedBox(height: 14),
                      Text('Drag & Drop or Click to Browse', style: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('IMAGE  •  VIDEO  •  AUDIO', style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: ['image', 'video', 'audio'].map((type) {
                final isActive = _ingestionMediaType == type;
                final icon = type == 'image' ? Icons.image_outlined : type == 'video' ? Icons.videocam_outlined : Icons.music_note_outlined;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _ingestionMediaType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isActive ? const LinearGradient(colors: [_kPurple, _kMagenta]) : null,
                        color: isActive ? null : Colors.white.withAlpha(6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isActive ? Colors.transparent : _kBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: isActive ? Colors.white : _kZinc500, size: 14),
                          const SizedBox(width: 5),
                          Text(type.toUpperCase(), style: GoogleFonts.spaceGrotesk(color: isActive ? Colors.white : _kZinc500, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_lastFileName != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withAlpha(5), borderRadius: BorderRadius.circular(8), border: Border.all(color: _kBorder)),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, color: _kViolet, size: 14),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_lastFileName!, style: GoogleFonts.spaceGrotesk(color: _kViolet, fontSize: 11), overflow: TextOverflow.ellipsis)),
                    GestureDetector(onTap: () => setState(() => _lastFileName = null), child: const Icon(Icons.close, color: _kZinc500, size: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            GestureDetector(
              onTap: _isUploading ? null : _handleUpload,
              child: AnimatedOpacity(
                opacity: _isUploading ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00F0FF), Color(0xFF8B5CF6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF00F0FF).withAlpha(70), blurRadius: 28, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.radar_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text('SCAN PAYLOAD', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 2.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      final resultCard = _DashCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SCAN RESULT', style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 2.0, fontSize: 14)),
            const SizedBox(height: 4),
            Text('LIVE ANALYSIS OUTPUT', style: GoogleFonts.spaceGrotesk(color: _kViolet.withAlpha(180), fontSize: 9, letterSpacing: 2)),
            const SizedBox(height: 24),
            // ── Pulsing Iris Threat Ring ─────────────────────────────────────────────────
            Center(
              child: _ThreatIris(
                score: _threatScore,
                isScanning: _isUploading,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('THREAT SCORE', style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 10, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: verdictColor.withAlpha(12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: verdictColor.withAlpha(60)),
              ),
              child: Row(
                children: [
                  _PulsingDot(color: verdictColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GEMINI VERDICT', style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 10, letterSpacing: 1.5)),
                        const SizedBox(height: 2),
                        Text(_geminiVerdict, style: GoogleFonts.outfit(color: verdictColor, fontWeight: FontWeight.w700, fontSize: 18)),
                      ],
                    ),
                  ),
                  if (hasResult)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: verdictColor.withAlpha(20), borderRadius: BorderRadius.circular(6), border: Border.all(color: verdictColor.withAlpha(50))),
                      child: Text(
                        _threatScore >= 70 ? 'CRITICAL' : _threatScore >= 30 ? 'ELEVATED' : 'SECURE',
                        style: GoogleFonts.spaceGrotesk(color: verdictColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                      ),
                    ),
                ],
              ),
            ),
            if (hasResult && _geminiReasoning != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: _kCyan, size: 14),
                        const SizedBox(width: 6),
                        Text('NVIDIA AI REASONING', style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_geminiReasoning!, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, height: 1.5)),
                  ],
                ),
              ),
            ],
            if (!hasResult) ...[
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.radar_rounded, color: _kZinc600, size: 48),
                    const SizedBox(height: 8),
                    Text('Upload a file to begin analysis', style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ],
        ),
      );

      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: uploadCard),
            const SizedBox(width: 20),
            Expanded(flex: 3, child: resultCard),
          ],
        );
      }
      return Column(children: [uploadCard, const SizedBox(height: 20), resultCard]);
    });
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // SECONDARY CHARTS ROW — Coverage, Top Categories, Threat Distribution
  // ══════════════════════════════════════════════════════════════════════════════
  Widget _buildSecondaryChartsRow() {
    return LayoutBuilder(builder: (ctx, constraints) {
      final isWide = constraints.maxWidth > 900;
      if (isWide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCoveragePanel()),
            const SizedBox(width: 20),
            Expanded(child: _buildTopCategoriesPanel()),
            const SizedBox(width: 20),
            Expanded(child: _buildDonutChart()),
          ],
        );
      }
      return Column(children: [
        _buildCoveragePanel(),
        const SizedBox(height: 20),
        _buildTopCategoriesPanel(),
        const SizedBox(height: 20),
        _buildDonutChart(),
      ]);
    });
  }

  Widget _buildCoveragePanel() {
    final providers = [
      ('Firebase', Icons.local_fire_department, _kAmber),
      ('Google Cloud', Icons.cloud_outlined, _kBlue),
      ('Hugging Face', Icons.psychology_outlined, _kPurple),
      ('Gemini AI', Icons.auto_awesome, _kEmerald),
    ];
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Coverage', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Active providers', style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 10, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          ...providers.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: p.$3.withAlpha(20), borderRadius: BorderRadius.circular(8)),
                      child: Icon(p.$2, color: p.$3, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(p.$1, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _kEmerald.withAlpha(15), borderRadius: BorderRadius.circular(4)),
                      child: Text('ACTIVE', style: GoogleFonts.spaceGrotesk(color: _kEmerald, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesPanel() {
    final categories = [
      ('GAN Artifacts', 0.85, _kMagenta),
      ('Face Swap', 0.72, _kPurple),
      ('Voice Clone', 0.61, _kBlue),
      ('Text-to-Image', 0.44, _kAmber),
      ('Metadata Spoof', 0.28, _kEmerald),
    ];
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 5 Categories', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Threat classification', style: GoogleFonts.spaceGrotesk(color: _kZinc600, fontSize: 10, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          ...categories.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(c.$1, style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))),
                      Text('${(c.$2 * 100).toInt()}%', style: GoogleFonts.spaceGrotesk(color: c.$3, fontSize: 11, fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(value: c.$2, color: c.$3, backgroundColor: c.$3.withAlpha(12), minHeight: 4),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    // Static threat distribution data
    const secure = 312;
    const elevated = 87;
    const critical = 43;
    const total = secure + elevated + critical;
    const securePercent = (secure * 100) ~/ total;

    final sections = [
      PieChartSectionData(value: secure.toDouble(), color: _kEmerald, title: '', radius: 40),
      PieChartSectionData(value: elevated.toDouble(), color: _kAmber, title: '', radius: 40),
      PieChartSectionData(value: critical.toDouble(), color: _kRose, title: '', radius: 40),
    ];

    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Threats Coverage', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 4, pieTouchData: PieTouchData(enabled: false))),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('$securePercent%', style: GoogleFonts.syne(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text('SECURE', style: GoogleFonts.spaceGrotesk(color: _kEmerald, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _legendDot(_kEmerald, 'Secure'),
            const SizedBox(width: 16),
            _legendDot(_kAmber, 'Elevated'),
            const SizedBox(width: 16),
            _legendDot(_kRose, 'Critical'),
          ]),
        ],
      ),
    );
  }



  // ── Helper ──────────────────────────────────────────────────────────────────
  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAnalysisLog() {
    return _DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ANALYSIS LOG', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _scanHistory.isEmpty 
          ? Center(child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text('No payloads scanned yet. Upload media to see history.', style: GoogleFonts.spaceGrotesk(color: _kZinc500)),
          ))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.7),
                child: DataTable(
                  headingTextStyle: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 12, fontWeight: FontWeight.bold),
                  dataTextStyle: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 13),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('FILE NAME')),
                    DataColumn(label: Text('THREAT SCORE')),
                    DataColumn(label: Text('VERDICT')),
                  ],
                  rows: _scanHistory.map((scan) {
                    final isThreat = scan.threatScore >= 50.0 || scan.geminiVerdict == 'DEEPFAKE';
                    final color = isThreat ? Colors.orange : _kEmerald;
                    return DataRow(cells: [
                      DataCell(Text(scan.id)),
                      DataCell(Text(scan.fileName)),
                      DataCell(Text('${scan.threatScore}%')),
                      DataCell(
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: _kCardBg,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white.withAlpha(20))),
                                  title: Text('Forensic Analysis', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                                  content: SizedBox(
                                    width: 500,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('PAYLOAD ID: ${scan.id}', style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 12, letterSpacing: 1.0)),
                                          const SizedBox(height: 4),
                                          Text('THREAT SCORE: ${scan.threatScore}%', style: GoogleFonts.spaceGrotesk(color: color, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                          const SizedBox(height: 24),
                                          Text('AI REASONING', style: GoogleFonts.spaceGrotesk(color: _kCyan, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                          const SizedBox(height: 8),
                                          Text(scan.geminiReasoning ?? 'No detailed forensic data available.', style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, height: 1.6)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text('Close', style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: color.withAlpha(20), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withAlpha(50))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(scan.geminiVerdict ?? 'UNKNOWN', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 6),
                                    Icon(Icons.open_in_new, size: 12, color: color.withAlpha(150)),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
        ]
      )
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withAlpha(50)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: GoogleFonts.spaceGrotesk(color: _kZinc400, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'NEXUS_GATEWAY ENGINE',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (ctx, constraints) {
          final isWide = constraints.maxWidth > 900;
          final cards = [
            _buildFeatureCard(
              'Hugging Face Inference',
              'Tier-1 visual anomaly detection leveraging optimized neural networks to instantly identify deepfake traces at the pixel level.',
              Icons.camera_alt_outlined,
              _kMagenta,
            ),
            _buildFeatureCard(
              'Gemini Multimodal',
              'Tier-2 contextual and metadata analysis powered by advanced generative AI to evaluate complex generative artifacts.',
              Icons.auto_awesome,
              _kCyan,
            ),
            _buildFeatureCard(
              'Zero-Trust Security',
              'Robust IAM and Firebase Auth layer ensuring payloads and analytics are accessible strictly to authorized gateway operators.',
              Icons.gpp_good_outlined,
              _kEmerald,
            ),
          ];

          if (isWide) {
            return IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: cards[0]), const SizedBox(width: 20),
                  Expanded(child: cards[1]), const SizedBox(width: 20),
                  Expanded(child: cards[2]),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                cards[0], const SizedBox(height: 16),
                cards[1], const SizedBox(height: 16),
                cards[2],
              ],
            );
          }
        }),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// REUSABLE CARD WRAPPER - Glassmorphic dark card
// ══════════════════════════════════════════════════════════════════════════════
class _DashCard extends StatelessWidget {
  final Widget child;
  const _DashCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00F0FF).withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withAlpha(10),
                blurRadius: 32,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MICRO-COMPONENTS
// ══════════════════════════════════════════════════════════════════════════════

class RiskBadge extends StatelessWidget {
  final String label;
  final Color color;
  const RiskBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(50)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: GoogleFonts.spaceGrotesk(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
    );
  }
}

class MiniProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  const MiniProgressBar({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: value, color: color, backgroundColor: color.withAlpha(15)),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).toInt()}%', style: GoogleFonts.spaceGrotesk(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class UserAvatarRow extends StatelessWidget {
  final String name;
  final String email;
  const UserAvatarRow({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
    final hash = name.hashCode;
    final avatarColor = Color.fromARGB(255, 60 + (hash % 80), 40 + (hash ~/ 3 % 60), 120 + (hash ~/ 7 % 100));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: avatarColor.withAlpha(60),
            shape: BoxShape.circle,
            border: Border.all(color: avatarColor.withAlpha(100)),
          ),
          child: Center(child: Text(initials, style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            if (email.isNotEmpty) Text(email, style: GoogleFonts.spaceGrotesk(color: _kZinc500, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS & DATA CLASSES
// ══════════════════════════════════════════════════════════════════════════════

class _IAMIdentity {
  final String name;
  final String email;
  final String role;
  final String riskLevel;
  final double accessScore;
  final String lastAccess;
  const _IAMIdentity({
    required this.name,
    required this.email,
    required this.role,
    required this.riskLevel,
    required this.accessScore,
    required this.lastAccess,
  });
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color.withAlpha((_anim.value * 255).toInt()), shape: BoxShape.circle),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HUD RADAR — Multi-ring sci-fi threat scanner
// ══════════════════════════════════════════════════════════════════════════════
class _ThreatIris extends StatefulWidget {
  final double score;
  final bool isScanning;
  const _ThreatIris({required this.score, required this.isScanning});

  @override
  State<_ThreatIris> createState() => _ThreatIrisState();
}

class _ThreatIrisState extends State<_ThreatIris>
    with TickerProviderStateMixin {
  // Outer dashed ring: slow clockwise (18s)
  late final AnimationController _outerCtrl;
  // Inner ring: faster counter-clockwise (7s)
  late final AnimationController _innerCtrl;
  // Pulse glow animation
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _outerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
    _innerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _outerCtrl.dispose();
    _innerCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Color get _ringColor {
    if (widget.isScanning) return const Color(0xFF00F0FF);
    if (widget.score >= 70)  return const Color(0xFFE11D48);
    if (widget.score >= 30)  return const Color(0xFFF59E0B);
    if (widget.score > 0)    return const Color(0xFF10B981);
    return const Color(0xFF52525B);
  }

  @override
  Widget build(BuildContext context) {
    final color = _ringColor;
    final isAlert = widget.score >= 70 && !widget.isScanning;

    return AnimatedBuilder(
      animation: Listenable.merge([_outerCtrl, _innerCtrl, _pulseAnim]),
      builder: (context, _) {
        return SizedBox(
          width: 190,
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Ambient glow halo ─────────────────────────────────────────
              Container(
                width: 190, height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha((isAlert ? 110 : 50) * _pulseAnim.value ~/ 1),
                      blurRadius: isAlert ? 80 : 40,
                      spreadRadius: isAlert ? 16 : 6,
                    ),
                  ],
                ),
              ),

              // ── Outer dashed ring: rotates CLOCKWISE slowly ───────────────
              Transform.rotate(
                angle: _outerCtrl.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(190, 190),
                  painter: _DashedRingPainter(color: color.withAlpha(100), dashCount: 24, strokeWidth: 1.5),
                ),
              ),

              // ── Middle ring: score indicator, rotates COUNTER-CLOCKWISE ───
              Transform.rotate(
                angle: -_innerCtrl.value * 2 * math.pi,
                child: SizedBox(
                  width: 158, height: 158,
                  child: CircularProgressIndicator(
                    value: widget.isScanning ? null : (widget.score / 100).clamp(0.0, 1.0),
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.round,
                    color: color,
                    backgroundColor: color.withAlpha(18),
                  ),
                ),
              ),

              // ── Inner decorative dashed ring: rotates CLOCKWISE (faster) ──
              Transform.rotate(
                angle: _innerCtrl.value * 2 * math.pi * 0.6,
                child: CustomPaint(
                  size: const Size(130, 130),
                  painter: _DashedRingPainter(color: color.withAlpha(60), dashCount: 16, strokeWidth: 1.0),
                ),
              ),

              // ── Inner pulsing radial glow ─────────────────────────────────
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withAlpha((60 * _pulseAnim.value).toInt()),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // ── Score text with glow shadow ───────────────────────────────
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isScanning ? '···' : widget.score.toStringAsFixed(1),
                    style: GoogleFonts.syne(
                      color: color,
                      fontSize: widget.isScanning ? 26 : 34,
                      fontWeight: FontWeight.w300,
                      height: 1,
                      shadows: [
                        Shadow(color: color.withAlpha(180), blurRadius: 12),
                        Shadow(color: color.withAlpha(80), blurRadius: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isScanning ? 'SCANNING' : '/100',
                    style: GoogleFonts.spaceGrotesk(
                      color: color.withAlpha(160),
                      fontSize: 9,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Custom Painter: Dashed circular ring ─────────────────────────────────────
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;
  final double strokeWidth;
  const _DashedRingPainter({required this.color, required this.dashCount, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;
    final dashAngle = (2 * math.pi) / dashCount;
    final gapFraction = 0.45; // 45% of each slot is gap

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color || old.dashCount != dashCount;
}


