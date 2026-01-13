import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/feature_card.dart'; 
import '../widgets/footer.dart';

import 'download_page.dart';
import 'story_page.dart';
import 'features_page.dart'; // Artık bu dosya var olduğu için hata vermeyecek!

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentPageIndex = 0; 

  final List<FeatureModel> _features = [
    FeatureModel(
      icon: Icons.directions_walk,
      title: "Ghost Walk",
      shortDesc: "Alarmı susturmak için yataktan kalkıp 15 metre yürümeniz gerekir.",
      longDesc: "Ghost Walk, WakeBreaker'ın en acımasız modudur...", 
    ),
    FeatureModel(
      icon: Icons.calculate,
      title: "Brain Wake",
      shortDesc: "Zihninizi açmak için zorlu matematik problemlerini çözün.",
      longDesc: "Uyku sersemliğini yenmenin en iyi yolu...",
    ),
    FeatureModel(
      icon: Icons.monetization_on,
      title: "Wake Economy",
      shortDesc: "Erken kalktıkça WakeCoin kazanın.",
      longDesc: "Disiplin ödüllendirilmelidir...",
    ),
    FeatureModel(
      icon: Icons.shield,
      title: "Anti-Cheat",
      shortDesc: "Telefonu kapatmayı veya sesi kısmayı engeller.",
      longDesc: "Sabah uykulu haliniz, en zeki düşmanınızdır...",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isMobile = size.width < 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Dynamic Background Layers
          // Deep nebulas / gradients
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.8, -0.6), // Top left-ish
                  radius: 1.2,
                  colors: [
                    Color(0xFF2E1065), // Deep purple
                    Color(0xFF000000),
                  ],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.8, 0.3), // Mid right
                  radius: 0.8,
                  colors: [
                    Color(0xFF4A044E), // Deep pink/magenta
                    Color(0xFF000000),
                  ],
                  stops: [0.0, 0.6],
                ),
              ),
            ),
          ),
          // Subtle noise texture or pattern (optional, using network image for now with low opacity)
          Positioned.fill(
             child: Opacity(
               opacity: 0.03,
               child: Image.network(
                 "https://www.transparenttextures.com/patterns/stardust.png", // Example noise/texture
                 repeat: ImageRepeat.repeat,
                 errorBuilder: (c, e, s) => Container(), // Fail gracefully
               ),
             ),
          ),

          // 2. Content
          Column(
            children: [
              Navbar(
                isDesktop: isDesktop,
                onNavTap: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Add top spacing for navbar
                      const SizedBox(height: 20),
                      _buildPageContent(isDesktop, isMobile),
                      const SizedBox(height: 100), // Spacing before footer
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(bool isDesktop, bool isMobile) {
    switch (_currentPageIndex) {
      case 0: // Ana Sayfa
        return Column(
          children: [
            HeroSection(isDesktop: isDesktop),
            _buildFeaturesSection(isMobile),
          ],
        );
      case 1: // Hikayemiz
        return const SizedBox(
          height: 600,
          child: StoryPage(),
        );
      case 2: // ÖZELLİKLER SAYFASI
        return FeaturesPage(); 
      case 3: // İndir
        return const SizedBox(
          height: 600,
          child: DownloadPage(),
        );
      default:
        return Container();
    }
  }

  Widget _buildFeaturesSection(bool isMobile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          Text(
            "NEDEN WAKEBREAKER?",
            style: GoogleFonts.outfit(
                color: const Color(0xFFA480F2),
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontSize: 14),
          ),
          const SizedBox(height: 15),
          Text(
            "Mazeretleri Yok Et.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
                fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 80),
          _buildFeatureGridView(isMobile)
        ],
      ),
    );
  }

  Widget _buildFeatureGridView(bool isMobile) {
    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: List.generate(_features.length, (index) {
        return FeatureCard(
          feature: _features[index],
          isMobile: isMobile,
          onTap: () {
            setState(() {
              _currentPageIndex = 2; 
            });
          },
        );
      }),
    );
  }
}