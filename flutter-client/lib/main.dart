import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/api_docs_screen.dart';

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
        scaffoldBackgroundColor: Colors.black, // Pure black background
        textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white, // White primary
          secondary: Colors.white, // White secondary
          surface: Colors.black,
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(true),
          thickness: WidgetStateProperty.all(10),
          radius: const Radius.circular(20),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.dragged)) {
              return Colors.white; // Bright white on interaction
            }
            return Colors.white.withAlpha(120); // Semi-transparent white idle
          }),
          crossAxisMargin: 4,
          minThumbLength: 50,
        ),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: true,
      ),
      builder: (context, child) {
        return GlobalCursorWrapper(child: child!);
      },
      // Use AuthWrapper as the home
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/api_docs': (context) => const ApiDocsScreen(),
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
              child: CircularProgressIndicator(color: Colors.white),
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

class GlobalCursorWrapper extends StatefulWidget {
  final Widget child;
  const GlobalCursorWrapper({super.key, required this.child});

  @override
  State<GlobalCursorWrapper> createState() => _GlobalCursorWrapperState();
}

class _GlobalCursorWrapperState extends State<GlobalCursorWrapper> {
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => _mousePosition = event.position),
      child: Stack(
        children: [
          widget.child,
          // Global flashlight / cursor glow effect
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCubic,
            left: _mousePosition.dx - 300,
            top: _mousePosition.dy - 300,
            child: IgnorePointer(
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withAlpha(50), // Brighter central glow for text flashing
                      Colors.white.withAlpha(10), // Soft mid glow
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverGlowText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  
  const HoverGlowText(this.text, {super.key, required this.style, this.textAlign});

  @override
  State<HoverGlowText> createState() => _HoverGlowTextState();
}

class _HoverGlowTextState extends State<HoverGlowText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: widget.style.copyWith(
          shadows: _isHovered ? [
            Shadow(color: Colors.white.withAlpha(100), blurRadius: 10),
            Shadow(color: Colors.white.withAlpha(50), blurRadius: 30),
          ] : [],
        ),
        textAlign: widget.textAlign ?? TextAlign.left,
        child: Text(widget.text),
      ),
    );
  }
}
