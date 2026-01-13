import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text("MİSYONUMUZ", style: GoogleFonts.outfit(color: const Color(0xFFA480F2), letterSpacing: 4, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(
              "Neden Uyanamıyoruz?",
              style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              "WakeBreaker, modern insanın en büyük düşmanı olan 'Erteleme' (Snooze) butonuna açılmış bir savaştır. Biz sadece bir alarm uygulaması değiliz; biz, sabahlarınızı geri kazanmanız için tasarlanmış bir disiplin aracıyız.\n\n"
              "Sıradan alarmlar sizinle pazarlık yapar. WakeBreaker yapmaz. Biz, teknolojiyi kullanarak insan iradesinin zayıf anlarını kapatıyor ve sizi potansiyelinizin zirvesinde güne başlatıyoruz.",
              style: GoogleFonts.outfit(fontSize: 18, color: Colors.white70, height: 1.8),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}