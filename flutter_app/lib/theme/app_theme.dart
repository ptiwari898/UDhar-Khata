import 'dart:ui';
import 'package:flutter/material.dart';

enum AppThemeMode {
  defaultGoldenHour, // Warm Sunset Amber, Slate Mist & Espresso Caramel (Reference Design)
  darkMode,          // Midnight Obsidian & Neon Amber Glow
  lightMode,         // Frosted Ivory Silk & Warm Amber Caramel
}

class ThemePalette {
  final AppThemeMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final List<double> stops;
  final Color orb1Color;
  final Color orb2Color;
  final Color orb3Color;
  final Color glassSurface;
  final Color glassBorder;
  final Color glassHighlight;
  final Color cardShadow;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color buttonSolidWhite;
  final Color textDarkOnWhite;
  final Color redUdhar;
  final Color redBg;
  final Color greenAdvance;
  final Color greenBg;
  final Color orangeMedium;
  final Color orangeBg;
  final Color primaryAccent;
  final Color navBarBg;
  final bool isDark;

  const ThemePalette({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.stops,
    required this.orb1Color,
    required this.orb2Color,
    required this.orb3Color,
    required this.glassSurface,
    required this.glassBorder,
    required this.glassHighlight,
    required this.cardShadow,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.buttonSolidWhite,
    required this.textDarkOnWhite,
    required this.redUdhar,
    required this.redBg,
    required this.greenAdvance,
    required this.greenBg,
    required this.orangeMedium,
    required this.orangeBg,
    required this.primaryAccent,
    required this.navBarBg,
    required this.isDark,
  });
}

class AppColors {
  // Backwards compatibility default palette references
  static const canvasTop = Color(0xFF4A5A6C);
  static const canvasMid = Color(0xFFDF8532);
  static const canvasBottom = Color(0xFF42170A);

  static const buttonSolidWhite = Color(0xFFFFFFFF);
  static const textDarkOnWhite = Color(0xFF1E140C);
  static const accentGold = Color(0xFFFFB347);
  static const accentRose = Color(0xFFFF7B72);
  static const accentMint = Color(0xFF4ADE80);

  static const glassSurface = Color(0x28FFFFFF);
  static const glassBorder = Color(0x55FFFFFF);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xD8FFF5EB);
  static const textMuted = Color(0xAAFFF0DF);

  static const primaryBlue = Color(0xFFFFFFFF);
  static const primaryBlueBg = Color(0x33FFFFFF);
  static const primaryBlueLight = Color(0xFFFFE8D6);
  static const greenAdvance = Color(0xFF4ADE80);
  static const greenBg = Color(0x264ADE80);
  static const redUdhar = Color(0xFFFF7B72);
  static const redBg = Color(0x26FF7B72);
  static const orangeMedium = Color(0xFFFFB347);
  static const orangeBg = Color(0x26FFB347);
  static const backgroundSlate = Color(0xFF2C160B);
  static const cardSurface = Color(0x26FFFFFF);
  static const dropdownSurface = Color(0xFF2A1710); // Solid opaque dropdown menu surface
  static const popupSurface = Color(0xFF24140D);    // Solid opaque modal & popup surface
  static const borderLight = Color(0x40FFFFFF);
}

