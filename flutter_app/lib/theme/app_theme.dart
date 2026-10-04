import 'dart:ui';
import 'package:flutter/material.dart';

enum AppThemeMode {
  udharGlass, // Udhar Khata Liquid Glass Theme (formerly Wallvault Glass)
  lightMode,  // Light Silk Daylight Theme
}

class WallvaultColorPreset {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;

  const WallvaultColorPreset({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
  });
}

class WallvaultPresets {
  static const Map<String, WallvaultColorPreset> presets = {
    'PURPLE': WallvaultColorPreset(
      id: 'PURPLE',
      name: 'PURPLE',
      primary: Color(0xFF6366F1), // Royal Indigo
      secondary: Color(0xFFA855F7), // Bright Purple
    ),
    'BLUE': WallvaultColorPreset(
      id: 'BLUE',
      name: 'BLUE',
      primary: Color(0xFF2563EB), // Vibrant Blue
      secondary: Color(0xFF06B6D4), // Cyan Electric
    ),
    'TEAL': WallvaultColorPreset(
      id: 'TEAL',
      name: 'TEAL',
      primary: Color(0xFF0D9488), // Deep Teal
      secondary: Color(0xFF10B981), // Emerald Green
    ),
    'GREEN': WallvaultColorPreset(
      id: 'GREEN',
      name: 'GREEN',
      primary: Color(0xFF16A34A), // Forest Green
      secondary: Color(0xFF84CC16), // Lime Green
    ),
    'ORANGE': WallvaultColorPreset(
      id: 'ORANGE',
      name: 'ORANGE',
      primary: Color(0xFFEA580C), // Deep Orange
      secondary: Color(0xFFF97316), // Amber Orange
    ),
    'RED': WallvaultColorPreset(
      id: 'RED',
      name: 'RED',
      primary: Color(0xFFDC2626), // Crimson Red
      secondary: Color(0xFFF43F5E), // Coral Rose
    ),
    'PINK': WallvaultColorPreset(
      id: 'PINK',
      name: 'PINK',
      primary: Color(0xFFDB2777), // Hot Pink
      secondary: Color(0xFFEC4899), // Magenta Rose
    ),
    'VIOLET': WallvaultColorPreset(
      id: 'VIOLET',
      name: 'VIOLET',
      primary: Color(0xFF7C3AED), // Deep Violet
      secondary: Color(0xFFC084FC), // Soft Lavender
    ),
  };

  static WallvaultColorPreset getPreset(String id) {
    return presets[id.toUpperCase()] ?? presets['BLUE']!;
  }
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

