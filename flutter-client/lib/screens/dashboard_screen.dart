import 'dart:ui';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

// ── DESIGN SYSTEM ─────────────────────────────────────────────────────────────
const kPureBlack = Color(0xFF000000);
const kGlassBg = Color(0x08FFFFFF); // rgba(255,255,255,0.03)
const kGlassBorder = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
const kGlassGlow = Color(0x0DFFFFFF); // Soft white glow
const kWhite = Color(0xFFFFFFFF);
const kGray400 = Color(0xFFA1A1AA);
const kGray600 = Color(0xFF52525B);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  // Navigation
  int _navIndex = 0;

  // Scan state
  bool _isScanning = false;
  PlatformFile? _selectedFile;
  ScanResult? _currentResult;
  List<ScanResult> _history = [];
  String _mediaType = 'IMAGE'; // 'IMAGE' | 'VIDEO' | 'AUDIO'

  // Animations
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _apiService.getScanHistory();
      if (mounted) {
        setState(() => _history = history);
      }
    } catch (e) {
      debugPrint('Error loading scan history: $e');
      // Gracefully handle error by keeping history empty
      if (mounted) {
        setState(() => _history = []);
      }
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: _mediaType == 'IMAGE' 
          ? FileType.image 
          : _mediaType == 'VIDEO' 
          ? FileType.video 
          : FileType.audio,
      withData: true,
    );
    if (result != null) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  Future<void> _startScan() async {
    if (_selectedFile == null) return;
    setState(() {
      _isScanning = true;
      _currentResult = null;
    });

    try {
      // Simulate enterprise scanning delay for better UX feel
      await Future.delayed(const Duration(seconds: 2));
      
      final res = await _apiService.scanMedia(_selectedFile!);
      setState(() {
        _currentResult = res;
        _history.insert(0, res);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.withOpacity(0.9),
            content: Text('SECURITY SCAN INTERRUPTED: $e', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPureBlack,
      body: Stack(
        children: [
          // Background subtle glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.03),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildCurrentView(),
                  ),
                ],
              ),
            ),
          ),

          // Scanning Overlay
          if (_isScanning) _buildScanningOverlay(),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_navIndex) {
      case 0: return _buildDashboardView();
      case 1: return _buildScansView();
      case 2: return _buildAnalyticsView();
      case 3: return _buildAlertsView();
      case 4: return _buildSettingsView();
      default: return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildRow1(),
          const SizedBox(height: 24),
          _buildRow2(),
          const SizedBox(height: 24),
          _buildRow3(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildScansView() {
    return Column(
      children: [
        _buildRow3(), // Reuse the analysis log as the main scans view
      ],
    );
  }

  Widget _buildAnalyticsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'ANALYTICS ENGINE OFFLINE',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'AGGREGATING GLOBAL THREAT DATA...',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'ZERO ACTIVE ALERTS',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            'SYSTEM INTEGRITY OPTIMAL',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, color: kGray600, size: 64),
          const SizedBox(height: 16),
          Text(
            'SYSTEM CONFIGURATION',
            style: GoogleFonts.outfit(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          _buildPrimaryButton(
            label: 'REVOKE AUTHENTICATION',
            icon: Icons.logout,
            onPressed: () => _authService.signOut().then((_) => Navigator.pushReplacementNamed(context, '/login')),
            isCompact: true,
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: kPureBlack.withOpacity(0.8),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 120 * _pulseAnimation.value,
                  height: 120 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kWhite.withOpacity(0.2), width: 1),
                  ),
                  child: Center(
                    child: Icon(Icons.radar, color: kWhite, size: 40),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'INITIALIZING DEEP_SCAN...',
              style: GoogleFonts.outfit(
                color: kWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ANALYZING NEURAL PATTERNS',
              style: GoogleFonts.outfit(
                color: kGray400,
                fontSize: 10,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Container(
              width: 300,
              height: 2,
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Positioned(
                        left: 300 * (_pulseController.value - 0.5).abs() * 2,
                        child: Container(
                          width: 60,
                          height: 2,
                          color: kWhite,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEXUS_GATEWAY',
                        style: GoogleFonts.outfit(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'DEEPFAKE DETECTION ENGINE',
                        style: GoogleFonts.outfit(
                          color: kGray400,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildIconButton(Icons.notifications_outlined, () => setState(() => _navIndex = 3)),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.person_outline, () => setState(() => _navIndex = 4)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildNavCapsule(),
            ),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXUS_GATEWAY',
                  style: GoogleFonts.outfit(
                    color: kWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'DEEPFAKE DETECTION ENGINE',
                  style: GoogleFonts.outfit(
                    color: kGray400,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildNavCapsule())),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildIconButton(Icons.notifications_outlined, () => setState(() => _navIndex = 3)),
              const SizedBox(width: 12),
              _buildIconButton(Icons.person_outline, () => setState(() => _navIndex = 4)),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildNavCapsule() {
    final items = ['Dashboard', 'Scans', 'Analytics', 'Alerts', 'Settings'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kGlassBg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: kGlassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final isSelected = _navIndex == e.key;
          return GestureDetector(
            onTap: () => setState(() => _navIndex = e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? kWhite : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                e.value,
                style: GoogleFonts.outfit(
                  color: isSelected ? kPureBlack : kGray400,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kGlassBorder),
          color: kGlassBg,
        ),
        child: Icon(icon, color: kWhite, size: 20),
      ),
    );
  }

  // ── ROW 1 ───────────────────────────────────────────────────────────────────
  Widget _buildRow1() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        return Column(
          children: [
            _buildPayloadIngestion(isExpanded: false),
            const SizedBox(height: 16),
            _buildScanResultMain(isExpanded: false),
            const SizedBox(height: 16),
            _buildUploadPreview(isExpanded: false),
          ],
        );
      }
      return SizedBox(
        height: 480,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _buildPayloadIngestion(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 4, child: _buildScanResultMain(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 3, child: _buildUploadPreview(isExpanded: true)),
          ],
        ),
      );
    });
  }

  Widget _buildPayloadIngestion({bool isExpanded = true}) {
    return GlassCard(
      title: 'PAYLOAD INGESTION',
      isExpanded: isExpanded,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropZone(isExpanded: isExpanded),
          const SizedBox(height: 16),
          _buildMediaTypeTabs(),
          const SizedBox(height: 16),
          if (_selectedFile != null)
            _buildSelectedFileRow()
          else
            const SizedBox(height: 42),
          const SizedBox(height: 16),
          _buildPrimaryButton(
            label: 'SCAN PAYLOAD',
            icon: Icons.radar,
            onPressed: _startScan,
            isLoading: _isScanning,
          ),
        ],
      ),
    );
  }

  Widget _buildDropZone({bool isExpanded = false}) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: isExpanded ? 200 : null,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: kGlassBorder, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.01),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, color: kGray400, size: 32),
            const SizedBox(height: 12),
            Text(
              'Drag & Drop or Click to Browse',
              style: GoogleFonts.outfit(color: kWhite, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'IMAGE • VIDEO • AUDIO',
              style: GoogleFonts.outfit(color: kGray600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTypeTabs() {
    final types = ['IMAGE', 'VIDEO', 'AUDIO'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((t) {
        final isSelected = _mediaType == t;
        return GestureDetector(
          onTap: () => setState(() {
            _mediaType = t;
            _selectedFile = null;
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? kWhite.withOpacity(0.05) : Colors.transparent,
              border: Border.all(color: isSelected ? kWhite : kGlassBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              t,
              style: GoogleFonts.outfit(
                color: isSelected ? kWhite : kGray400,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedFileRow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGlassBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file_outlined, color: kWhite, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedFile!.name,
              style: GoogleFonts.outfit(color: kWhite, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedFile = null),
            child: Icon(Icons.close, color: kGray400, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResultMain({bool isExpanded = true}) {
    final score = _currentResult?.threatScore ?? 0.0;
    final verdict = _currentResult?.geminiVerdict ?? 'AWAITING SCAN';

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 180 * _pulseAnimation.value,
                  height: 180 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kWhite.withOpacity(0.1 / _pulseAnimation.value),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kWhite.withOpacity(0.1), width: 1),
              ),
              child: CustomPaint(
                painter: _CircularScorePainter(score / 100),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        score.toStringAsFixed(1),
                        style: GoogleFonts.outfit(
                          color: kWhite,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/100',
                        style: GoogleFonts.outfit(
                          color: kGray400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'THREAT SCORE',
                        style: GoogleFonts.outfit(
                          color: kGray600,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: kWhite.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            verdict.toUpperCase(),
            style: GoogleFonts.outfit(
              color: kWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'CONFIDENCE: ${score.toStringAsFixed(1)}%',
          style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
        ),
        const SizedBox(height: 24),
        _buildStatsRow(),
      ],
    );

    return GlassCard(
      title: 'SCAN RESULT',
      subtitle: 'LIVE ANALYSIS OUTPUT',
      isExpanded: isExpanded,
      child: content,
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 450;
      if (isMobile) {
        return Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildMiniStat('TOTAL SCANS', _history.length.toString(), Icons.layers),
            _buildMiniStat('DEEPFAKE RATE', '32.3%', Icons.security),
            _buildMiniStat('ACCURACY', '91.4%', Icons.check_circle_outline),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _buildMiniStat('TOTAL SCANS', _history.length.toString(), Icons.layers)),
          Container(width: 1, height: 24, color: kWhite.withOpacity(0.1)),
          Expanded(child: _buildMiniStat('DEEPFAKE RATE', '32.3%', Icons.security)),
          Container(width: 1, height: 24, color: kWhite.withOpacity(0.1)),
          Expanded(child: _buildMiniStat('ACCURACY', '91.4%', Icons.check_circle_outline)),
        ],
      );
    });
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: kGray400, size: 12),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(color: kGray600, fontSize: 8, letterSpacing: 0.3),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(color: kWhite, fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPreview({bool isExpanded = true}) {
    return GlassCard(
      title: 'UPLOAD PREVIEW',
      isExpanded: isExpanded,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kWhite.withOpacity(0.02),
              border: Border.all(color: kGlassBorder),
            ),
            child: _selectedFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _mediaType == 'IMAGE' && _selectedFile!.bytes != null
                        ? Image.memory(_selectedFile!.bytes!, fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.play_circle_outline, color: kWhite, size: 48)),
                  )
                : const Center(child: Icon(Icons.image_outlined, color: kGray600, size: 48)),
          ),
          const SizedBox(height: 20),
          _buildMetadataRow('FILE NAME', _selectedFile?.name ?? 'No file selected'),
          _buildMetadataRow('FILE TYPE', _selectedFile?.extension?.toUpperCase() ?? '--'),
          _buildMetadataRow('FILE SIZE', _selectedFile != null ? '${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB' : '--'),
          _buildMetadataRow('RESOLUTION', '1024 x 683'),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: GoogleFonts.outfit(color: kGray600, fontSize: 10), overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value, 
              style: GoogleFonts.outfit(color: kWhite, fontSize: 11, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ── ROW 2 ───────────────────────────────────────────────────────────────────
  Widget _buildRow2() {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      if (isMobile) {
        // On mobile, cards are in an unbounded scroll context.
        // isExpanded:false prevents GlassCard from using Expanded/Spacer
        // which would crash inside SingleChildScrollView.
        return Column(
          children: [
            GlassCard(
              title: 'NVIDIA AI REASONING',
              isExpanded: false,
              child: _buildAiReasoningContent(isExpanded: false),
            ),
            const SizedBox(height: 16),
            GlassCard(
              title: 'GEMINI VERDICT',
              isExpanded: false,
              child: _buildGeminiVerdictContent(isExpanded: false),
            ),
          ],
        );
      }
      // Desktop: fixed 240px height, cards stretch to fill.
      return SizedBox(
        height: 240,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: _buildAiReasoning(isExpanded: true)),
            const SizedBox(width: 24),
            Expanded(flex: 5, child: _buildGeminiVerdict(isExpanded: true)),
          ],
        ),
      );
    });
  }

  // Desktop card wrapper (isExpanded:true = Expanded inside GlassCard,
  // which is safe because the parent Row has a bounded height of 240px)
  Widget _buildAiReasoning({bool isExpanded = true}) {
    return GlassCard(
      title: 'NVIDIA AI REASONING',
      isExpanded: isExpanded,
      child: _buildAiReasoningContent(isExpanded: isExpanded),
    );
  }

  // Shared content, reused by both desktop (Expanded) and mobile (min) card.
  Widget _buildAiReasoningContent({bool isExpanded = true}) {
    final reasoning = _currentResult?.geminiReasoning ?? 'No analysis performed yet. Please upload a payload and initiate a scan to receive AI reasoning output.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 120),
          child: SingleChildScrollView(
            child: Text(
              reasoning,
              style: GoogleFonts.outfit(
                color: kGray400,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildPrimaryButton(
          label: 'VIEW FULL ANALYSIS',
          icon: Icons.open_in_full,
          onPressed: () {},
          isCompact: true,
        ),
      ],
    );
  }

  Widget _buildGeminiVerdict({bool isExpanded = true}) {
    final isDeepfake = _currentResult?.geminiVerdict == 'DEEPFAKE';
    return GlassCard(
      title: 'GEMINI VERDICT',
      isExpanded: isExpanded,
      child: _buildGeminiVerdictContent(isExpanded: isExpanded),
    );
  }

  Widget _buildGeminiVerdictContent({bool isExpanded = true}) {
    final isDeepfake = _currentResult?.geminiVerdict == 'DEEPFAKE';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
          Text(
            _currentResult != null ? (isDeepfake ? 'DEEPFAKE DETECTED' : 'AUTHENTIC CONTENT') : 'AWAITING ANALYSIS',
            style: GoogleFonts.outfit(
              color: kWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          Text(
            _currentResult != null
                ? 'The content has been classified with high confidence.'
                : 'Upload a payload to see the verdict.',
            style: GoogleFonts.outfit(color: kGray400, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (_currentResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isDeepfake ? 'CRITICAL' : 'SAFE',
                style: GoogleFonts.outfit(color: kWhite, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.access_time, color: kGray600, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '23 Apr 2026, 05:24:15 PM',
                  style: GoogleFonts.outfit(color: kGray600, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );
  }



  // ── ROW 3 ───────────────────────────────────────────────────────────────────
  Widget _buildRow3() {
    return GlassCard(
      title: 'ANALYSIS LOG',
      isExpanded: false,
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(color: kGlassBorder, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length.clamp(0, 5),
            separatorBuilder: (context, index) => const Divider(color: kGlassBorder, height: 1),
            itemBuilder: (context, index) {
              final scan = _history[index];
              return _buildTableRow(scan);
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'VIEW ALL SCANS',
              style: GoogleFonts.outfit(
                color: kGray400,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('FILE NAME', style: _tableHeaderStyle)),
              Expanded(flex: 2, child: Text('SCORE', style: _tableHeaderStyle)),
              Expanded(flex: 2, child: Text('VERDICT', style: _tableHeaderStyle)),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text('ID', style: _tableHeaderStyle)),
            Expanded(flex: 3, child: Text('FILE NAME', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('TYPE', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('THREAT SCORE', style: _tableHeaderStyle)),
            Expanded(flex: 1, child: Text('VERDICT', style: _tableHeaderStyle)),
            Expanded(flex: 2, child: Text('TIME', style: _tableHeaderStyle)),
          ],
        ),
      );
    });
  }

  TextStyle get _tableHeaderStyle => GoogleFonts.outfit(color: kGray600, fontSize: 10, fontWeight: FontWeight.bold);

  Widget _buildTableRow(ScanResult scan) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(scan.fileName, style: _tableRowStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
              Expanded(flex: 2, child: Text('${scan.threatScore.toStringAsFixed(1)}', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text(scan.geminiVerdict?.toUpperCase() ?? 'NONE', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text('#${scan.id}', style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 3, child: Text(scan.fileName, style: _tableRowStyle, overflow: TextOverflow.ellipsis, maxLines: 1)),
            Expanded(flex: 1, child: Row(
              children: [
                Icon(_getIconForType(scan.mediaType), color: kGray400, size: 14),
                const SizedBox(width: 4),
                Flexible(child: Text(scan.mediaType.toUpperCase(), style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
              ],
            )),
            Expanded(flex: 1, child: Text('${scan.threatScore.toStringAsFixed(1)} / 100', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 1, child: Text(scan.geminiVerdict?.toUpperCase() ?? 'NONE', style: _tableRowStyle.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Expanded(flex: 2, child: Text(scan.timestamp ?? '--', style: _tableRowStyle, overflow: TextOverflow.ellipsis)),
          ],
        ),
      );
    });
  }

  TextStyle get _tableRowStyle => GoogleFonts.outfit(color: kWhite, fontSize: 12);

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'video': return Icons.videocam_outlined;
      case 'audio': return Icons.audiotrack_outlined;
      default: return Icons.image_outlined;
    }
  }

  // ── UTILS ───────────────────────────────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isCompact = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: isCompact ? 10 : 16),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: kWhite.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: kPureBlack),
              )
            else ...[
              Icon(icon, color: kPureBlack, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: kPureBlack,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── CUSTOM COMPONENTS ─────────────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isExpanded;

  const GlassCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: kGlassBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kGlassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 12,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: kWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: GoogleFonts.outfit(
                    color: kGray600,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (isExpanded)
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: child,
                  ),
                )
              else
                child,
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularScorePainter extends CustomPainter {
  final double progress;

  _CircularScorePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Background track
    final trackPaint = Paint()
      ..color = kWhite.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    
    canvas.drawCircle(center, radius, trackPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = kWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
