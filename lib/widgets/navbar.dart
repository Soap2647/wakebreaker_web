import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

class Navbar extends StatelessWidget {
  final bool isDesktop;
  final int currentIndex;
  final bool isTurkish;
  final Function(int) onNavTap;
  final VoidCallback onLangToggle;

  const Navbar({
    super.key,
    required this.isDesktop,
    required this.currentIndex,
    required this.isTurkish,
    required this.onNavTap,
    required this.onLangToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: isDesktop ? 20 : 10, left: isDesktop ? 40 : 10, right: isDesktop ? 40 : 10),
          constraints: const BoxConstraints(maxWidth: 1200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 30 : 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Tooltip(
                      message: isTurkish ? 'Ana Sayfaya Dön' : 'Back to Home',
                      child: InkWell(
                        onTap: () => onNavTap(0),
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.softPurple, AppColors.neonPink],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.softPurple.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    spreadRadius: -2,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "WakeBreaker",
                              style: GoogleFonts.outfit(
                                fontSize: isDesktop ? 22 : 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Desktop menü
                    if (isDesktop)
                      Row(
                        children: [
                          _NavItem(label: isTurkish ? 'Ana Sayfa' : 'Home',    index: 0, currentIndex: currentIndex, onTap: onNavTap),
                          _NavItem(label: isTurkish ? 'Özellikler' : 'Features', index: 1, currentIndex: currentIndex, onTap: onNavTap),
                          _NavItem(label: isTurkish ? 'Hikayemiz' : 'Our Story', index: 2, currentIndex: currentIndex, onTap: onNavTap),
                          _NavItem(label: isTurkish ? 'İletişim' : 'Contact',   index: 3, currentIndex: currentIndex, onTap: onNavTap),
                          const SizedBox(width: 16),
                          _langButton(isTurkish, onLangToggle),
                          const SizedBox(width: 16),
                          _downloadButton(isTurkish, () => onNavTap(4)),
                        ],
                      )
                    else
                      // Mobil — sağ tarafta hamburger
                      Row(
                        children: [
                          _langButton(isTurkish, onLangToggle),
                          const SizedBox(width: 8),
                          _MobileMenuButton(
                            isTurkish: isTurkish,
                            currentIndex: currentIndex,
                            onNavTap: onNavTap,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _langButton(bool isTurkish, VoidCallback onToggle) {
    return Tooltip(
      message: isTurkish ? 'Switch to English' : 'Türkçeye Geç',
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.8), width: 1.5),
            borderRadius: BorderRadius.circular(30),
            color: AppColors.neonPurple.withValues(alpha: 0.1),
            boxShadow: [BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.2), blurRadius: 10)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.globe, color: AppColors.neonPurple, size: 12),
              const SizedBox(width: 6),
              Text(
                isTurkish ? "TR" : "EN",
                style: GoogleFonts.robotoMono(
                  color: AppColors.neonPurple,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _downloadButton(bool isTurkish, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPink.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: -5,
          )
        ],
        gradient: const LinearGradient(
          colors: [AppColors.softPurple, AppColors.neonPink],
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
        label: Text(
          isTurkish ? "İndir" : "Download",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}

// ---- Nav Item ----
class _NavItem extends StatefulWidget {
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;
  const _NavItem({required this.label, required this.index, required this.currentIndex, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.currentIndex == widget.index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.neonPurple.withValues(alpha: 0.15)
                : (_hovered ? Colors.white.withValues(alpha: 0.08) : Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            border: isActive
                ? Border.all(color: AppColors.neonPurple.withValues(alpha: 0.4), width: 1)
                : null,
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.outfit(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
              color: isActive ? AppColors.neonPurple : ((_hovered) ? Colors.white : Colors.white70),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Mobil Menü Butonu ----
class _MobileMenuButton extends StatelessWidget {
  final bool isTurkish;
  final int currentIndex;
  final Function(int) onNavTap;

  const _MobileMenuButton({required this.isTurkish, required this.currentIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded, color: Colors.white),
      tooltip: isTurkish ? 'Menü' : 'Menu',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.bgBlack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (ctx) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                _mobileTile(ctx, isTurkish ? 'Ana Sayfa' : 'Home', 0),
                _mobileTile(ctx, isTurkish ? 'Özellikler' : 'Features', 1),
                _mobileTile(ctx, isTurkish ? 'Hikayemiz' : 'Our Story', 2),
                _mobileTile(ctx, isTurkish ? 'İletişim' : 'Contact', 3),
                _mobileTile(ctx, isTurkish ? 'İndir' : 'Download', 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mobileTile(BuildContext ctx, String label, int index) {
    final isActive = currentIndex == index;
    return ListTile(
      leading: isActive ? const Icon(Icons.arrow_right_rounded, color: AppColors.neonPurple) : const SizedBox(width: 24),
      title: Text(
        label,
        style: GoogleFonts.outfit(
          color: isActive ? AppColors.neonPurple : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(ctx);
        onNavTap(index);
      },
    );
  }
}