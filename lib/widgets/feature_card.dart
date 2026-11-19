import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

// --- 1. MODEL TANIMI BURADA YAPILIYOR ---
// Diğer sayfalar bu dosyayı import edince bu sınıfı da kullanabilecek.
class FeatureModel {
  final IconData icon;
  final String title;
  final String shortDesc;
  final String longDesc;

  FeatureModel({
    required this.icon,
    required this.title,
    required this.shortDesc,
    required this.longDesc,
  });
}

// --- 2. KART TASARIMI ---
class FeatureCard extends StatefulWidget {
  final FeatureModel feature;
  final VoidCallback onTap;
  final bool isMobile;
  final int index; // Added index

  const FeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
    this.isMobile = false,
    required this.index,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Defines
    const primaryColor = AppColors.neonPink;
    const secondaryColor = AppColors.softPurple;
    
    return GestureDetector(
      onTap: () {
        if (widget.isMobile) {
          setState(() => _isHovered = !_isHovered);
          widget.onTap();
        } else {
          widget.onTap();
        }
      },
      child: MouseRegion(
        onEnter: widget.isMobile ? null : (_) => setState(() => _isHovered = true),
        onExit: widget.isMobile ? null : (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 340, // Slightly wider
          transform: Matrix4.translationValues(0, _isHovered ? -15.0 : 0.0, 0),
          decoration: BoxDecoration(
            // Glass effect
            color: _isHovered 
                ? const Color(0xFF1A1A1A).withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.03), 
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _isHovered 
                  ? primaryColor.withValues(alpha: 0.5) 
                  : Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: secondaryColor.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, -10),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                ],
          ),
          child: Stack(
            children: [
              // Arka plan indeks numarası
              Positioned(
                right: -20,
                bottom: -20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isHovered ? 0.05 : 0.0,
                  child: Text(
                    "0${widget.index + 1}",
                    style: GoogleFonts.outfit(
                      fontSize: 180,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Kart İçeriği
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: _isHovered
                              ? const LinearGradient(colors: [AppColors.neonPink, AppColors.softPurple])
                              : LinearGradient(colors: [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.05)]),
                          ),
                          child: Icon(
                            widget.feature.icon, 
                            size: 32, 
                            color: _isHovered ? Colors.white : primaryColor
                          ),
                        ),
                        if (_isHovered)
                          Icon(Icons.arrow_outward_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20)
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    Text(
                      widget.feature.title, 
                      style: GoogleFonts.outfit(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5
                      )
                    ),
                    
                    const SizedBox(height: 15),
                    
                    Text(
                      widget.feature.longDesc, // Using longDesc for more meat on the card usually
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: Colors.white60, 
                        height: 1.6,
                        fontSize: 16,
                        fontWeight: FontWeight.w300
                      )
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