import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  // Golden Hour Silk Palette (Matching Reference Design)
  static const canvasTop = Color(0xFF4A5A6C);       // Cool Slate Mist Top
  static const canvasMid = Color(0xFFDF8532);       // Sunset Gold / Amber
  static const canvasBottom = Color(0xFF42170A);    // Rich Espresso Caramel Bottom

  // Primary Solid Buttons & Accents
  static const buttonSolidWhite = Color(0xFFFFFFFF);// High-contrast solid white button
  static const textDarkOnWhite = Color(0xFF1E140C); // Dark charcoal text on white buttons
  static const accentGold = Color(0xFFFFB347);      // Warm Glowing Amber Accent
  static const accentRose = Color(0xFFFF7B72);      // Terracotta Rose for Udhar
  static const accentMint = Color(0xFF4ADE80);      // Soft Mint for Payment

  // Glass & Text
  static const glassSurface = Color(0x28FFFFFF);    // Frosted Milk Glass (16% opacity)
  static const glassBorder = Color(0x55FFFFFF);     // Specular White Border (33% opacity)
  static const textPrimary = Color(0xFFFFFFFF);     // Silk White
  static const textSecondary = Color(0xD8FFF5EB);   // Warm Sand / Mist
  static const textMuted = Color(0xAAFFF0DF);       // Soft Taupe

  // Semantic Tokens for App compatibility
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
  static const borderLight = Color(0x40FFFFFF);
}

class AtmosphericBackdrop extends StatefulWidget {
  final Widget child;
  const AtmosphericBackdrop({super.key, required this.child});

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
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = 1.0 + (_pulse.value * 0.12);
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.canvasTop,
                Color(0xFF88645C),
                AppColors.canvasMid,
                Color(0xFF8F3E15),
                AppColors.canvasBottom,
              ],
              stops: [0.0, 0.22, 0.52, 0.78, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Sunset Gold Radiant Center Orb
              Positioned(
                top: 140,
                left: -40,
                child: _GlowOrb(
                  color: const Color(0xFFFFA726),
                  size: 340 * scale,
                  alpha: 0.25,
                ),
              ),
              // Slate Blue Top-Right Orb
              Positioned(
                top: -60,
                right: -60,
                child: _GlowOrb(
                  color: const Color(0xFF64748B),
                  size: 280,
                  alpha: 0.22,
                ),
              ),
              // Warm Caramel Bottom Orb
              Positioned(
                bottom: -80,
                right: 30,
                child: _GlowOrb(
                  color: const Color(0xFFD97706),
                  size: 300 * scale,
                  alpha: 0.20,
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
