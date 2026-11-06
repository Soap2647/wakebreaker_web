import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/landing_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const WakeBreakerWeb());
}

class WakeBreakerWeb extends StatelessWidget {
  const WakeBreakerWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WakeBreaker — No Excuses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgBlack,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: AppColors.neonPurple,
          secondary: AppColors.softPurple,
          surface: AppColors.bgCard,
          onSurface: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.neonPurple,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected) ? AppColors.neonPurple : Colors.transparent),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
          ),
          textStyle: GoogleFonts.outfit(color: Colors.white70, fontSize: 12),
        ),
      ),
      home: const LandingPage(),
    );
  }
}