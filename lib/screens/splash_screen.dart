import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'main_screen.dart';

/// Professional Splash Screen - Clean Architecture
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = SplashAnimationController(vsync: this);
    _initializeApp();
  }

  /// Initialize app and navigate after delay
  Future<void> _initializeApp() async {
    await _animationController.startAnimations();
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const MainScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(controller: _animationController),
    );
  }
}

/// Animation Controller - Manages all animations
class SplashAnimationController {
  final TickerProvider vsync;

  late final AnimationController logoScale;
  late final AnimationController logoRotation;
  late final AnimationController glowPulse;
  late final AnimationController contentFade;
  late final AnimationController particleFlow;

  SplashAnimationController({required this.vsync}) {
    logoScale = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );

    logoRotation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1200),
    );

    glowPulse = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    contentFade = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );

    particleFlow = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  Future<void> startAnimations() async {
    await logoScale.forward();
    logoRotation.forward();
    contentFade.forward();
  }

  void dispose() {
    logoScale.dispose();
    logoRotation.dispose();
    glowPulse.dispose();
    contentFade.dispose();
    particleFlow.dispose();
  }
}

/// Main View - Presentation Layer
class SplashScreenView extends StatelessWidget {
  final SplashAnimationController controller;

  const SplashScreenView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E27),
            Color(0xFF0D1117),
            Color(0xFF1A1F3A),
            Color(0xFF0A0E27),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated particles background
          _AnimatedParticleBackground(controller: controller),

          // Gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glassmorphism
                  _GlassmorphicLogo(controller: controller),

                  const SizedBox(height: 48),

                  // App title
                  _AnimatedTitle(controller: controller),

                  const SizedBox(height: 16),

                  // Subtitle
                  _AnimatedSubtitle(controller: controller),

                  const SizedBox(height: 80),

                  // Loading indicator
                  _ModernLoadingIndicator(controller: controller),
                ],
              ),
            ),
          ),

          // Footer info
          _FooterInfo(controller: controller),
        ],
      ),
    );
  }
}

/// Glassmorphic Logo Component
class _GlassmorphicLogo extends StatelessWidget {
  final SplashAnimationController controller;

  const _GlassmorphicLogo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.logoScale,
        controller.logoRotation,
        controller.glowPulse,
      ]),
      builder: (context, child) {
        final glowIntensity = controller.glowPulse.value;
        final rotation = controller.logoRotation.value * 0.1;

        return Transform.scale(
          scale: controller.logoScale.value,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E3A5F).withOpacity(0.3),
                    const Color(0xFF0D1B2A).withOpacity(0.5),
                    const Color(0xFF000000).withOpacity(0.7),
                  ],
                ),
                border: Border.all(
                  width: 2,
                  color: Color.lerp(
                    const Color(0xFF00E5FF),
                    const Color(0xFF00A3FF),
                    glowIntensity,
                  )!.withOpacity(0.6),
                ),
                boxShadow: [
                  // Outer glow
                  BoxShadow(
                    color: Color.lerp(
                      const Color(0xFF00E5FF),
                      const Color(0xFF0066FF),
                      glowIntensity,
                    )!.withOpacity(0.4 + glowIntensity * 0.3),
                    blurRadius: 50 + glowIntensity * 30,
                    spreadRadius: 10,
                  ),
                  // Inner shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  children: [
                    // Glass effect
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Grid pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ModernGridPainter(
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ),

                    // Logo content - EC with arrow
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // E letter
                              _buildGradientText('E', 80),
                              const SizedBox(width: 8),
                              // C letter with arrow - FIXED POSITION
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _buildGradientText('C', 80),
                                  // Arrow positioned higher
                                  Positioned(
                                    right: -12,
                                    top: 12, // Changed from 18 to 12
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00E5FF)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Color(0xFF00E5FF),
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // CONVERTER text
                          Text(
                            'CONVERTER',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 6,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF00E5FF),
                                    Color(0xFF0099FF),
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 50),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build gradient text for logo letters
  Widget _buildGradientText(String text, double fontSize) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF00E5FF),
          Color(0xFF0099FF),
          Color(0xFF0066FF),
        ],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Animated Title
class _AnimatedTitle extends StatelessWidget {
  final SplashAnimationController controller;

  const _AnimatedTitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.contentFade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: controller.contentFade,
          curve: Curves.easeOutCubic,
        )),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF00E5FF),
              Color(0xFFFFFFFF),
              Color(0xFF00E5FF),
            ],
          ).createShader(bounds),
          child: const Text(
            'Expression Converter',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated Subtitle
class _AnimatedSubtitle extends StatelessWidget {
  final SplashAnimationController controller;

  const _AnimatedSubtitle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.contentFade,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00E5FF).withOpacity(0.1),
              const Color(0xFF0099FF).withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00E5FF).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          'Master Stack & Notation',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Modern Loading Indicator
class _ModernLoadingIndicator extends StatelessWidget {
  final SplashAnimationController controller;

  const _ModernLoadingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.contentFade,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                // Outer ring
                CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF00E5FF).withOpacity(0.3),
                  ),
                ),
                // Inner ring
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00E5FF),
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
            duration: 1500.ms,
            color: const Color(0xFF00E5FF).withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'INITIALIZING',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF00E5FF).withOpacity(0.7),
              letterSpacing: 4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Footer Information
class _FooterInfo extends StatelessWidget {
  final SplashAnimationController controller;

  const _FooterInfo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: controller.contentFade,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.code_rounded,
                    size: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Built with Flutter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated Particle Background
class _AnimatedParticleBackground extends StatelessWidget {
  final SplashAnimationController controller;

  const _AnimatedParticleBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.particleFlow,
      builder: (context, child) {
        return CustomPaint(
          painter: _EnhancedParticlesPainter(
            progress: controller.particleFlow.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Enhanced Particles Painter - Creates animated background particles
class _EnhancedParticlesPainter extends CustomPainter {
  final double progress;

  _EnhancedParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Layer 1: Large slow particles
    for (int i = 0; i < 15; i++) {
      final x = (i * 100.0 + progress * 50) % size.width;
      final y = ((i * 120.0 + progress * 80) % size.height);
      final opacity = (1 - (y / size.height)).clamp(0.0, 0.2);

      paint.color = Color.lerp(
        const Color(0xFF00E5FF),
        const Color(0xFF0099FF),
        i / 15,
      )!.withOpacity(opacity);

      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }

    // Layer 2: Small fast particles
    for (int i = 0; i < 40; i++) {
      final x = (i * 40.0 + progress * 150) % size.width;
      final y = ((i * 60.0 + progress * 200) % size.height);
      final opacity = (1 - (y / size.height)).clamp(0.0, 0.15);

      paint.color = const Color(0xFF00E5FF).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 1.0, paint);
    }

    // Layer 3: Connection lines
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.5;

    for (int i = 0; i < 10; i++) {
      final x1 = (i * 120.0 + progress * 50) % size.width;
      final y1 = ((i * 150.0 + progress * 80) % size.height);
      final x2 = ((i + 1) * 120.0 + progress * 50) % size.width;
      final y2 = (((i + 1) * 150.0 + progress * 80) % size.height);

      paint.color = const Color(0xFF00E5FF).withOpacity(0.05);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnhancedParticlesPainter oldDelegate) => true;
}

/// Modern Grid Pattern Painter - Creates grid background
class _ModernGridPainter extends CustomPainter {
  final Color color;

  _ModernGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 25.0;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ModernGridPainter oldDelegate) => false;
}