  ThemePalette withPreset(WallvaultColorPreset preset, {bool? isDarkOverride}) {
    final dark = isDarkOverride ?? isDark;
    return ThemePalette(
      mode: mode,
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: dark
          ? [
              const Color(0xFF0A0E17),
              const Color(0xFF111827),
              preset.primary.withValues(alpha: 0.15),
              const Color(0xFF0F172A),
              const Color(0xFF06090E),
            ]
          : [
              const Color(0xFFF8FAFC),
              const Color(0xFFF1F5F9),
              preset.primary.withValues(alpha: 0.08),
              const Color(0xFFE2E8F0),
              const Color(0xFFCBD5E1),
            ],
      stops: stops,
      orb1Color: preset.primary,
      orb2Color: preset.secondary,
      orb3Color: orb3Color,
      glassSurface: dark ? const Color(0x1F222F3E) : const Color(0x99FFFFFF),
      glassBorder: dark ? preset.primary.withValues(alpha: 0.35) : preset.primary.withValues(alpha: 0.25),
      glassHighlight: glassHighlight,
      cardShadow: cardShadow,
      textPrimary: dark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      textSecondary: dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      textMuted: textMuted,
      buttonSolidWhite: preset.primary,
      textDarkOnWhite: const Color(0xFFFFFFFF),
      redUdhar: redUdhar,
      redBg: redBg,
      greenAdvance: greenAdvance,
      greenBg: greenBg,
      orangeMedium: orangeMedium,
      orangeBg: orangeBg,
      primaryAccent: preset.primary,
      navBarBg: navBarBg,
      isDark: dark,
    );
  }
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
  // 1. UDHAR KHATA LIQUID GLASS (Primary Glass Theme)
  static const udharGlass = ThemePalette(
    mode: AppThemeMode.udharGlass,
    title: 'Udhar Khata Glass',
    subtitle: 'Cyber Obsidian, Electric Cyan & Violet Glow',
    icon: Icons.auto_awesome_rounded,
    gradientColors: [
      Color(0xFF0A0E17), // Deep Obsidian Midnight Space
      Color(0xFF111827),
      Color(0xFF1E1430), // Electric Violet Ambient Glow
      Color(0xFF0F172A), // Slate Obsidian
      Color(0xFF06090E), // Pure Onyx Velvet Base
    ],
    stops: [0.0, 0.25, 0.55, 0.80, 1.0],
    orb1Color: Color(0xFF00F2FE), // Cyan Electric Glow
    orb2Color: Color(0xFF7F00FF), // Neon Violet Ambient
    orb3Color: Color(0xFFFF0844), // Crimson Coral Highlight
    glassSurface: Color(0x1F222F3E), // Ultra-clear Liquid Glass Surface
    glassBorder: Color(0x4D00F2FE),  // Cyan Tinted Glass Border
    glassHighlight: Color(0x38FFFFFF),
    cardShadow: Color(0x80000000),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    buttonSolidWhite: Color(0xFF2563EB), // Rich Sapphire Indigo Decent Button CTA
    textDarkOnWhite: Color(0xFFFFFFFF),  // Crisp White Text
    redUdhar: Color(0xFFFF4949),
    redBg: Color(0x2BFF4949),
    greenAdvance: Color(0xFF00E676),
    greenBg: Color(0x2B00E676),
    orangeMedium: Color(0xFFFFAB00),
    orangeBg: Color(0x2BFFAB00),
    primaryAccent: Color(0xFF3B82F6),
    navBarBg: Color(0x3B0F172A),
    isDark: true,
  );

  // 2. LIGHT SILK DAYLIGHT
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

  static ThemePalette getPalette(
    AppThemeMode mode, {
    String selectedPreset = 'BLUE',
    bool? isDarkOverride,
  }) {
    final base = (mode == AppThemeMode.lightMode) ? lightMode : udharGlass;
    final presetObj = WallvaultPresets.getPreset(selectedPreset);
    return base.withPreset(presetObj, isDarkOverride: isDarkOverride);
  }
}

class AtmosphericBackdrop extends StatelessWidget {
  final Widget child;
  final ThemePalette? palette;
  const AtmosphericBackdrop({super.key, required this.child, this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppPalettes.udharGlass;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
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
          // Ambient sheen overlay
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    p.primaryAccent.withValues(alpha: p.isDark ? 0.12 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          child,
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
  final bool isGlassEnabled;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
    this.margin,
    this.containerColor,
    this.borderColor,
    this.onTap,
    this.isGlassEnabled = true,
    this.blurSigma = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = containerColor ?? Colors.white.withValues(alpha: isGlassEnabled ? 0.08 : 0.95);
    final effectiveBorder = borderColor ?? Colors.white.withValues(alpha: isGlassEnabled ? 0.18 : 0.30);

    Widget cardBody = Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: effectiveBorder,
          width: 1.2,
        ),
        gradient: isGlassEnabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.16),
                  (containerColor ?? Colors.white.withValues(alpha: 0.08)),
                  (containerColor ?? Colors.white.withValues(alpha: 0.04)),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isGlassEnabled ? 0.40 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: isGlassEnabled
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: cardBody,
            )
          : cardBody,
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

class AnimatedGlassIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback? onTap;

  const AnimatedGlassIcon({
    super.key,
    required this.icon,
    this.size = 24,
    required this.color,
    this.onTap,
  });

  @override
  State<AnimatedGlassIcon> createState() => _AnimatedGlassIconState();
}

class _AnimatedGlassIconState extends State<AnimatedGlassIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _triggerAnimation,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Icon(
                widget.icon,
                size: widget.size,
                color: widget.color,
              ),
            ),
          );
        },
      ),
    );
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

class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final double radius;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.color,
    this.textColor,
    this.radius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? const Color(0xFF2563EB);
    final txtColor = textColor ?? Colors.white;

    return BouncyWidget(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              btnColor,
              btnColor.withValues(alpha: 0.82),
            ],
          ),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: btnColor.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: txtColor),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: txtColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
