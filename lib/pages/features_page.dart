import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/feature_card.dart'; // FeatureModel buradan geliyor

class FeaturesPage extends StatelessWidget {
  FeaturesPage({super.key});

  final List<FeatureModel> features = [
    FeatureModel(
      icon: Icons.directions_walk,
      title: "Ghost Walk",
      shortDesc: "Yataktan kalkıp yürümek zorundasın.",
      longDesc: "GPS ve ivmeölçer seni takip eder. 15 metre yürümeden o alarm susmaz. Yatağa geri dönersen sayaç sıfırlanır.",
    ),
    FeatureModel(
      icon: Icons.calculate,
      title: "Brain Wake",
      shortDesc: "Beynini 'ON' moduna getir.",
      longDesc: "Uyku sersemliğini atmak için rastgele üretilen zorlu matematik problemlerini çöz. Beynin uyanmadan alarm susmaz.",
    ),
    FeatureModel(
      icon: Icons.monetization_on,
      title: "Wake Economy",
      shortDesc: "Erken kalktıkça WakeCoin kazan.",
      longDesc: "Erteledikçe coin kaybet. Kendi uyanış ekonomini yönet, biriken paralarla yeni temalar ve özellikler satın al.",
    ),
    FeatureModel(
      icon: Icons.shield,
      title: "Anti-Cheat",
      shortDesc: "Hile yapamazsın.",
      longDesc: "Telefonu kapatsan, sesi kıssan veya uygulamayı zorla durdursan bile WakeBreaker geri döndüğünde kaldığı yerden devam eder.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Column(
          children: [
            Text(
              "TEKNOLOJİK DİSİPLİN",
              style: GoogleFonts.outfit(
                color: const Color(0xFFA480F2),
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tam Kontrol.",
              style: GoogleFonts.outfit(
                fontSize: isDesktop ? 56 : 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 80),
            ...List.generate(features.length, (index) {
              return _buildFeatureRow(context, features[index], index, isDesktop);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, FeatureModel feature, int index, bool isDesktop) {
    bool isImageRight = index % 2 == 0;
    
    if (!isDesktop) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            _buildVisual(feature, index),
            const SizedBox(height: 30),
            _buildTextContent(feature, index, alignLeft: false),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isImageRight 
                ? _buildTextContent(feature, index, alignLeft: true)
                : _buildVisual(feature, index),
          ),
          const SizedBox(width: 80),
          Expanded(
            child: isImageRight 
                ? _buildVisual(feature, index)
                : _buildTextContent(feature, index, alignLeft: true),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(FeatureModel feature, int index) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA480F2).withOpacity(0.1),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 20,
            bottom: -20,
            child: Text(
              "0${index + 1}",
              style: GoogleFonts.outfit(
                fontSize: 150,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: const Color(0xFFA480F2).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA480F2).withOpacity(0.2),
                  blurRadius: 30,
                )
              ]
            ),
            child: Icon(feature.icon, size: 60, color: const Color(0xFFA480F2)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(FeatureModel feature, int index, {required bool alignLeft}) {
    return Column(
      crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFA480F2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "#${index + 1} FEATURE",
            style: GoogleFonts.outfit(
              color: const Color(0xFFA480F2),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          feature.title,
          textAlign: alignLeft ? TextAlign.start : TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          feature.longDesc, 
          textAlign: alignLeft ? TextAlign.start : TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 18,
            color: Colors.white60,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}