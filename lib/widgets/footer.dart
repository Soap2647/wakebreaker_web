import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: Colors.black,
      child: Column(
        children: [
          // Logo & Slogan
          const Icon(Icons.bolt, size: 40, color: Color(0xFFA480F2)),
          const SizedBox(height: 20),
          Text(
            "WakeBreaker",
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Mazeret Yok. Sadece Sonuç.",
            style: GoogleFonts.outfit(color: Colors.white38, letterSpacing: 1),
          ),
          
          const SizedBox(height: 60),
          
          // Links
          Wrap(
            spacing: 40,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _footerLink("GİZLİLİK"),
              _footerLink("KULLANIM ŞARTLARI"),
              _footerLink("İLETİŞİM"),
              _footerLink("PRESS KIT"),
            ],
          ),
          
          const SizedBox(height: 60),
          
          // Copyright
          Text(
            "© 2026 WakeBreaker Inc.",
            style: GoogleFonts.outfit(color: Colors.white12, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text, 
        style: GoogleFonts.outfit(
          color: Colors.white54, 
          fontSize: 12, 
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5
        )
      ),
    );
  }
}
