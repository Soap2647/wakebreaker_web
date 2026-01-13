import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const WakeBreakerWeb());
}

class WakeBreakerWeb extends StatelessWidget {
  const WakeBreakerWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WakeBreaker - No Excuses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000), // Pure Black
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD946EF), // Neon Pink as primary for more pop
          secondary: Color(0xFFA480F2), // Purple accent
          surface: Color(0xFF0A0A0A), // Very dark grey, almost black
          onSurface: Colors.white,
        ),
        // Define default button themes here if needed, or keep it minimal
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA480F2),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}