import 'package:flutter/material.dart';

/// Advanced Theme Styles - 2025 Trends
/// Glassmorphism, Neumorphism, Bento Grid, Brutalism, 3D Depth, Micro-interactions
class ThemeStyles {

  // ==================== 2025 TREND: Glassmorphism ====================

  static BoxDecoration glassMorphism(BuildContext context, {double blur = 10}) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration glassCard(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface.withOpacity(0.8),
          Theme.of(context).colorScheme.surface.withOpacity(0.4),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 30,
          offset: const Offset(0, 15),
        ),
      ],
    );
  }

  // ==================== 2025 TREND: Neumorphism (Soft UI) ====================

  static BoxDecoration neumorphism(BuildContext context, {bool pressed = false, double radius = 20}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Theme.of(context).colorScheme.surface;

    return BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: pressed
          ? [
        BoxShadow(
          color: isDark ? Colors.black38 : Colors.black26,
          offset: const Offset(2, 2),
          blurRadius: 5,
        ),
      ]
          : [
        BoxShadow(
          color: isDark ? Colors.black54 : Colors.black12,
          offset: const Offset(10, 10),
          blurRadius: 20,
        ),
        BoxShadow(
          color: isDark ? Colors.white12 : Colors.white,
          offset: const Offset(-10, -10),
          blurRadius: 20,
        ),
      ],
    );
  }

  static BoxDecoration softButton(BuildContext context, {bool isActive = false}) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: isActive
          ? [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 0),
        ),
      ]
          : [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(5, 5),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          offset: const Offset(-5, -5),
          blurRadius: 10,
        ),
      ],
    );
  }

  // ==================== 2025 TREND: 3D Depth & Layers ====================

  static BoxDecoration layeredCard(BuildContext context, {int layer = 1}) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          blurRadius: 20 + (layer * 10).toDouble(),
          offset: Offset(0, 5 + (layer * 5).toDouble()),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 40 + (layer * 10).toDouble(),
          offset: Offset(0, 10 + (layer * 5).toDouble()),
        ),
      ],
    );
  }

  static BoxDecoration floatingElement(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.secondaryContainer,
        ],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          blurRadius: 30,
          offset: const Offset(0, 15),
          spreadRadius: -5,
        ),
        BoxShadow(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          blurRadius: 50,
          offset: const Offset(0, 25),
          spreadRadius: -10,
        ),
      ],
    );
  }

  // ==================== 2025 TREND: Bento Grid Containers ====================

  static BoxDecoration bentoBox(BuildContext context, {bool isHighlighted = false}) {
    return BoxDecoration(
      color: isHighlighted
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isHighlighted
            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        width: isHighlighted ? 2 : 1,
      ),
    );
  }

  static BoxDecoration bentoCard(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ==================== 2025 TREND: Brutalism Elements ====================

  static BoxDecoration brutalCard(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface,
        width: 3,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary,
          offset: const Offset(8, 8),
          blurRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration brutalButton(BuildContext context, {Color? shadowColor}) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      border: Border.all(
        color: Theme.of(context).colorScheme.onSurface,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? Theme.of(context).colorScheme.primary,
          offset: const Offset(4, 4),
          blurRadius: 0,
        ),
      ],
    );
  }

  // ==================== Premium Gradients ====================

  static LinearGradient vibrantGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.tertiary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient meshGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.8),
        Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
        Theme.of(context).colorScheme.primary.withOpacity(0.6),
      ],
      stops: const [0.0, 0.33, 0.66, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient holoGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        const Color(0xFFFF6B9D),
        const Color(0xFFC239B3),
        const Color(0xFF7301FA),
        const Color(0xFF0084FF),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // ==================== Glow & Shadow Effects ====================

  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.6}) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: 20,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withOpacity(intensity * 0.5),
        blurRadius: 40,
        spreadRadius: 5,
      ),
      BoxShadow(
        color: color.withOpacity(intensity * 0.3),
        blurRadius: 60,
        spreadRadius: 10,
      ),
    ];
  }

  static List<BoxShadow> softShadow(BuildContext context, {double elevation = 1}) {
    return [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.1 * elevation),
        blurRadius: 10 * elevation,
        offset: Offset(0, 5 * elevation),
      ),
    ];
  }

  static List<BoxShadow> deepShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 40,
        offset: const Offset(0, 20),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        blurRadius: 60,
        offset: const Offset(0, 30),
        spreadRadius: -15,
      ),
    ];
  }

  // ==================== Interactive States ====================

  static BoxDecoration hoverCard(BuildContext context, {required bool isHovered}) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isHovered
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        width: isHovered ? 2 : 1,
      ),
      boxShadow: isHovered ? deepShadow(context) : softShadow(context),
    );
  }

  static BoxDecoration activeCard(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ==================== Icon Containers ====================

  static BoxDecoration modernIcon(BuildContext context, {Color? color}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color ?? Theme.of(context).colorScheme.primary,
          (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration circleIcon(BuildContext context, {Color? color}) {
    return BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // ==================== Input Fields ====================

  static InputDecoration modernInput(
      BuildContext context, {
        required String label,
        String? hint,
        IconData? icon,
        Widget? suffix,
      }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  // ==================== Chips & Tags ====================

  static BoxDecoration modernChip(BuildContext context, {bool selected = false}) {
    return BoxDecoration(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        width: selected ? 2 : 1,
      ),
      boxShadow: selected
          ? [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ]
          : null,
    );
  }

  // ==================== Dividers ====================

  static Widget modernDivider(BuildContext context, {double height = 1}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).colorScheme.outline.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ==================== Badges ====================

  static BoxDecoration notificationBadge(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.error,
          Theme.of(context).colorScheme.error.withOpacity(0.8),
        ],
      ),
      shape: BoxShape.circle,
      boxShadow: neonGlow(Theme.of(context).colorScheme.error, intensity: 0.5),
    );
  }

  static BoxDecoration statusBadge(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color, width: 1),
    );
  }

  // ==================== Skeleton Loading ====================

  static BoxDecoration shimmerBox(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Theme.of(context).colorScheme.surfaceContainerHighest,
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // ==================== Animation Curves ====================

  static const smoothCurve = Curves.easeInOutCubic;
  static const bounceCurve = Curves.elasticOut;
  static const quickCurve = Curves.easeOutQuart;
  static const springCurve = Curves.easeOutBack;

  // ==================== Spacing Constants ====================

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // ==================== Radius Constants ====================

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 100.0;

  // ==================== Duration Constants ====================

  static const fastDuration = Duration(milliseconds: 200);
  static const normalDuration = Duration(milliseconds: 300);
  static const slowDuration = Duration(milliseconds: 500);
}