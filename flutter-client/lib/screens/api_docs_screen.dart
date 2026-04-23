import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kBg = Color(0xFF050505);
const _kPrimary = Color(0xFF00BFFF);
const _kSecondary = Color(0xFF8B5CF6);
const _kSurface = Color(0x08FFFFFF);
const _kBorder = Color(0x14FFFFFF);
const _kZinc400 = Color(0xFFA1A1AA);

class ApiDocsScreen extends StatefulWidget {
  const ApiDocsScreen({super.key});

  @override
  State<ApiDocsScreen> createState() => _ApiDocsScreenState();
}

class _ApiDocsScreenState extends State<ApiDocsScreen> {
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePosition = event.position;
          });
        },
        child: Stack(
          children: [
            // Static Background Glows
            Positioned(
              top: -200,
              left: -200,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kPrimary.withAlpha(15),
                  boxShadow: [
                    BoxShadow(color: _kPrimary.withAlpha(15), blurRadius: 150, spreadRadius: 150)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -300,
              right: -200,
              child: Container(
                width: 800,
                height: 800,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kSecondary.withAlpha(15),
                  boxShadow: [
                    BoxShadow(color: _kSecondary.withAlpha(15), blurRadius: 200, spreadRadius: 200)
                  ],
                ),
              ),
            ),



            // Main Content
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Architecture & API Specs',
                    style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _kBg.withAlpha(200),
                          border: const Border(bottom: BorderSide(color: _kBorder)),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // REST API Section
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _kSecondary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.terminal_rounded, color: _kSecondary, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'REST API Reference',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'The core endpoints utilized by our frontend applications to communicate with the FastAPI Orchestrator. Every request is strictly authenticated using Firebase Bearer tokens injected into headers.',
                              style: GoogleFonts.inter(
                                color: _kZinc400,
                                fontSize: 17,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 48),
                            
                            _EndpointCard(
                              method: 'POST',
                              endpoint: '/api/scan',
                              title: 'Core Verification Engine',
                              description: 'Initiates a deepfake scan analysis session.',
                              whyUseIt: 'Real-time inference on mobile devices is computationally impossible. We offload heavy Vision Transformer and LLM processing to our clustered backend infrastructure to guarantee rapid, deterministic verification.',
                              params: const {
                                'file': 'multipart/form-data (Required) - The media file (image/video/audio) to analyze.',
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "id": "SCAN_A9B2",
  "file_name": "suspect_video.mp4",
  "threat_score": 92.5,
  "status": "completed",
  "media_type": "video",
  "result_details": {
    "gemini_verdict": "DEEPFAKE",
    "gemini_reasoning": "Temporal inconsistencies observed around facial boundaries. Lighting reflections do not match the environment."
  }
}''',
                            ),
                            const SizedBox(height: 40),
                            
                            _EndpointCard(
                              method: 'GET',
                              endpoint: '/api/scan',
                              title: 'Forensic Audit Log Retrieval',
                              description: 'Fetches a chronological, paginated history of all deepfake scans initiated by the authenticated user.',
                              whyUseIt: 'Enterprise threat intelligence requires persistent audit logs. This API allows the client to dynamically build forensic dashboards and review past verifications without storing massive payloads locally.',
                              params: const {
                                'page': 'integer (Optional) - Default: 1',
                                'page_size': 'integer (Optional) - Default: 10',
                                'media_type': 'string (Optional) - Filter by image, video, or audio.',
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "total": 142,
  "page": 1,
  "page_size": 10,
  "scans": [ 
    { "id": "SCAN_A9B2", "threat_score": 92.5, "status": "completed" },
    { "id": "SCAN_B3X8", "threat_score": 12.0, "status": "completed" }
  ]
}''',
                            ),
                            const SizedBox(height: 40),

                            _EndpointCard(
                              method: 'GET',
                              endpoint: '/api/scan/stats/summary',
                              title: 'Real-time Threat Telemetry',
                              description: 'Returns aggregated threat intelligence metrics across the entire user profile.',
                              whyUseIt: 'Calculating statistical averages locally on the client-side requires fetching thousands of records, which destroys bandwidth. This endpoint performs complex aggregations natively on the database layer and serves lightweight metrics instantly to our dashboard.',
                              params: const {
                                'Authorization': 'Header (Required) - Bearer <Firebase JWT Token>',
                              },
                              response: '''{
  "total_scans": 142,
  "pending_scans": 0,
  "completed_scans": 142,
  "avg_threat_score": 45.8
}''',
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EndpointCard extends StatelessWidget {
  final String method;
  final String endpoint;
  final String title;
  final String description;
  final String whyUseIt;
  final Map<String, String> params;
  final String response;

  const _EndpointCard({
    required this.method,
    required this.endpoint,
    required this.title,
    required this.description,
    required this.whyUseIt,
    required this.params,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final methodColor = method == 'POST' ? const Color(0xFF10B981) : const Color(0xFF3B82F6);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(80),
                  border: const Border(bottom: BorderSide(color: _kBorder)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: methodColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: methodColor.withAlpha(100), width: 1.5),
                      ),
                      child: Text(
                        method,
                        style: GoogleFonts.spaceMono(
                          color: methodColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        endpoint,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Body
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // What it does
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: _kZinc400, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What it does',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: GoogleFonts.inter(color: _kZinc400, height: 1.6, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Why we use it
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _kPrimary.withAlpha(10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kPrimary.withAlpha(30)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded, color: _kPrimary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Why we use it',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  whyUseIt,
                                  style: GoogleFonts.inter(color: Colors.white.withAlpha(180), height: 1.6, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (params.isNotEmpty) ...[
                      const SizedBox(height: 40),
                      Text(
                        'Parameters & Headers',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...params.entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e.key,
                                style: GoogleFonts.spaceMono(color: _kSecondary, fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  e.value,
                                  style: GoogleFonts.inter(color: _kZinc400, fontSize: 15, height: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                    const SizedBox(height: 40),
                    Text(
                      'Example Response',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D0D0D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBorder),
                      ),
                      child: Text(
                        response,
                        style: GoogleFonts.spaceMono(
                          color: const Color(0xFFA6E22E),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
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
