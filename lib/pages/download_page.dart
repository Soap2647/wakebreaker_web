import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.download_done, size: 80, color: Colors.white),
          const SizedBox(height: 30),
          Text("Beta Sürümü Yayında", style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text("Platformunu seç ve hemen başla.", style: GoogleFonts.outfit(fontSize: 18, color: Colors.white54)),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
               _storeButton(FontAwesomeIcons.apple, "App Store", "İndir"),
               _storeButton(FontAwesomeIcons.googlePlay, "Google Play", "İndir"),
            ],
          ),
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text("Tarat ve İndir", style: GoogleFonts.outfit(color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _storeButton(IconData icon, String storeName, String text) {
    return ElevatedButton.icon(
      onPressed: (){},
      icon: FaIcon(icon, color: Colors.black),
      label: Text("$storeName'dan $text", style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
    );
  }
}