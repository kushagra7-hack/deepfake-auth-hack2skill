import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Email / Password ────────────────────────────────────────────────────────

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException("Connection timed out."));
    return result;
  }

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException("Connection timed out."));
    return result;
  }

  // ── Google Sign-In ──────────────────────────────────────────────────────────

  /// Triggers the Google Sign-In consent screen, exchanges tokens with Firebase,
  /// and returns the resulting [UserCredential].
  ///
  /// On Web, uses the redirect-based popup flow via [signInWithPopup].
  /// On mobile, uses the package-based interactive flow.
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Web: use the Firebase built-in popup
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.addScope('profile');
      // No aggressive timeout here, as the user interacting with the Google popup can take longer than 10s.
      return await _auth.signInWithPopup(provider);
    }

    // Mobile/Desktop: use google_sign_in package
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) return null; // user cancelled

    final GoogleSignInAuthentication gAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    // Remove aggressive timeout here for the same reason.
    return await _auth.signInWithCredential(credential);
  }

  // ── Session ─────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      // Also sign out of Google session if it was used
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }

  /// Returns the current Firebase ID token for backend authorization.
  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }
}
