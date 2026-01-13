import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatelessWidget {
  final bool isDesktop;
  final Function(int) onNavTap;

  const Navbar({super.key, required this.isDesktop, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        constraints: const BoxConstraints(maxWidth: 1200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // More rounded
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Stronger blur
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08), // Lighter, more glassy
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  InkWell(
                    onTap: () => onNavTap(0),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA480F2), Color(0xFFD946EF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFA480F2).withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: -2,
                              )
                            ],
                          ),
                          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "WakeBreaker",
                          style: GoogleFonts.outfit(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (isDesktop)
                    Row(
                      children: [
                        _NavBarItem(text: "Ana Sayfa", onTap: () => onNavTap(0)),
                        _NavBarItem(text: "Hikayemiz", onTap: () => onNavTap(1)),
                        _NavBarItem(text: "Özellikler", onTap: () => onNavTap(2)),
                        const SizedBox(width: 20),
                        _gradButton(onTap: () => onNavTap(3)),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradButton({required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD946EF).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -5,
          )
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFA480F2), Color(0xFFD946EF)],
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          "Hemen İndir", 
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavBarItem({required this.text, required this.onTap});

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.outfit(
              fontWeight: _isHovered ? FontWeight.bold : FontWeight.w500,
              color: _isHovered ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}