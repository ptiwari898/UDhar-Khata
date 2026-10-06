import 'dart:ui' show lerpDouble;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

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

  /// Builds a palette from a Material You [ColorScheme] (e.g. the wallpaper
  /// colors reported by Android 12+). Semantic ledger colors (red = udhaar,
  /// green = payment) are kept but harmonized toward the scheme's primary so
  /// they sit naturally next to the dynamic accent.
  ThemePalette withColorScheme(ColorScheme scheme) {
    final dark = scheme.brightness == Brightness.dark;
    final red = redUdhar.harmonizeWith(scheme.primary);
    final green = greenAdvance.harmonizeWith(scheme.primary);
    final orange = orangeMedium.harmonizeWith(scheme.primary);
    return ThemePalette(
      mode: mode,
      title: title,
      subtitle: subtitle,
      icon: icon,
      gradientColors: [
        scheme.surface,
        scheme.surfaceContainerLow,
        Color.alphaBlend(scheme.primary.withValues(alpha: dark ? 0.12 : 0.08), scheme.surfaceContainer),
        scheme.surfaceContainerLow,
        scheme.surfaceContainerHigh,
      ],
      stops: stops,
      orb1Color: scheme.primary,
      orb2Color: scheme.tertiary,
      orb3Color: scheme.secondary,
      glassSurface: scheme.surfaceContainerLow.withValues(alpha: dark ? 0.35 : 0.55),
      glassBorder: scheme.outlineVariant.withValues(alpha: 0.7),
      glassHighlight: glassHighlight,
      cardShadow: scheme.shadow.withValues(alpha: dark ? 0.45 : 0.08),
      textPrimary: scheme.onSurface,
      textSecondary: scheme.onSurfaceVariant,
      textMuted: scheme.outline,
      buttonSolidWhite: scheme.primary,
      textDarkOnWhite: scheme.onPrimary,
      redUdhar: red,
      redBg: red.withValues(alpha: dark ? 0.17 : 0.12),
      greenAdvance: green,
      greenBg: green.withValues(alpha: dark ? 0.17 : 0.12),
      orangeMedium: orange,
      orangeBg: orange.withValues(alpha: dark ? 0.17 : 0.12),
      primaryAccent: scheme.primary,
      navBarBg: scheme.surfaceContainer.withValues(alpha: 0.6),
      isDark: dark,
    );
  }
}

class AppColors {
  // Backwards compatibility default palette references
  static const canvasTop = Color(0xFFF8FAFC);
  static const canvasMid = Color(0xFFF1F5F9);
  static const canvasBottom = Color(0xFFE2E8F0);

  static const buttonSolidWhite = Color(0xFF2563EB);
  static const textDarkOnWhite = Color(0xFFFFFFFF);
  static const accentGold = Color(0xFF2563EB);
  static const accentRose = Color(0xFFE11D48);
  static const accentMint = Color(0xFF16A34A);

