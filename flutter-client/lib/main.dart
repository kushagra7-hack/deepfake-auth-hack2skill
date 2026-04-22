import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NexusGatewayApp());
}

class NexusGatewayApp extends StatelessWidget {
  const NexusGatewayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Gateway',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030303), // Deep black background
        textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFCC), // Neon cyan/green
          secondary: Color(0xFF00BFFF), // Neon blue
          surface: Color(0xFF030303),
        ),
        useMaterial3: true,
      ),
      // Use AuthWrapper as the home
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the connection is busy, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00FFCC)),
            ),
          );
        }
        
        // If a user is actively authenticated, straight to dashboard.
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        // If not, send them back to zero-trust gateway.
        return const LandingScreen();
      },
    );
  }
}
