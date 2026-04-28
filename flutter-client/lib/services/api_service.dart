import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'auth_service.dart';

// ── Data Models ───────────────────────────────────────────────────────────────

class ScanResult {
  final String id;
  final String fileName;
  final double threatScore;
  final String status;
  final String? geminiVerdict;
  final String? geminiReasoning;
  final String? timestamp;
  final String mediaType; // 'image' | 'video' | 'audio'

  ScanResult({
    required this.id,
    required this.fileName,
    required this.threatScore,
    required this.status,
    this.geminiVerdict,
    this.geminiReasoning,
    this.timestamp,
    this.mediaType = 'image',
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final details = json['result_details'] as Map<String, dynamic>?;
    return ScanResult(
      id: (json['id'] ?? '').toString().substring(0, 8).toUpperCase(),
      fileName: json['file_name'] ?? 'Unknown',
      threatScore:
          double.tryParse((json['threat_score'] ?? '0').toString()) ?? 0.0,
      status: json['status'] ?? 'unknown',
      geminiVerdict: details?['gemini_verdict']?.toString(),
      geminiReasoning: details?['gemini_reasoning']?.toString(),
      timestamp: json['completed_at']?.toString().substring(0, 19) ??
          json['created_at']?.toString().substring(0, 19),
      mediaType: (json['media_type'] ?? 'image').toString().toLowerCase(),
    );
  }
}

/// Mirrors the React `ScanStatsResponse` returned by GET /api/scan/stats
class ScanStats {
  final int totalScans;
  final int pendingScans;
  final int completedScans;
  final double avgThreatScore;

  const ScanStats({
    required this.totalScans,
    required this.pendingScans,
    required this.completedScans,
    required this.avgThreatScore,
  });

  factory ScanStats.fromJson(Map<String, dynamic> json) {
    return ScanStats(
      totalScans: (json['total_scans'] ?? 0) as int,
      pendingScans: (json['pending_scans'] ?? 0) as int,
      completedScans: (json['completed_scans'] ?? 0) as int,
      avgThreatScore:
          double.tryParse((json['avg_threat_score'] ?? '0').toString()) ?? 0.0,
    );
  }

  /// Derive stats from a local list of scans when the backend stats
  /// endpoint is unavailable.
  factory ScanStats.fromScans(List<ScanResult> scans) {
    if (scans.isEmpty) {
      return const ScanStats(
          totalScans: 0,
          pendingScans: 0,
          completedScans: 0,
          avgThreatScore: 0);
    }
    return ScanStats(
      totalScans: scans.length,
      pendingScans:
          scans.where((s) => s.threatScore >= 50.0 || s.geminiVerdict == 'DEEPFAKE').length,
      completedScans: scans.where((s) => s.threatScore < 50.0 && s.geminiVerdict != 'DEEPFAKE').length,
      avgThreatScore: scans
              .map((s) => s.threatScore)
              .reduce((a, b) => a + b) /
          scans.length,
    );
  }
}

// ── ApiService ────────────────────────────────────────────────────────────────

class ApiService {
  final AuthService _authService = AuthService();

  /// Smart base URL: Points to production Render API
  String get _baseUrl {
    return 'https://nexus-gateway-api.onrender.com';
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _authService.getIdToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── POST /api/scan ─────────────────────────────────────────────────────────
  Future<ScanResult> scanMedia(PlatformFile file) async {
    final uri = Uri.parse('$_baseUrl/api/scan');
    final headers = await _authHeaders();

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.bytes!,
        filename: file.name,
      ));
    } else if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path!,
        filename: file.name,
      ));
    } else {
      throw Exception('Could not read file: no bytes or path available.');
    }

    try {
      // 90s timeout: Render free tier can take up to 50s to cold-start,
      // plus up to 30s for AI inference.
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 90),
      );
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('[API] POST /api/scan → ${response.statusCode}');
      debugPrint('[API] Body preview: ${response.body.substring(0, response.body.length.clamp(0, 200))}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanResult.fromJson(json);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Auth token expired or missing — NOT a connection error
        throw Exception('Session expired. Please sign out and sign in again.');
      } else {
        // Try to get the backend detail message
        String detail = 'Scan failed (HTTP ${response.statusCode})';
        try {
          final errJson = jsonDecode(response.body) as Map<String, dynamic>;
          detail = errJson['detail']?.toString() ??
              errJson['message']?.toString() ??
              detail;
        } catch (_) {
          // body wasn't JSON — use raw
          detail = 'Backend error ${response.statusCode}: ${response.body.substring(0, response.body.length.clamp(0, 120))}';
        }
        throw Exception(detail);
      }
    } on TimeoutException {
      throw TimeoutException(
        'Waking up secure gateway, please wait...\n'
        'The server is starting up. Try again in a moment.',
      );
    }
  }

  // ── GET /api/scan ──────────────────────────────────────────────────────────
  Future<List<ScanResult>> getScanHistory(
      {int page = 1, int pageSize = 10, String? mediaType}) async {
    String url = '$_baseUrl/api/scan?page=$page&page_size=$pageSize';
    if (mediaType != null && mediaType != 'all') {
      url += '&media_type=$mediaType';
    }
    final uri = Uri.parse(url);
    final headers = await _authHeaders();
    try {
      final response = await http.get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final scans = json['scans'] as List<dynamic>;
        return scans
            .map((s) => ScanResult.fromJson(s as Map<String, dynamic>))
            .toList();
      }
    } on TimeoutException {
      debugPrint('getScanHistory: gateway waking up, returning empty list');
    } catch (e) {
      debugPrint('getScanHistory error: $e');
    }
    return [];
  }

  // ── GET /api/scan/stats ────────────────────────────────────────────────────
  /// Mirrors React's `getScanStats()`. Falls back gracefully if the endpoint
  /// doesn't exist yet.
  Future<ScanStats?> getScanStats() async {
    try {
      final uri = Uri.parse('$_baseUrl/api/scan/stats/summary');
      final headers = await _authHeaders();
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanStats.fromJson(json);
      }
    } catch (e) {
      debugPrint('getScanStats error: $e');
    }
    return null;
  }

  // ── GET /api/scan — total count (for pagination) ───────────────────────────
  Future<int> getScanTotal({String? mediaType}) async {
    try {
      String url = '$_baseUrl/api/scan?page=1&page_size=1';
      if (mediaType != null && mediaType != 'all') {
        url += '&media_type=$mediaType';
      }
      final uri = Uri.parse(url);
      final headers = await _authHeaders();
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return (json['total'] ?? 0) as int;
      }
    } catch (_) {}
    return 0;
  }
}
