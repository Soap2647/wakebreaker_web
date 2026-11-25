import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../theme/app_colors.dart';

// --- KALAVYE NAVIGASYON INTENT'LERİ ---
class PrevPageIntent extends Intent { const PrevPageIntent(); }
class NextPageIntent extends Intent { const NextPageIntent(); }

// --- ANA WIDGET ---
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // 0: Home, 1: Features, 2: Story, 3: Contact, 4: Download
  int _currentIndex = 0;
  bool isTurkish = true;

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _showStickyCTA = false;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        _scrollOffset = offset;
      });
      
      if (offset > 400 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (offset <= 400 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }

      if (offset > 800 && !_showStickyCTA) {
        setState(() => _showStickyCTA = true);
      } else if (offset <= 800 && _showStickyCTA) {
        setState(() => _showStickyCTA = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): const PrevPageIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextPageIntent(),
        },
        actions: {
          PrevPageIntent: CallbackAction<PrevPageIntent>(onInvoke: (_) {
            if (_currentIndex > 0) _changePage(_currentIndex - 1);
            return null;
          }),
          NextPageIntent: CallbackAction<NextPageIntent>(onInvoke: (_) {
            if (_currentIndex < 4) _changePage(_currentIndex + 1);
            return null;
          }),
        },
        child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _ParallaxDotsPainter(offset: _scrollOffset * 0.3),
            ),
          ),
          
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [AppColors.darkerPurple.withValues(alpha: 0.3), AppColors.bgBlack.withValues(alpha: 0.95)],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          // Sayfa içeriği
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: isDesktop ? 100 : 80),
                  child: Column(
                    children: [
                      // Sayfa geçiş animasyonu
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.04),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: KeyedSubtree(
                          key: ValueKey<int>(_currentIndex),
                          child: _buildPageContent(isDesktop),
                        ),
                      ),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sabit Navbar (yazım)
          Navbar(
            isDesktop: isDesktop,
            currentIndex: _currentIndex,
            isTurkish: isTurkish,
            onNavTap: _changePage,
            onLangToggle: () => setState(() => isTurkish = !isTurkish),
          ),

          // Scroll To Top Butonu
          if (_showScrollToTop)
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                onPressed: () {
                  _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutBack);
                },
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
            ),
            
          // Sticky CTA Banner (sol alt)
          if (_showStickyCTA && isDesktop && _currentIndex != 4)
            Positioned(
              bottom: 30,
              left: 40,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20)
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.neonPurple),
                    const SizedBox(width: 12),
                    Text(
                      isTurkish ? "Disiplin Seni Bekliyor" : "Discipline Awaits",
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () => _changePage(4),
                      child: Text(isTurkish ? "Hemen İndir" : "Download Now"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildPageContent(bool isDesktop) {
    switch (_currentIndex) {
      case 0:
        return _HomeView(isTurkish: isTurkish, isDesktop: isDesktop, onNavigateToFeatures: () => _changePage(1));
      case 1:
        return _FeaturesView(isTurkish: isTurkish, isDesktop: isDesktop);
      case 2:
        return _StoryView(isTurkish: isTurkish);
      case 3:
        return _ContactView(isTurkish: isTurkish, onNavigateToContact: () => _changePage(3));
      case 4:
        return _DownloadView(isTurkish: isTurkish);
      default:
        return _HomeView(isTurkish: isTurkish, isDesktop: isDesktop, onNavigateToFeatures: () => _changePage(1));
    }
  }

  // --- FOOTER ---
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      width: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          // Logo & slogan
          const Icon(Icons.bolt_rounded, size: 36, color: AppColors.neonPurple),
          const SizedBox(height: 12),
          Text("WakeBreaker",
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          Text(
            isTurkish ? "Mazeret Yok. Sadece Sonuç." : "No Excuses. Only Results.",
            style: GoogleFonts.robotoMono(color: Colors.white38, fontSize: 12, letterSpacing: 1),
          ),
          const SizedBox(height: 36),

          // Footer linkleri
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _footerLink(isTurkish ? "GİZLİLİK" : "PRIVACY", () => _launchMailto()),
              _footerLink(isTurkish ? "KULLANIM ŞARTLARI" : "TERMS", () => _showTermsDialog()),
              _footerLink(isTurkish ? "İLETİŞİM" : "CONTACT", () => setState(() => _currentIndex = 3)),
              _footerLink("GITHUB", () => _launchUrl("https://github.com/Soap2647")),
            ],
          ),
          const SizedBox(height: 36),

          // Sosyal medya
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(FontAwesomeIcons.instagram, "Instagram", "https://instagram.com/mertyasinyilmaz"),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.twitter, "Twitter / X", "https://twitter.com"),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.linkedinIn, "LinkedIn", "https://linkedin.com/in/mertyasinyilmaz"),
              const SizedBox(width: 20),
              _socialIcon(FontAwesomeIcons.github, "GitHub", "https://github.com/Soap2647"),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            isTurkish ? "© 2026 WakeBreaker. Disiplinle kodlandı." : "© 2026 WakeBreaker. Coded with discipline.",
            style: GoogleFonts.robotoMono(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String label, String url) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.02),
          ),
          child: FaIcon(icon, color: AppColors.textWhite, size: 18),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _launchMailto() {
    _launchUrl('mailto:mertyasinyilmaz@example.com?subject=WakeBreaker');
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isTurkish ? "Kullanım Şartları" : "Terms of Use",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          isTurkish
              ? "WakeBreaker'ı kullanarak hiçbir verinin üçüncü taraflarla paylaşılmadığını kabul edersiniz. Uygulama kişisel verilerinizi toplamaz ve işlemez."
              : "By using WakeBreaker, you acknowledge that no data is shared with third parties. The app does not collect or process your personal data.",
          style: GoogleFonts.outfit(color: Colors.white70, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isTurkish ? "Kapat" : "Close",
                style: GoogleFonts.outfit(color: AppColors.neonPurple, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 1. SAYFA: ANA SAYFA (HOME VIEW)
// ---------------------------------------------------------
class _HomeView extends StatelessWidget {
  final bool isTurkish;
  final bool isDesktop;
  final VoidCallback onNavigateToFeatures;
  const _HomeView({required this.isTurkish, required this.isDesktop, required this.onNavigateToFeatures});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HeroSection
        HeroSection(isDesktop: isDesktop, isTurkish: isTurkish),
        const SizedBox(height: 40),

        // Live Stats & Snooze Counter (YENİ)
        _StatsAndSnoozeWidget(isTurkish: isTurkish, isDesktop: isDesktop),
        const SizedBox(height: 20),

        // Explore CTA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton.icon(
            onPressed: onNavigateToFeatures,
            icon: const Icon(Icons.arrow_downward_rounded),
            label: Text(isTurkish ? "Sistemi Keşfet" : "Explore the System"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 28),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              elevation: 20,
              shadowColor: AppColors.neonPurple.withValues(alpha: 0.5),
              textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ),

        // Güven & Gizlilik bölümü
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          padding: EdgeInsets.all(isDesktop ? 80 : 40),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.12), blurRadius: 50, spreadRadius: -10),
            ],
          ),
          child: Column(
            children: [
              const FaIcon(FontAwesomeIcons.userShield, size: 50, color: AppColors.neonPurple),
              const SizedBox(height: 30),
              Text(
                isTurkish ? "VERİLERİNİZ SATILIK DEĞİL" : "YOUR DATA IS NOT FOR SALE",
                style: GoogleFonts.robotoMono(
                    color: AppColors.neonPurple, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Text(
                  isTurkish
                      ? "Şeffaflık bir seçenek değil, temel prensibimizdir. WakeBreaker, kişisel verilerinizi, uyku alışkanlıklarınızı veya konum geçmişinizi asla sunucularına kaydetmez. Davranışsal profilleme veya gizli analiz algoritmaları kullanmıyoruz. Bizim tek odak noktamız sizin sabah uyanmanızdır."
                      : "Transparency is not an option, it is our fundamental principle. WakeBreaker never records, processes, or sells your personal data. We do not use behavioral profiling. Our sole focus is your morning wake-up.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 18, color: Colors.white70, height: 1.8, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 40),
              Tooltip(
                message: 'GitHub: Soap2647',
                child: InkWell(
                  onTap: () async {
                    const url = 'https://github.com/Soap2647';
                    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
                      debugPrint('Could not launch $url');
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.github, color: Colors.white54, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          isTurkish ? "GitHub: Temel Mimari >" : "GitHub: Core Architecture >",
                          style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

// ---------------------------------------------------------
// İSTATİSTİK VE CANLI SNOOZE SAYACI (YENİ EKLENTİ)
// ---------------------------------------------------------
class _StatsAndSnoozeWidget extends StatefulWidget {
  final bool isTurkish;
  final bool isDesktop;
  const _StatsAndSnoozeWidget({required this.isTurkish, required this.isDesktop});

  @override
  State<_StatsAndSnoozeWidget> createState() => _StatsAndSnoozeWidgetState();
}

class _StatsAndSnoozeWidgetState extends State<_StatsAndSnoozeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _countAnimation;
  
  // Fake live counter
  int _snoozeCount = 1284920441;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _countAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _controller.forward();

    // Live snooze ticker
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 2300));
      if (mounted) {
        setState(() => _snoozeCount += (1 + (DateTime.now().millisecond % 3)));
      }
      return mounted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: widget.isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildStatsRow()),
                const SizedBox(width: 40),
                _buildLiveSnoozeCard(),
              ],
            )
          : Column(
              children: [
                _buildLiveSnoozeCard(),
                const SizedBox(height: 40),
                _buildStatsRow(),
              ],
            ),
    );
  }

  Widget _buildStatsRow() {
    return AnimatedBuilder(
      animation: _countAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statItem((2400 * _countAnimation.value).toInt().toString() + "+", widget.isTurkish ? "Aktif Kullanıcı" : "Active Users"),
            _statItem((4.8 * _countAnimation.value).toStringAsFixed(1) + "★", "App Store"),
            _statItem("%" + (94 * _countAnimation.value).toInt().toString(), widget.isTurkish ? "İlk Alarm Başarısı" : "First Alarm Success"),
          ],
        );
      }
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: widget.isDesktop ? 36 : 28, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.robotoMono(fontSize: widget.isDesktop ? 14 : 12, color: AppColors.softPurple)),
      ],
    );
  }

  Widget _buildLiveSnoozeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(color: AppColors.neonPink.withValues(alpha: 0.05), blurRadius: 30, spreadRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                widget.isTurkish ? "CANLI: Bu ay ertelenen alarm" : "LIVE: Snoozed alarms this month",
                style: GoogleFonts.robotoMono(fontSize: 12, color: Colors.white54, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _snoozeCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.neonPink, letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. SAYFA: ÖZELLİKLER (FEATURES VIEW)
// ---------------------------------------------------------
class _FeaturesView extends StatelessWidget {
  final bool isTurkish;
  final bool isDesktop;
  const _FeaturesView({required this.isTurkish, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureData(
        index: 0,
        icon: FontAwesomeIcons.personWalkingArrowRight,
        title: "Ghost Walk",
        subtitle: isTurkish ? "Fiziksel Doğrulama Protokolü" : "Physical Verification Protocol",
        desc: isTurkish
            ? "WakeBreaker'ın amiral gemisi özelliği. Alarmı susturmanın tek yolu, yatağınızdan fiziksel olarak kalkmak ve ivmeölçer/GPS sensörleri tarafından doğrulanan belirli bir mesafeyi (örn. 20 adım) yürümektir. Mazeret kabul edilmez."
            : "WakeBreaker's flagship feature. The only way to silence the alarm is to physically get out of bed and walk a specific distance (e.g., 20 steps), verified by accelerometer/GPS sensors. No excuses accepted.",
      ),
      _FeatureData(
        index: 1,
        icon: FontAwesomeIcons.brain,
        title: "Brain Wake",
        subtitle: isTurkish ? "Bilişsel Uyanış Modu" : "Cognitive Awakening Mode",
        desc: isTurkish
            ? "Bilişsel uyanış protokolü. Bu özellik, beynin mantık ve karar verme merkezi olan prefrontal korteksi aktive etmek için rastgele üretilen matematiksel veya mantıksal problemler sunar. Güne sisli bir zihinle değil, keskin bir odaklanmayla başlayın."
            : "This feature presents randomly generated, challenging mathematical or logical problems to activate the prefrontal cortex. Start the day with sharp focus, not a foggy mind.",
      ),
      _FeatureData(
        index: 2,
        icon: FontAwesomeIcons.coins,
        title: "Wake Economy",
        subtitle: isTurkish ? "İrade Bazlı Ekonomi" : "Willpower Based Economy",
        desc: isTurkish
            ? "Davranışsal ekonomi prensiplerine dayanan bir motivasyon sistemi. Zamanında uyandığınız her sabah 'WakeCoin' kazanırsınız; ertelediğiniz her an ise bu kazançtan kaybedersiniz. Buradaki tek geçerli para birimi kendi iradenizdir."
            : "A motivational system based on behavioral economics. You earn 'WakeCoin' every morning you wake up on time. The only valid currency here is your own willpower.",
      ),
      _FeatureData(
        index: 3,
        icon: FontAwesomeIcons.shieldHalved,
        title: "Anti-Cheat System",
        subtitle: isTurkish ? "Sahte Uyanış Koruması" : "Fake Wake-up Protection",
        desc: isTurkish
            ? "Sabah uykulu haliniz en zeki düşmanınızdır; biz ondan daha zekiyiz. Gelişmiş sensör füzyon algoritmalarımız, telefonu sallama veya rastgele dokunuşlar gibi 'sahte uyanış' girişimlerini anında tespit eder. Kaçış yok, sadece uyanış var."
            : "Our advanced sensor fusion algorithms instantly detect and block 'fake wake-up' attempts. Even if you force stop the app, WakeBreaker knows the task isn't complete. There is no escape, only awakening.",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                isTurkish ? "SİSTEM ÖZELLİKLERİ" : "SYSTEM FEATURES",
                style: GoogleFonts.robotoMono(
                    color: AppColors.neonPurple, letterSpacing: 4, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              Text(
                isTurkish ? "Uyku Düşmanınızla Savaşmak için Tasarlandı" : "Engineered to Fight Your Sleep Enemy",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.white60, fontSize: 18, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 64),

              // Desktop: 2x2 grid, Mobil: tek kolon
              isDesktop
                  ? Column(
                      children: [
                        _featureRow(features[0], features[1]),
                        const SizedBox(height: 32),
                        _featureRow(features[2], features[3]),
                      ],
                    )
                  : Column(
                      children: features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: _buildFeatureCard(f),
                      )).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureRow(_FeatureData left, _FeatureData right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildFeatureCard(left)),
        const SizedBox(width: 32),
        Expanded(child: _buildFeatureCard(right)),
      ],
    );
  }

  Widget _buildFeatureCard(_FeatureData f) {
    return _FeatureCardWidget(data: f);
  }
}

class _FeatureData {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final String desc;
  const _FeatureData({required this.index, required this.icon, required this.title, required this.subtitle, required this.desc});
}

class _FeatureCardWidget extends StatefulWidget {
  final _FeatureData data;
  const _FeatureCardWidget({required this.data});
  @override
  State<_FeatureCardWidget> createState() => _FeatureCardWidgetState();
}

class _FeatureCardWidgetState extends State<_FeatureCardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translateByDouble(0.0, _hovered ? -8.0 : 0.0, 0.0, 1.0),
        padding: const EdgeInsets.all(44),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFF111118) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _hovered ? AppColors.neonPurple.withValues(alpha: 0.5) : AppColors.neonPurple.withValues(alpha: 0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered ? AppColors.neonPurple.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.5),
              blurRadius: _hovered ? 40 : 20,
              offset: const Offset(0, 12),
              spreadRadius: _hovered ? -5 : -5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Arka Plan Indeksi
            Positioned(
              right: -30,
              bottom: -40,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _hovered ? 0.05 : 0.0,
                child: Text(
                  "0${widget.data.index + 1}",
                  style: GoogleFonts.outfit(
                    fontSize: 180,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
            
            // Asıl İçerik
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _hovered ? AppColors.neonPurple.withValues(alpha: 0.2) : AppColors.neonPurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.neonPurple.withValues(alpha: _hovered ? 0.6 : 0.2)),
                  ),
                  child: FaIcon(widget.data.icon, color: AppColors.neonPurple, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.title,
                          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(widget.data.subtitle,
                          style: GoogleFonts.robotoMono(fontSize: 12, color: AppColors.neonPurple, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.data.desc,
              style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textLight, height: 1.75, fontWeight: FontWeight.w300),
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. SAYFA: HİKAYEMİZ (STORY VIEW)
// ---------------------------------------------------------
class _StoryView extends StatelessWidget {
  final bool isTurkish;
  const _StoryView({required this.isTurkish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MİSYON
              Center(
                child: Text(
                  isTurkish ? "MİSYONUMUZ" : "OUR MISSION",
                  style: GoogleFonts.robotoMono(color: AppColors.neonPurple, fontWeight: FontWeight.w900, letterSpacing: 3),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  isTurkish ? "Mazeretleri Yok Et." : "Eliminate Excuses.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white, height: 1),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                isTurkish
                    ? "WakeBreaker sadece bir alarm uygulaması değildir; bir disiplin aracıdır. Modern 'erteleme' kültürüne ve sabahları kendi potansiyelimizden çalmamıza neden olan konfor tuzağına karşı bir duruştur. Sıradan alarmlar sizinle pazarlık yapar. WakeBreaker pazarlık yapmaz. Amacımız, size sabahlarınızı ve dolayısıyla gününüzü geri vermektir."
                    : "WakeBreaker is not just an alarm app; it is a discipline tool. It is a stance against the modern 'snooze' culture. Ordinary alarms negotiate, WakeBreaker does not. Our goal is to give your mornings back, and therefore your entire day.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 20, color: const Color(0xFFB0B0B0), height: 1.7, fontWeight: FontWeight.w300),
              ),

              const SizedBox(height: 100),

              const SizedBox(height: 100),

              // HİKAYE - TIMELINE
              Text(
                isTurkish ? "HİKAYEMİZ" : "OUR STORY",
                style: GoogleFonts.robotoMono(color: AppColors.neonPurple, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 20),
              Text(
                isTurkish ? "Vize Haftasında Başlayan Bir İhtiyaç." : "Born During Exam Week.",
                style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 60),

              // TIMELINE WIDGET
              _buildTimelineStep(
                date: isTurkish ? "Ocak 2024" : "Jan 2024",
                title: isTurkish ? "Kriz Anı" : "The Crisis",
                content: isTurkish 
                  ? "Bilgisayar Mühendisliği vize haftası. Sadece 2 saat uyuyabilecektim ama uyanamama korkusu yüzünden o iki saati uykuya dalmaya çalışırken uyanık geçirdim. Sıradan alarmlara güvenmiyordum."
                  : "Computer Engineering midterm week. I only had 2 hours to sleep, but I was so afraid of not waking up that I couldn't sleep at all. I didn't trust ordinary alarms.",
                isLast: false,
              ),
              _buildTimelineStep(
                date: isTurkish ? "Şubat 2024" : "Feb 2024",
                title: isTurkish ? "İlk Prototip" : "First Prototype",
                content: isTurkish
                  ? "Kendi sorunumu çözmek için yatağımdan mecburen kalkıp 15 adım yürümeden kapanmayan basit bir Android servisi yazıp kendi telefonuma kurdum. O hafta hiç geç uyanmadım."
                  : "To solve my own problem, I wrote a simple Android service that wouldn't close until I literally got out of bed and walked 15 steps. I never woke up late that week.",
                isLast: false,
              ),
              _buildTimelineStep(
                date: isTurkish ? "Kasım 2025" : "Nov 2025",
                title: isTurkish ? "WakeBreaker Doğuyor" : "WakeBreaker is Born",
                content: isTurkish
                  ? "Abonelik dayatan, sahte 'uykunu analiz ediyoruz' yalanlarıyla veri toplayan karmaşık uygulamalara inat; sadece sonuç odaklı, tek seferlik satın almalı WakeBreaker mimarisi tasarlandı."
                  : "In defiance of complex apps that force subscriptions and lie about analyzing your sleep to steal data; the architecture for a one-time purchase, result-oriented WakeBreaker was designed.",
                isLast: false,
              ),
              _buildTimelineStep(
                date: isTurkish ? "2026" : "2026",
                title: isTurkish ? "Uyanış Devrimi" : "The Awakening Revolution",
                content: isTurkish
                  ? "Disiplin Seni Bekliyor."
                  : "Discipline Awaits.",
                isLast: true,
                isHighlight: true,
              ),

              const SizedBox(height: 80),

              // Founder kartı
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppColors.softPurple, AppColors.neonPink]),
                      ),
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.bgBlack,
                        child: Text("MY",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'RobotoMono')),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mert Yasin Yılmaz",
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Founder & Developer",
                            style: GoogleFonts.robotoMono(color: AppColors.neonPurple, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text("Computer Engineering Student",
                            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13)),
                      ],
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

  Widget _buildTimelineStep({required String date, required String title, required String content, required bool isLast, bool isHighlight = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Çizgi ve Nokta
          Column(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHighlight ? AppColors.neonPink : AppColors.bgBlack,
                  border: Border.all(color: isHighlight ? AppColors.neonPink : AppColors.neonPurple, width: 3),
                  boxShadow: isHighlight ? [BoxShadow(color: AppColors.neonPink.withValues(alpha: 0.4), blurRadius: 10)] : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.neonPurple.withValues(alpha: 0.5),
                          AppColors.neonPurple.withValues(alpha: 0.1),
                        ]
                      )
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 30),
          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: GoogleFonts.robotoMono(color: AppColors.softPurple, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(content, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, height: 1.6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. SAYFA: İLETİŞİM (CONTACT VIEW)
// ---------------------------------------------------------
class _ContactView extends StatefulWidget {
  final bool isTurkish;
  final VoidCallback onNavigateToContact;
  const _ContactView({required this.isTurkish, required this.onNavigateToContact});

  @override
  State<_ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<_ContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String? _messageType;
  bool _kvkkAccepted = false;
  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isDesktop ? 0 : 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.05), blurRadius: 30),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.isTurkish ? "BİZİMLE İLETİŞİME GEÇİN" : "CONTACT US",
                        style: GoogleFonts.robotoMono(
                            color: AppColors.neonPurple, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isTurkish
                            ? "Mesajınız gerçek e-postamıza iletilecektir."
                            : "Your message will be forwarded to our real email.",
                        style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                _buildLabel(widget.isTurkish ? "İsim Soyisim" : "Full Name"),
                _buildTextField(controller: _nameController, icon: FontAwesomeIcons.user),
                const SizedBox(height: 25),

                _buildLabel(widget.isTurkish ? "E-posta Adresi" : "Email Address"),
                _buildTextField(controller: _emailController, icon: FontAwesomeIcons.envelope, isEmail: true),
                const SizedBox(height: 25),

                _buildLabel(widget.isTurkish ? "Konu" : "Subject"),
                _buildDropdown(),
                const SizedBox(height: 25),

                _buildLabel(widget.isTurkish ? "Mesajınız" : "Your Message"),
                _buildTextField(controller: _messageController, icon: FontAwesomeIcons.comment, maxLines: 5),
                const SizedBox(height: 30),

                // KVKK
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _kvkkAccepted,
                      onChanged: (val) => setState(() => _kvkkAccepted = val!),
                      activeColor: AppColors.neonPurple,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.white24),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          widget.isTurkish
                              ? "Kişisel verilerimin işlenmesine ilişkin aydınlatma metnini okudum ve kabul ediyorum."
                              : "I have read and accept the privacy policy regarding the processing of my personal data.",
                          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12, height: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Gönder
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _sending ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonPurple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.neonPurple.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 10,
                      shadowColor: AppColors.neonPurple.withValues(alpha: 0.4),
                      textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    icon: _sending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded),
                    label: Text(widget.isTurkish ? "Gönder" : "Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_kvkkAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isTurkish ? "Lütfen aydınlatma metnini onaylayın." : "Please accept the privacy policy."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (_messageType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isTurkish ? "Lütfen bir konu seçin." : "Please select a subject."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _sending = true);

    // mailto: ile gönderim
    final subject = Uri.encodeComponent('[WakeBreaker] ${_messageType ?? "Mesaj"}');
    final body = Uri.encodeComponent(
      'İsim: ${_nameController.text}\nE-posta: ${_emailController.text}\n\n${_messageController.text}',
    );
    final mailtoUrl = 'mailto:mertyasinyilmaz@example.com?subject=$subject&body=$body';

    try {
      await launchUrl(Uri.parse(mailtoUrl));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isTurkish ? "E-posta uygulamanız açıldı!" : "Your email app has been opened!"),
            backgroundColor: AppColors.neonPurple,
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        setState(() { _messageType = null; _kvkkAccepted = false; });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isTurkish ? "E-posta uygulaması bulunamadı." : "No email app found."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _messageType,
          hint: Text(widget.isTurkish ? "Seçiniz" : "Select",
              style: GoogleFonts.outfit(color: Colors.white38)),
          dropdownColor: const Color(0xFF111111),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.neonPurple),
          isExpanded: true,
          items: [
            DropdownMenuItem(value: "tavsiye", child: Text(widget.isTurkish ? "Tavsiye / Öneri" : "Suggestion")),
            DropdownMenuItem(value: "sikayet", child: Text(widget.isTurkish ? "Şikayet / Hata Bildirimi" : "Bug Report")),
            DropdownMenuItem(value: "diger", child: Text(widget.isTurkish ? "Diğer" : "Other")),
          ],
          onChanged: (val) => setState(() => _messageType = val),
          style: GoogleFonts.outfit(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(text, style: GoogleFonts.outfit(color: Colors.white70, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    bool isEmail = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.outfit(color: Colors.white),
      maxLines: maxLines,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return widget.isTurkish ? 'Bu alan zorunludur' : 'Required field';
        if (isEmail && !value.contains('@')) return widget.isTurkish ? 'Geçerli bir e-posta giriniz' : 'Enter a valid email';
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: FaIcon(icon, color: Colors.white24, size: 16),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: AppColors.neonPurple)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent)),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}

// ---------------------------------------------------------
// 5. SAYFA: İNDİR (DOWNLOAD VIEW)
// ---------------------------------------------------------
class _DownloadView extends StatefulWidget {
  final bool isTurkish;
  const _DownloadView({required this.isTurkish});

  @override
  State<_DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<_DownloadView> {
  final TextEditingController _waitlistController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitWaitlist() async {
    if (_waitlistController.text.isEmpty || !_waitlistController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isTurkish ? "Geçerli bir e-posta girin." : "Enter a valid email."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    // Fake API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSubmitting = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isTurkish ? "Bekleme listesine eklendiniz!" : "Added to the waitlist!"),
          backgroundColor: AppColors.neonPurple,
        ),
      );
      _waitlistController.clear();
    }
  }

  @override
  void dispose() {
    _waitlistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isDesktop ? 60 : 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.neonPurple.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.download_rounded, size: 56, color: AppColors.neonPurple),
              ),
              const SizedBox(height: 32),
              Text(
                widget.isTurkish ? "Uygulamayı İndir" : "Download the App",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isTurkish
                    ? "WakeBreaker yakında App Store ve Google Play'de! Beta sürecine katıl."
                    : "WakeBreaker is coming soon to the App Store and Google Play! Join the beta.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.white54, fontSize: 18, height: 1.6),
              ),
              const SizedBox(height: 60),

              const SizedBox(height: 60),

              // Store butonları
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _storeBtn(FontAwesomeIcons.apple, "App Store", widget.isTurkish ? "Yakında" : "Coming Soon", null),
                  _storeBtn(FontAwesomeIcons.googlePlay, "Google Play", widget.isTurkish ? "Ön Kayıt" : "Pre-Register", "https://play.google.com"),
                ],
              ),

              const SizedBox(height: 80),

              // Waitlist Form
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.bgBlack,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.05), blurRadius: 40),
                  ],
                ),
                child: Column(
                  children: [
                    FaIcon(FontAwesomeIcons.envelopeOpenText, color: AppColors.neonPurple, size: 40),
                    const SizedBox(height: 20),
                    Text(
                      widget.isTurkish ? "Bekleme Listesine Katıl" : "Join the Waitlist",
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isTurkish
                          ? "Yayınlandığında ilk senin haberin olsun. Asla spam yapmayız."
                          : "Be the first to know when we launch. No spam, ever.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.white54),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _waitlistController,
                            style: GoogleFonts.outfit(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: widget.isTurkish ? "E-posta adresiniz" : "Your email address",
                              hintStyle: GoogleFonts.outfit(color: Colors.white38),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.05),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.neonPurple)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 64,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitWaitlist,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neonPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(widget.isTurkish ? "Katıl" : "Join", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
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

  Widget _storeBtn(IconData icon, String store, String status, String? url) {
    return Tooltip(
      message: store,
      child: InkWell(
        onTap: url != null ? () async {
          final uri = Uri.parse(url);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            debugPrint('Could not launch $url');
          }
        } : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status.toUpperCase(),
                      style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  Text(store,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// PARALLAX BACKGROUND PAINTER
// ---------------------------------------------------------
class _ParallaxDotsPainter extends CustomPainter {
  final double offset;
  _ParallaxDotsPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonPurple.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    
    // Parallax kayması uyguluyoruz (y ekseninde offset)
    final dy = offset % spacing;

    for (double y = -spacing + dy; y < size.height + spacing; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParallaxDotsPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}