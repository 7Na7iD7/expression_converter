import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';
import 'cube_detail_screen.dart';

class CubeFaceData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> details;
  final String example;
  final List<String> realWorldApps;
  final List<String> companies;
  final String whyItMatters;
  final String funFact;

  CubeFaceData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.details,
    required this.example,
    required this.realWorldApps,
    required this.companies,
    required this.whyItMatters,
    required this.funFact,
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
  late AnimationController _portalController;

  double _rotationX = -0.5;
  double _rotationY = 0.0;
  double _lastRotationY = 0.0;
  bool _autoRotate = true;
  int? _selectedFace;
  bool _showingPortal = false;

  final List<Offset> _particles = [];

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _portalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

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
        random.nextDouble() * 600 - 300,
        random.nextDouble() * 600 - 300,
      ));
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _portalController.dispose();
    super.dispose();
  }

  List<CubeFaceData> _getCubeFaces(AppLocalizations l10n) {
    return [
      CubeFaceData(
        title: l10n.translate('cube_title_0'),
        subtitle: l10n.translate('cube_subtitle_0'),
        icon: Icons.arrow_forward,
        color: const Color(0xFF2196F3),
        details: [
          'Operators after operands',
          'No parentheses needed',
          'Left-to-right evaluation',
          'Stack-based processing',
        ],
        example: 'A+B*C → ABC*+',
        realWorldApps: [
          'Compilers & Interpreters',
          'Scientific Calculators',
          'Expression Evaluators',
          'JavaScript V8 Engine',
        ],
        companies: [
          'Google (V8 Engine)',
          'GCC Compiler',
          'LLVM Project',
          'Java Bytecode',
        ],
        whyItMatters: 'Expression evaluation in JavaScript and modern compilers relies on postfix notation for efficient computation without ambiguity.',
        funFact: 'Every time you use a calculator app, it converts your expression to postfix behind the scenes!',
      ),
      CubeFaceData(
        title: l10n.translate('cube_title_1'),
        subtitle: l10n.translate('cube_subtitle_1'),
        icon: Icons.arrow_upward,
        color: const Color(0xFF4CAF50),
        details: [
          'Operators before operands',
          'Right-to-left evaluation',
          'Polish notation system',
          'Efficient for compilers',
        ],
        example: 'A+B*C → +A*BC',
        realWorldApps: [
          'LISP Programming',
          'AI & Expert Systems',
          'Functional Programming',
          'Symbolic Math Systems',
        ],
        companies: [
          'Symbolics (LISP Machines)',
          'Mathematica',
          'Maple CAS',
          'Clojure Language',
        ],
        whyItMatters: 'Functional programming languages like LISP are built on prefix notation, making it fundamental to AI research.',
        funFact: 'Named after Polish mathematician Jan Łukasiewicz who invented it in 1924 - before computers even existed!',
      ),
      CubeFaceData(
        title: l10n.translate('cube_title_2'),
        subtitle: l10n.translate('cube_subtitle_2'),
        icon: Icons.arrow_back,
        color: const Color(0xFFFF9800),
        details: [
          'Reconstruct parentheses',
          'Pop and combine operands',
          'Stack-based approach',
          'Human-readable output',
        ],
        example: 'ABC*+ → A+(B*C)',
        realWorldApps: [
          'Reverse Engineering',
          'Decompilers',
          'Code Analysis Tools',
          'Assembly to C Conversion',
        ],
        companies: [
          'IDA Pro (Hex-Rays)',
          'Ghidra (NSA)',
          'Binary Ninja',
          'Hopper Disassembler',
        ],
        whyItMatters: 'When reverse engineering software, decompilers convert low-level postfix operations back to readable code.',
        funFact: 'Security researchers use this to understand malware by converting machine code back to human-readable form!',
      ),
      CubeFaceData(
        title: l10n.translate('cube_title_3'),
        subtitle: l10n.translate('cube_subtitle_3'),
        icon: Icons.arrow_downward,
        color: const Color(0xFF9C27B0),
        details: [
          'Right-to-left scanning',
          'Reverse Polish notation',
          'Build expression tree',
          'Add necessary parentheses',
        ],
        example: '+A*BC → A+(B*C)',
        realWorldApps: [
          'LISP to C Converters',
          'Functional to Imperative',
          'Math Expression Parsers',
          'Academic Research Tools',
        ],
        companies: [
          'Racket Language',
          'MIT Scheme',
          'Common LISP Compilers',
          'Wolfram Research',
        ],
        whyItMatters: 'Converting between programming paradigms requires understanding prefix-to-infix transformation.',
        funFact: 'The challenge is handling deeply nested expressions like (+ (* 2 3) (/ 8 4)) correctly!',
      ),
      CubeFaceData(
        title: l10n.translate('cube_title_4'),
        subtitle: l10n.translate('cube_subtitle_4'),
        icon: Icons.layers,
        color: const Color(0xFFE91E63),
        details: [
          'Last In First Out (LIFO)',
          'Push & Pop operations',
          'Top element access only',
          'Expression evaluation core',
        ],
        example: 'Push(A) Push(B) Pop() → B',
        realWorldApps: [
          'Browser Back Button',
          'Undo/Redo Systems',
          'Function Call Stack',
          'Memory Management',
        ],
        companies: [
          'All Web Browsers',
          'Operating Systems',
          'CPU Architecture',
          'Adobe Creative Suite',
        ],
        whyItMatters: 'Every function call in your program uses a stack - it\'s the foundation of program execution!',
        funFact: 'When you press Ctrl+Z, you\'re popping from an undo stack. Stack overflow? That\'s when the stack gets too deep!',
      ),
      CubeFaceData(
        title: l10n.translate('cube_title_5'),
        subtitle: l10n.translate('cube_subtitle_5'),
        icon: Icons.format_list_numbered,
        color: const Color(0xFFFFEB3B),
        details: [
          '^ (Power) - Highest priority',
          '*, / - Medium priority',
          '+, - - Lowest priority',
          '() - Override all rules',
        ],
        example: 'A+B*C = A+(B*C)',
        realWorldApps: [
          'Math Expression Parsers',
          'Spreadsheet Formulas',
          'Calculator Apps',
          'Programming Languages',
        ],
        companies: [
          'Microsoft Excel',
          'Google Sheets',
          'MATLAB',
          'Wolfram Alpha',
        ],
        whyItMatters: 'Spreadsheet formulas in Excel use these exact rules - wrong precedence means wrong calculations!',
        funFact: 'Excel had a famous bug where -2^2 gave 4 instead of -4 due to precedence handling!',
      ),
    ];
  }

  void _openDetailScreen(CubeFaceData data, int index) {
    setState(() {
      _showingPortal = true;
    });

    _portalController.forward().then((_) {
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
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ).then((_) {
        _portalController.reverse();
        setState(() {
          _showingPortal = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubeFaces = _getCubeFaces(l10n);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(l10n),
                Expanded(
                  child: Stack(
                    children: [
                      _buildParticleBackground(),
                      _buildCubeContainer(cubeFaces),
                      if (_selectedFace != null && !_showingPortal)
                        _buildEnhancedQuickPanel(cubeFaces[_selectedFace!], l10n),
                    ],
                  ),
                ),
                _buildControls(l10n),
              ],
            ),
            if (_showingPortal) _buildPortalEffect(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('cube_3d_title'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.translate('cube_3d_explore'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade400,
                      Colors.blue.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.hub, color: Colors.white, size: 28),
              ),
            ],
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
          painter: EnhancedParticlePainter(
            particles: _particles,
            progress: _particleController.value,
            color: Theme.of(context).colorScheme.primary,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildCubeContainer(List<CubeFaceData> faces) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _autoRotate = false;
          _rotationY += details.delta.dx * 0.01;
          _rotationX += details.delta.dy * 0.01;
          _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
        });
      },
      onPanEnd: (details) {
        _lastRotationY = _rotationY;
      },
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController]),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotationX)
                ..rotateY(_rotationY),
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  children: [
                    _buildCubeFace(faces[0], 0, 0, 0, 140, 0, l10n),
                    _buildCubeFace(faces[1], 0, math.pi, 0, 140, 1, l10n),
                    _buildCubeFace(faces[2], 0, math.pi / 2, 0, 140, 2, l10n),
                    _buildCubeFace(faces[3], 0, -math.pi / 2, 0, 140, 3, l10n),
                    _buildCubeFace(faces[4], -math.pi / 2, 0, 0, 140, 4, l10n),
                    _buildCubeFace(faces[5], math.pi / 2, 0, 0, 140, 5, l10n),
                  ],
                ),
              ),
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
      AppLocalizations l10n,
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
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.color,
                  data.color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.color.withOpacity(0.5),
                  blurRadius: isSelected ? 30 : 20,
                  spreadRadius: isSelected ? 5 : 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: GridPatternPainter(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          data.icon,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 12),
                        Container(
                          key: ValueKey('hint_$index'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.open_in_full, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                l10n.translate('cube_3d_double_tap'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(
                          key: ValueKey('hint_anim_$index'),
                          onPlay: (controller) => controller.repeat(),
                        )
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

  Widget _buildEnhancedQuickPanel(CubeFaceData data, AppLocalizations l10n) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        key: ValueKey('panel_${_selectedFace}'),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.6),
              blurRadius: 40,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          data.color.withOpacity(0.95 + _pulseController.value * 0.05),
                          data.color.withOpacity(0.85 + _pulseController.value * 0.05),
                          data.color.withOpacity(0.75),
                        ],
                      ),
                    ),
                  );
                },
              ),

              Positioned.fill(
                child: CustomPaint(
                  painter: MiniParticlePainter(
                    color: Colors.white.withOpacity(0.1),
                    progress: _pulseController.value,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(data.icon, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _selectedFace = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.business, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.companies.take(2).join(' • ')} +${data.companies.length - 2}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('cube_did_you_know'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data.funFact,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                _openDetailScreen(data, _selectedFace!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.rocket_launch, color: data.color, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    l10n.translate('cube_explore_world'),
                                    style: TextStyle(
                                      color: data.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      )
          .animate()
          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
          .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack)
          .scale(
        begin: const Offset(0.85, 0.85),
        end: const Offset(1, 1),
        curve: Curves.easeOutBack,
      ),
    );
  }

  Widget _buildPortalEffect() {
    return AnimatedBuilder(
      animation: _portalController,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(_portalController.value * 0.7),
          child: Center(
            child: Transform.scale(
              scale: _portalController.value * 3,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purple.withOpacity(0.8),
                      Colors.blue.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: _autoRotate ? Icons.pause : Icons.play_arrow,
            label: _autoRotate ? l10n.translate('cube_pause') : l10n.translate('cube_auto'),
            color: Colors.blue,
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
            label: l10n.translate('cube_reset'),
            color: Colors.green,
            onPressed: () {
              setState(() {
                _rotationX = -0.5;
                _rotationY = 0.0;
                _lastRotationY = 0.0;
                _selectedFace = null;
                _autoRotate = true;
              });
            },
          ),
          _buildControlButton(
            icon: Icons.info_outline,
            label: l10n.translate('cube_guide'),
            color: Colors.orange,
            onPressed: () {
              _showGuideDialog(l10n);
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
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
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
        ),
      ),
    );
  }

  void _showGuideDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.blue),
            const SizedBox(width: 12),
            Text(l10n.translate('cube_guide_title')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideItem(Icons.touch_app, l10n.translate('cube_guide_drag')),
            _buildGuideItem(Icons.tap_and_play, l10n.translate('cube_guide_tap')),
            _buildGuideItem(Icons.open_in_full, l10n.translate('cube_guide_double')),
            _buildGuideItem(Icons.business, l10n.translate('cube_guide_companies')),
            _buildGuideItem(Icons.lightbulb, l10n.translate('cube_guide_facts')),
            _buildGuideItem(Icons.explore, l10n.translate('cube_guide_explore')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate('cube_guide_start')),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class EnhancedParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final double progress;
  final Color color;

  EnhancedParticlePainter({
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
      final animatedY = particle.dy + (progress * 300) % 600 - 300;
      final animatedX = particle.dx + math.sin(progress * math.pi * 2 + i) * 20;
      final opacity = (1 - (animatedY.abs() / 300)).clamp(0.0, 1.0);

      final size1 = 2 + (i % 4).toDouble();

      paint.color = color.withOpacity(opacity * 0.2);

      canvas.drawCircle(
        Offset(
          size.width / 2 + animatedX,
          size.height / 2 + animatedY,
        ),
        size1,
        paint,
      );

      paint.color = color.withOpacity(opacity * 0.1);
      canvas.drawCircle(
        Offset(
          size.width / 2 + animatedX,
          size.height / 2 + animatedY,
        ),
        size1 * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedParticlePainter oldDelegate) => true;
}

class GridPatternPainter extends CustomPainter {
  final Color color;

  GridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    paint.strokeWidth = 0.5;
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GridPatternPainter oldDelegate) => false;
}

class MiniParticlePainter extends CustomPainter {
  final Color color;
  final double progress;

  MiniParticlePainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final x = (i * 30.0 + progress * 20) % size.width;
      final y = (i * 40.0 + progress * 30) % size.height;
      final radius = 2 + (i % 3).toDouble();

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant MiniParticlePainter oldDelegate) => true;
}