class AppPalettes {
  // 1. DEFAULT GOLDEN HOUR SILK (Reference Theme)
  static const defaultGoldenHour = ThemePalette(
    mode: AppThemeMode.defaultGoldenHour,
    title: 'Golden Hour (Default)',
    subtitle: 'Warm Sunset Amber & Espresso Silk',
    icon: Icons.wb_twilight_rounded,
    gradientColors: [
      Color(0xFF4A5A6C), // Slate Mist
      Color(0xFF88645C),
      Color(0xFFDF8532), // Sunset Amber Gold
      Color(0xFF8F3E15),
      Color(0xFF42170A), // Espresso Caramel
    ],
    stops: [0.0, 0.22, 0.52, 0.78, 1.0],
    orb1Color: Color(0xFFFFA726),
    orb2Color: Color(0xFF64748B),
    orb3Color: Color(0xFFD97706),
    glassSurface: Color(0x24FFFFFF),
    glassBorder: Color(0x55FFFFFF),
    glassHighlight: Color(0x38FFFFFF),
    cardShadow: Color(0x38000000),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xD8FFF5EB),
    textMuted: Color(0xAAFFF0DF),
    buttonSolidWhite: Color(0xFFFFFFFF),
    textDarkOnWhite: Color(0xFF1E140C),
    redUdhar: Color(0xFFFF7B72),
    redBg: Color(0x26FF7B72),
    greenAdvance: Color(0xFF4ADE80),
    greenBg: Color(0x264ADE80),
    orangeMedium: Color(0xFFFFB347),
    orangeBg: Color(0x26FFB347),
    primaryAccent: Color(0xFFFFA726),
    navBarBg: Color(0x2B000000),
    isDark: true,
  );

  // 2. DARK OBSIDIAN MIDNIGHT
  static const darkMode = ThemePalette(
    mode: AppThemeMode.darkMode,
    title: 'Dark Obsidian',
    subtitle: 'Midnight Velvet & Neon Amber Glass',
    icon: Icons.dark_mode_rounded,
    gradientColors: [
      Color(0xFF11141A), // Deep Obsidian Charcoal
      Color(0xFF181822),
      Color(0xFF1F1511), // Deep Smoked Espresso
      Color(0xFF140D0B),
      Color(0xFF090605), // Pure Onyx Base
    ],
    stops: [0.0, 0.25, 0.55, 0.80, 1.0],
    orb1Color: Color(0xFFFF8F00), // Glowing Amber Neon
    orb2Color: Color(0xFF38BDFC), // Subtle Sapphire Accent
    orb3Color: Color(0xFFE11D48), // Deep Rose Ambient
    glassSurface: Color(0x18FFFFFF),
    glassBorder: Color(0x33FFFFFF),
    glassHighlight: Color(0x24FFFFFF),
    cardShadow: Color(0x60000000),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    buttonSolidWhite: Color(0xFFFFFFFF),
    textDarkOnWhite: Color(0xFF0F172A),
    redUdhar: Color(0xFFF87171),
    redBg: Color(0x26F87171),
    greenAdvance: Color(0xFF34D399),
    greenBg: Color(0x2634D399),
    orangeMedium: Color(0xFFFBBF24),
    orangeBg: Color(0x26FBBF24),
    primaryAccent: Color(0xFFF59E0B),
    navBarBg: Color(0x4D000000),
    isDark: true,
  );

  // 3. LIGHT SILK DAYLIGHT
  static const lightMode = ThemePalette(
    mode: AppThemeMode.lightMode,
    title: 'Light Silk',
    subtitle: 'Frosted Ivory Silk & Caramel Glow',
    icon: Icons.light_mode_rounded,
    gradientColors: [
      Color(0xFFF8FAFC), // Crisp Ice Mist
      Color(0xFFFDF6EE), // Warm Pearl Ivory
      Color(0xFFFDE8D0), // Soft Golden Peach
      Color(0xFFFCE1C2), // Warm Caramel Mist
      Color(0xFFF5D6B4), // Soft Sand Base
    ],
    stops: [0.0, 0.22, 0.52, 0.78, 1.0],
    orb1Color: Color(0xFFFFCC80),
    orb2Color: Color(0xFFBAE6FD),
    orb3Color: Color(0xFFFFE0B2),
    glassSurface: Color(0x8AFFFFFF), // Frosted Bright Glass
    glassBorder: Color(0xB3FFFFFF),
    glassHighlight: Color(0xDDFFFFFF),
    cardShadow: Color(0x12000000),
    textPrimary: Color(0xFF1E293B),  // Crisp Dark Slate
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF64748B),
    buttonSolidWhite: Color(0xFF1E293B), // Dark solid button in light mode
    textDarkOnWhite: Color(0xFFFFFFFF),  // White text on dark button
    redUdhar: Color(0xFFDC2626),
    redBg: Color(0x20DC2626),
    greenAdvance: Color(0xFF059669),
    greenBg: Color(0x20059669),
    orangeMedium: Color(0xFFD97706),
    orangeBg: Color(0x20D97706),
    primaryAccent: Color(0xFFD97706),
    navBarBg: Color(0x40FFFFFF),
    isDark: false,
  );

  static ThemePalette getPalette(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.darkMode:
        return darkMode;
      case AppThemeMode.lightMode:
        return lightMode;
      case AppThemeMode.defaultGoldenHour:
        return defaultGoldenHour;
    }
  }
}

class AtmosphericBackdrop extends StatefulWidget {
  final Widget child;
  final ThemePalette? palette;
  const AtmosphericBackdrop({super.key, required this.child, this.palette});

  @override
  State<AtmosphericBackdrop> createState() => _AtmosphericBackdropState();
}

class _AtmosphericBackdropState extends State<AtmosphericBackdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette ?? AppPalettes.defaultGoldenHour;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = 1.0 + (_pulse.value * 0.12);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: p.gradientColors,
              stops: p.stops,
            ),
          ),
          child: Stack(
            children: [
              // Orb 1 (Top Left Primary Glow)
              Positioned(
                top: 140,
                left: -40,
                child: _GlowOrb(
                  color: p.orb1Color,
                  size: 340 * scale,
                  alpha: p.isDark ? 0.25 : 0.45,
                ),
              ),
              // Orb 2 (Top Right Ambient Accent)
              Positioned(
                top: -60,
                right: -60,
                child: _GlowOrb(
                  color: p.orb2Color,
                  size: 280,
                  alpha: p.isDark ? 0.22 : 0.35,
                ),
              ),
              // Orb 3 (Bottom Right Warm Glow)
              Positioned(
                bottom: -80,
                right: 30,
                child: _GlowOrb(
                  color: p.orb3Color,
                  size: 300 * scale,
                  alpha: p.isDark ? 0.20 : 0.35,
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double alpha;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.alpha,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: alpha),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: alpha * 1.5),
            blurRadius: 110,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? containerColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
    this.margin,
    this.containerColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: containerColor ?? Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.22),
                (containerColor ?? Colors.white.withValues(alpha: 0.12)),
                (containerColor ?? Colors.white.withValues(alpha: 0.06)),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      cardContent = BouncyWidget(
        onTap: onTap,
        child: cardContent,
      );
    }

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    return cardContent;
  }
}

class BouncyWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;

  const BouncyWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
  });

  @override
  State<BouncyWidget> createState() => _BouncyWidgetState();
}

class _BouncyWidgetState extends State<BouncyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