  static const glassSurface = Color(0xFFFFFFFF);
  static const glassBorder = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF334155);
  static const textMuted = Color(0xFF64748B);

  static const primaryBlue = Color(0xFF2563EB);
  static const primaryBlueBg = Color(0xFFDBEAFE);
  static const primaryBlueLight = Color(0xFFEFF6FF);
  static const greenAdvance = Color(0xFF16A34A);
  static const greenBg = Color(0xFFDCFCE7);
  static const redUdhar = Color(0xFFE11D48);
  static const redBg = Color(0xFFFFE4E6);
  static const orangeMedium = Color(0xFFEA580C);
  static const orangeBg = Color(0xFFFFEDD5);
  static const backgroundSlate = Color(0xFFFFFFFF);
  static const cardSurface = Color(0xFFFFFFFF);
  static const dropdownSurface = Color(0xFFFFFFFF); // Clean white dropdown surface
  static const popupSurface = Color(0xFFFFFFFF);    // Clean white modal surface
  static const borderLight = Color(0xFFE2E8F0);
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

  // 2. LIGHT SILK DAYLIGHT (Modern Minimalist Light)
  static const lightMode = ThemePalette(
    mode: AppThemeMode.lightMode,
    title: 'Minimal Light',
    subtitle: 'Crisp Daylight Slate & High-Contrast Cards',
    icon: Icons.light_mode_rounded,
    gradientColors: [
      Color(0xFFFFFFFF), // Pure Crisp White
      Color(0xFFF8FAFC), // Slate Mist Tint
      Color(0xFFF1F5F9), // Soft Slate Daylight
      Color(0xFFF8FAFC),
      Color(0xFFFFFFFF),
    ],
    stops: [0.0, 0.25, 0.50, 0.75, 1.0],
    orb1Color: Color(0xFFE2E8F0),
    orb2Color: Color(0xFFE2E8F0),
    orb3Color: Color(0xFFCBD5E1),
    glassSurface: Color(0xFFFFFFFF), // Pure Opaque White Glass
    glassBorder: Color(0xFFE2E8F0),  // Clean Precision Slate Border
    glassHighlight: Color(0xFFFFFFFF),
    cardShadow: Color(0x0F0F172A),
    textPrimary: Color(0xFF0F172A),   // Deep Slate High Contrast Text
    textSecondary: Color(0xFF334155), // Crisp Slate Secondary Text
    textMuted: Color(0xFF64748B),
    buttonSolidWhite: Color(0xFF2563EB), // Cobalt Accent Primary CTA
    textDarkOnWhite: Color(0xFFFFFFFF),  // White text on Cobalt CTA
    redUdhar: Color(0xFFE11D48),       // Crisp Rose Red (You Give)
    redBg: Color(0xFFFFE4E6),
    greenAdvance: Color(0xFF16A34A),   // Crisp Emerald Green (You Get)
    greenBg: Color(0xFFDCFCE7),
    orangeMedium: Color(0xFFEA580C),
    orangeBg: Color(0xFFFFEDD5),
    primaryAccent: Color(0xFF2563EB),  // Vibrant Cobalt Accent
    navBarBg: Color(0xFAFFFFFF),
    isDark: false,
  );

  static ThemePalette getPalette(
    AppThemeMode mode, {
    String selectedPreset = 'BLUE',
    bool? isDarkOverride,
    ColorScheme? dynamicScheme,
  }) {
    final base = (mode == AppThemeMode.lightMode) ? lightMode : udharGlass;
    if (dynamicScheme != null) return base.withColorScheme(dynamicScheme);
    final presetObj = WallvaultPresets.getPreset(selectedPreset);
    return base.withPreset(presetObj, isDarkOverride: isDarkOverride);
  }
}

/// Glass styling shared by [GlassCard] and other glass surfaces, resolved
/// from the active [ThemePalette] and the user's glass settings.
@immutable
class GlassTheme extends ThemeExtension<GlassTheme> {
  final bool enabled;
  final double blur;
  final Color tint;
  final Color border;
  final Color highlight;
  final Color shadow;
  final Color solidSurface;

  const GlassTheme({
    required this.enabled,
    required this.blur,
    required this.tint,
    required this.border,
    required this.highlight,
    required this.shadow,
    required this.solidSurface,
  });

  factory GlassTheme.fromPalette(
    ThemePalette p,
    ColorScheme scheme, {
    bool enabled = true,
    double blurSigma = 22,
  }) {
    return GlassTheme(
      enabled: enabled,
      // Settings slider is expressed as a Gaussian sigma (10–32); the
      // liquid glass shader expects a much smaller frost radius.
      blur: blurSigma / 3,
      tint: Color.alphaBlend(
        scheme.primary.withValues(alpha: p.isDark ? 0.06 : 0.04),
        scheme.surfaceContainerLow.withValues(alpha: p.isDark ? 0.32 : 0.5),
      ),
      border: scheme.outlineVariant.withValues(alpha: p.isDark ? 0.45 : 0.6),
      highlight: Colors.white.withValues(alpha: p.isDark ? 0.10 : 0.45),
      shadow: p.cardShadow,
      solidSurface: scheme.surfaceContainerLow,
    );
  }

