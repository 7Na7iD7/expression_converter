import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';
import 'cube_detail_screen.dart';

// Model for each cube face
class CubeFaceData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> details;
  final String example;

  CubeFaceData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.details,
    required this.example,
  });
}

class Interactive3DCubeScreen extends StatefulWidget {
  const Interactive3DCubeScreen({super.key});

  @override
  State<Interactive3DCubeScreen> createState() => _Interactive3DCubeScreenState();
}

class _Interactive3DCubeScreenState extends State<Interactive3DCubeScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  double _rotationX = -0.5;
  double _rotationY = 0.0;
  double _lastRotationY = 0.0;
  bool _autoRotate = true;
  int? _selectedFace;

  // متغیرهای مربوط به زوم
  double _scale = 1.0;
  double _baseScale = 1.0;

  final List<Offset> _particles = [];

  @override
  void initState() {
    super.initState();

    // Main rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Pulse animation for selected face
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Generate random particles
    _generateParticles();

    _rotationController.addListener(() {
      if (_autoRotate && mounted) {
        setState(() {
          _rotationY = _lastRotationY + _rotationController.value * math.pi * 2;
        });
      }
    });
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(Offset(
        random.nextDouble() * 400 - 200,
        random.nextDouble() * 400 - 200,
      ));
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  List<CubeFaceData> _getCubeFaces(AppLocalizations? l10n) {
    // اگر لوکالایزیشن نال بود، مقادیر پیش‌فرض نمایش داده می‌شود
    return [
      CubeFaceData(
        title: 'Infix → Postfix',
        subtitle: 'Natural to Stack-based',
        icon: Icons.arrow_forward,
        color: const Color(0xFF2196F3),
        details: [
          'Operators after operands',
          'No parentheses needed',
          'Left-to-right evaluation',
          'Stack-based processing',
        ],
        example: 'A+B*C → ABC*+',
      ),
      CubeFaceData(
        title: 'Infix → Prefix',
        subtitle: 'Natural to Polish',
        icon: Icons.arrow_upward,
        color: const Color(0xFF4CAF50),
        details: [
          'Operators before operands',
          'Right-to-left evaluation',
          'Polish notation',
          'Efficient for compilers',
        ],
        example: 'A+B*C → +A*BC',
      ),
      CubeFaceData(
        title: 'Postfix → Infix',
        subtitle: 'Stack to Natural',
        icon: Icons.arrow_back,
        color: const Color(0xFFFF9800),
        details: [
          'Reconstruct parentheses',
          'Pop and combine',
          'Stack-based approach',
          'Human-readable result',
        ],
        example: 'ABC*+ → A+B*C',
      ),
      CubeFaceData(
        title: 'Prefix → Infix',
        subtitle: 'Polish to Natural',
        icon: Icons.arrow_downward,
        color: const Color(0xFF9C27B0),
        details: [
          'Right-to-left scan',
          'Reverse polish notation',
          'Build expression tree',
          'Add necessary parentheses',
        ],
        example: '+A*BC → A+B*C',
      ),
      CubeFaceData(
        title: 'Stack Structure',
        subtitle: 'LIFO Data Structure',
        icon: Icons.layers,
        color: const Color(0xFFE91E63),
        details: [
          'Last In First Out',
          'Push & Pop operations',
          'Top element access',
          'Expression evaluation',
        ],
        example: 'Push(A) Push(B) Pop() → B',
      ),
      CubeFaceData(
        title: 'Precedence Rules',
        subtitle: 'Operator Priority',
        icon: Icons.format_list_numbered,
        color: const Color(0xFFFFEB3B),
        details: [
          '^ has highest priority',
          '*, / medium priority',
          '+, - lowest priority',
          '() override all',
        ],
        example: 'A+B*C = A+(B*C)',
      ),
    ];
  }

  void _openDetailScreen(CubeFaceData data, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CubeDetailScreen(
          title: data.title,
          subtitle: data.subtitle,
          icon: data.icon,
          color: data.color,
          details: data.details,
          example: data.example,
          faceIndex: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubeFaces = _getCubeFaces(l10n);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0F1E),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(l10n),
              Expanded(
                child: Stack(
                  children: [
                    _buildParticleBackground(),
                    _buildCubeContainer(cubeFaces),
                    if (_selectedFace != null)
                      _buildQuickActionPanel(cubeFaces[_selectedFace!]),
                  ],
                ),
              ),
              _buildControls(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3D Visualization',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.blue.withOpacity(0.5),
                      offset: const Offset(0, 0),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap any face to explore',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade400,
                      Colors.blue.shade400,
                      Colors.cyan.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3 + _glowController.value * 0.3),
                      blurRadius: 15 + _glowController.value * 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.view_in_ar, color: Colors.white, size: 28),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _particleController.value,
            color: Colors.cyan,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildCubeContainer(List<CubeFaceData> faces) {
    // بهینه سازی: ساخت محتوای مکعب خارج از بیلدر انیمیشن
    // این کار باعث می‌شود با هر فریم انیمیشن، ویجت‌ها دوباره ساخته نشوند
    final cubeContent = SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          _buildCubeFace(faces[0], 0, 0, 0, 150, 0), // Front
          _buildCubeFace(faces[1], 0, math.pi, 0, 150, 1), // Back
          _buildCubeFace(faces[2], 0, math.pi / 2, 0, 150, 2), // Right
          _buildCubeFace(faces[3], 0, -math.pi / 2, 0, 150, 3), // Left
          _buildCubeFace(faces[4], -math.pi / 2, 0, 0, 150, 4), // Top
          _buildCubeFace(faces[5], math.pi / 2, 0, 0, 150, 5), // Bottom
        ],
      ),
    );

    return Center(
      child: GestureDetector(
        // استفاده از Scale برای هم هندل کردن زوم و هم چرخش
        onScaleStart: (details) {
          _baseScale = _scale;
          setState(() {
            _autoRotate = false;
          });
        },
        onScaleUpdate: (details) {
          setState(() {
            // چرخش با استفاده از حرکت انگشت
            _rotationY += details.focalPointDelta.dx * 0.01;
            _rotationX += details.focalPointDelta.dy * 0.01;
            _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);

            // زوم
            _scale = (_baseScale * details.scale).clamp(0.5, 2.0);
          });
        },
        onScaleEnd: (details) {
          _lastRotationY = _rotationY;
        },

        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController]),
          // پاس دادن محتوای ثابت به عنوان child
          child: cubeContent,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotationX)
                ..rotateY(_rotationY)
                ..scale(_scale),
              // استفاده از child کش شده برای جلوگیری از خطای Assertion
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCubeFace(
      CubeFaceData data,
      double rotateX,
      double rotateY,
      double rotateZ,
      double translateZ,
      int index,
      ) {
    final isSelected = _selectedFace == index;
    final scale = isSelected ? 1.0 + (_pulseController.value * 0.1) : 1.0;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(rotateX)
        ..rotateY(rotateY)
        ..rotateZ(rotateZ)
        ..translate(0.0, 0.0, translateZ),
      child: Transform.scale(
        scale: scale,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedFace = _selectedFace == index ? null : index;
              _autoRotate = false;
            });
          },
          onDoubleTap: () {
            _openDetailScreen(data, index);
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.color,
                  data.color.withOpacity(0.7),
                  data.color.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.6),
                  blurRadius: isSelected ? 40 : 25,
                  spreadRadius: isSelected ? 8 : 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated grid background - Note: Since we moved this out of main builder,
                // we need a separate AnimatedBuilder here if we want the grid lines to animate.
                // But keeping it simple to fix crash first.
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPatternPainter(
                      color: Colors.white.withOpacity(0.1),
                      offset: 0, // Static for now to improve performance
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        center: Alignment.topLeft,
                        radius: 1.5,
                      ),
                    ),
                  ),
                ),
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          data.icon,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.touch_app, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Double tap to explore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .fadeIn(duration: 800.ms)
                            .then()
                            .fadeOut(duration: 800.ms),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionPanel(CubeFaceData data) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              data.color.withOpacity(0.95),
              data.color.withOpacity(0.85),
              data.color.withOpacity(0.75),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.6),
              blurRadius: 30,
              offset: const Offset(0, 10),
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        data.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedFace = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data.example,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _openDetailScreen(data, _selectedFace!);
              },
              icon: const Icon(Icons.read_more),
              label: const Text('Learn More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: data.color,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.black38,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  Widget _buildControls(AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _autoRotate ? Icons.pause : Icons.play_arrow,
            label: _autoRotate ? 'Pause' : 'Auto',
            color: const Color(0xFF2196F3),
            onPressed: () {
              setState(() {
                _autoRotate = !_autoRotate;
                if (_autoRotate) {
                  _lastRotationY = _rotationY;
                  _rotationController.repeat();
                }
              });
            },
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            color: const Color(0xFF4CAF50),
            onPressed: () {
              setState(() {
                _rotationX = -0.5;
                _rotationY = 0.0;
                _lastRotationY = 0.0;
                _selectedFace = null;
                _autoRotate = true;
                _scale = 1.0;
              });
            },
          ),
          _buildControlButton(
            icon: Icons.zoom_in,
            label: 'Zoom',
            color: const Color(0xFFFF9800),
            onPressed: () {
              setState(() {
                _scale = (_scale + 0.2).clamp(0.5, 2.0);
              });
            },
          ),
          _buildControlButton(
            icon: Icons.info_outline,
            label: 'Guide',
            color: const Color(0xFF9C27B0),
            onPressed: () {
              _showGuideDialog();
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: color.withOpacity(0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showGuideDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.cyan, size: 28),
            SizedBox(width: 12),
            Text(
              'How to Use',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideItem(Icons.touch_app, 'Drag to rotate the cube', Colors.blue),
            _buildGuideItem(Icons.pinch, 'Pinch to zoom in/out', Colors.green),
            _buildGuideItem(Icons.tap_and_play, 'Single tap to select face', Colors.orange),
            _buildGuideItem(Icons.touch_app, 'Double tap for detailed view', Colors.purple),
            _buildGuideItem(Icons.auto_awesome, 'Auto-rotate mode available', Colors.cyan),
            _buildGuideItem(Icons.explore, 'Explore all 6 conversion concepts', Colors.pink),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Got it!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for particle background
class ParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final double progress;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final animatedY = particle.dy + (progress * 400) % 800 - 400;
      final animatedX = particle.dx + math.sin(progress * math.pi * 2 + i) * 30;
      final opacity = (1 - (animatedY.abs() / 400)).clamp(0.0, 1.0);

      paint.color = color.withOpacity(opacity * 0.2);

      // Create glowing effect
      canvas.drawCircle(
        Offset(
          size.width / 2 + animatedX,
          size.height / 2 + animatedY,
        ),
        3 + (i % 4).toDouble(),
        paint,
      );

      // Add glow halo
      paint.color = color.withOpacity(opacity * 0.1);
      canvas.drawCircle(
        Offset(
          size.width / 2 + animatedX,
          size.height / 2 + animatedY,
        ),
        6 + (i % 4).toDouble(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}

// Custom painter for animated grid pattern
class GridPatternPainter extends CustomPainter {
  final Color color;
  final double offset;

  GridPatternPainter({
    required this.color,
    this.offset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;
    final animatedOffset = offset % spacing;

    // Vertical lines with animation
    for (double i = -spacing + animatedOffset; i < size.width + spacing; i += spacing) {
      final opacity = (1 - (i - size.width / 2).abs() / (size.width / 2)).clamp(0.3, 1.0);
      paint.color = color.withOpacity(opacity * color.opacity);
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // Horizontal lines with animation
    for (double i = -spacing + animatedOffset; i < size.height + spacing; i += spacing) {
      final opacity = (1 - (i - size.height / 2).abs() / (size.height / 2)).clamp(0.3, 1.0);
      paint.color = color.withOpacity(opacity * color.opacity);
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw center cross highlight
    paint.color = color.withOpacity(0.3);
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GridPatternPainter oldDelegate) {
    return offset != oldDelegate.offset;
  }
}