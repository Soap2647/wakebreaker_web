import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class HeroSection extends StatelessWidget {
  final bool isDesktop;

  const HeroSection({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 20,
        vertical: 60,
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: _buildHeroText()),
                const SizedBox(width: 40),
                Expanded(flex: 4, child: _buildAppMockup()),
              ],
            )
          : Column(
              children: [
                _buildHeroText(center: true),
                const SizedBox(height: 80),
                _buildAppMockup(),
              ],
            ),
    );
  }

  Widget _buildHeroText({bool center = false}) {
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFD946EF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD946EF).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD946EF).withOpacity(0.1),
                blurRadius: 15,
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFD946EF), size: 16),
              const SizedBox(width: 8),
              Text(
                "YENİ NESİL ALARM UYGULAMASI",
                style: GoogleFonts.outfit(
                  color: const Color(0xFFD946EF),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        
        // Massive Headline with Gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFA480F2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Uykuyu Kır.\nGünü İnşa Et.",
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.outfit(
              fontSize: isDesktop ? 96 : 64, // Massive size
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: Colors.white,
              letterSpacing: -2.0,
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        Text(
          "WakeBreaker, ertelemeyi imkansız kılan ve sizi %100 uyanık başlatan tek uygulama. Sabahları mazeret yok, sadece sonuç var.",
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.outfit(
            fontSize: isDesktop ? 22 : 18,
            color: Colors.white60,
            height: 1.6,
            fontWeight: FontWeight.w300
          ),
        ),
        const SizedBox(height: 50),
        
        // Buttons
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: center ? WrapAlignment.center : WrapAlignment.start,
          children: [
            _storeButton(FontAwesomeIcons.apple, "App Store", "Coming Soon"),
            _storeButton(FontAwesomeIcons.googlePlay, "Google Play", "Pre-Register"),
          ],
        ),
      ],
    );
  }

  Widget _buildAppMockup() {
    return Center(
      child: Transform.rotate(
        angle: -math.pi / 24,
        child: Container(
          width: 340,
          height: 680,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(55),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 8),
            boxShadow: [
              // Glow behind phone
              BoxShadow(
                color: const Color(0xFFA480F2).withOpacity(0.4),
                blurRadius: 100,
                spreadRadius: -20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Border Gradient
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(46),
                  gradient: const LinearGradient(
                     colors: [Color(0xFF333333), Colors.black],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                  )
                ),
              ),
              // Screen
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0F0518), Color(0xFF000000)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Pattern
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.network(
                              "https://www.transparenttextures.com/patterns/carbon-fibre.png",
                              repeat: ImageRepeat.repeat,
                            ),
                          ),
                        ),
                        
                        // Fake UI Elements
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFA480F2), width: 2),
                                  boxShadow: [
                                     BoxShadow(
                                       color: const Color(0xFFA480F2).withOpacity(0.2),
                                       blurRadius: 30
                                     )
                                  ]
                                ),
                                child: const Icon(Icons.bolt, size: 60, color: Colors.white),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "06:30",
                                style: GoogleFonts.outfit(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -2
                                ),
                              ),
                              Text(
                                "GHOST WALK AKTİF",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFA480F2),
                                  letterSpacing: 4,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Bottom Card
                        Positioned(
                          bottom: 40,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20,
                                )
                              ]
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA480F2).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: const Icon(Icons.directions_walk, color: Color(0xFFA480F2)),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Kalan Mesafe", style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text("15 Metre", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Dynamic Notch
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeButton(IconData icon, String storeName, String status) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.2),
               blurRadius: 10,
               offset: const Offset(0, 5),
             )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status.toUpperCase(), style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                Text(storeName, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