  static GlassTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<GlassTheme>() ??
        GlassTheme.fromPalette(
          theme.brightness == Brightness.dark ? AppPalettes.udharGlass : AppPalettes.lightMode,
          theme.colorScheme,
        );
  }

  LiquidGlassSettings settings({Color? tintOverride, bool refract = false}) {
    return LiquidGlassSettings(
      glassColor: tintOverride ?? tint,
      blur: blur,
      thickness: refract ? 22 : 12,
      refractiveIndex: refract ? 1.22 : 1.1,
      lightIntensity: 0.6,
      ambientStrength: 0.15,
      chromaticAberration: refract ? 0.02 : 0,
      saturation: 1.4,
    );
  }

  /// Lens-like settings for a pill of the given [height] (e.g. a nav bar).
  ///
  /// The shader only bends light within `thickness` px of the edge and
  /// treats the rest as a flat slab, so thickness is set to half the height
  /// to curve the whole cross-section. Tint and frost are kept light so the
  /// content behind stays readable through the middle.
  LiquidGlassSettings pillSettings({required double height}) {
    return LiquidGlassSettings(
      glassColor: tint.withValues(alpha: tint.a * 0.35),
      blur: blur * 0.25,
      thickness: height / 2,
      refractiveIndex: 1.3,
      lightIntensity: 0.7,
      ambientStrength: 0.2,
      chromaticAberration: 0.03,
      saturation: 1.5,
    );
  }

  @override
  GlassTheme copyWith({
    bool? enabled,
    double? blur,
    Color? tint,
    Color? border,
    Color? highlight,
    Color? shadow,
    Color? solidSurface,
  }) {
    return GlassTheme(
      enabled: enabled ?? this.enabled,
      blur: blur ?? this.blur,
      tint: tint ?? this.tint,
      border: border ?? this.border,
      highlight: highlight ?? this.highlight,
      shadow: shadow ?? this.shadow,
      solidSurface: solidSurface ?? this.solidSurface,
    );
  }

  @override
  GlassTheme lerp(GlassTheme? other, double t) {
    if (other == null) return this;
    return GlassTheme(
      enabled: t < 0.5 ? enabled : other.enabled,
      blur: lerpDouble(blur, other.blur, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      border: Color.lerp(border, other.border, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      solidSurface: Color.lerp(solidSurface, other.solidSurface, t)!,
    );
  }
}

class AppTheme {
  /// Material 3 [ThemeData] driven by [scheme] (Material You dynamic colors
  /// or a seeded preset), with glass styling attached as a [GlassTheme].
  static ThemeData build(
    ColorScheme scheme,
    ThemePalette palette, {
    bool glassEnabled = true,
    double glassBlurSigma = 22,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: scheme.surfaceContainerLow),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.onPrimary : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      extensions: [
        GlassTheme.fromPalette(
          palette,
          scheme,
          enabled: glassEnabled,
          blurSigma: glassBlurSigma,
        ),
      ],
    );
  }
}

class AtmosphericBackdrop extends StatelessWidget {
  final Widget child;
  final ThemePalette? palette;
  const AtmosphericBackdrop({super.key, required this.child, this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette ?? AppPalettes.udharGlass;
    final orbAlpha = p.isDark ? 0.28 : 0.20;

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
          // Soft color orbs give the glass surfaces something to refract.
          _orb(top: -80, left: -60, size: 280, color: p.orb1Color.withValues(alpha: orbAlpha)),
          _orb(top: 260, right: -90, size: 260, color: p.orb2Color.withValues(alpha: orbAlpha)),
          _orb(bottom: 40, left: -40, size: 220, color: p.orb3Color.withValues(alpha: orbAlpha * 0.8)),
          child,
        ],
      ),
    );
  }

  Widget _orb({double? top, double? left, double? right, double? bottom, required double size, required Color color}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
          ),
        ),
      ),
    );
  }
}

/// A Material You card rendered as liquid glass.
///
/// By default it uses [FakeGlass] (frosted blur + lighting, no refraction
/// shader), which is cheap enough for lists. Set [refract] for hero surfaces
/// to get true liquid-glass refraction via [LiquidGlass]; on renderers
/// without Impeller the package falls back to [FakeGlass] automatically.
/// When glass is disabled in settings it renders as a solid M3 card.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? containerColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool refract;
  final bool? isGlassEnabled;

  const GlassCard({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
    this.margin,
    this.containerColor,
    this.borderColor,
    this.onTap,
    this.refract = false,
    this.isGlassEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final glass = GlassTheme.of(context);
    final enabled = isGlassEnabled ?? glass.enabled;
    final border = borderColor ?? glass.border;

    Widget body = Padding(
      padding: padding ?? const EdgeInsets.all(18),
      child: child,
    );

    final Widget card;
    if (enabled) {
      final shape = LiquidRoundedSuperellipse(borderRadius: radius);
      final settings = glass.settings(tintOverride: containerColor, refract: refract);
      body = DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: border, width: 1),
          ),
          // Specular sheen along the top-left edge.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.center,
            colors: [glass.highlight, glass.highlight.withValues(alpha: 0)],
          ),
        ),
        child: body,
      );
      if (onTap != null) body = GlassGlow(child: body);
      card = refract
          ? LiquidGlass.withOwnLayer(settings: settings, shape: shape, child: body)
          : FakeGlass(settings: settings, shape: shape, child: body);
    } else {
      card = DecoratedBox(
        decoration: ShapeDecoration(
          color: containerColor ?? glass.solidSurface,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: border, width: 1),
          ),
          shadows: [
            BoxShadow(color: glass.shadow, blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: body,
      );
    }

    Widget result = onTap != null ? BouncyWidget(onTap: onTap, child: card) : card;
    if (margin != null) result = Padding(padding: margin!, child: result);
    return result;
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
