import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';

class CubeDetailScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> details;
  final String example;
  final int faceIndex;

  const CubeDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.details,
    required this.example,
    required this.faceIndex,
  });

  @override
  State<CubeDetailScreen> createState() => _CubeDetailScreenState();
}

class _CubeDetailScreenState extends State<CubeDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _cubeRotationController;
  late AnimationController _contentController;
  late AnimationController _particleController;

  double _rotationY = 0.0;
  bool _showMiniCube = true;

  final List<Map<String, dynamic>> _stepByStepExamples = [];
  final List<String> _keyPoints = [];
  final List<Map<String, String>> _relatedConcepts = [];

  @override
  void initState() {
    super.initState();

    _cubeRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _cubeRotationController.addListener(() {
      if (mounted) {
        setState(() {
          _rotationY = _cubeRotationController.value * math.pi * 2;
        });
      }
    });

    _loadContentBasedOnFace();
  }

  void _loadContentBasedOnFace() {
    switch (widget.faceIndex) {
      case 0: // Infix to Postfix
        _stepByStepExamples.addAll([
          {
            'step': 'Step 1',
            'description': 'Scan expression from left to right',
            'example': 'A + B * C',
            'action': 'Start scanning...',
          },
          {
            'step': 'Step 2',
            'description': 'Operands go directly to output',
            'example': 'A → Output: A',
            'action': 'Push A to output',
          },
          {
            'step': 'Step 3',
            'description': 'Operators go to stack (check precedence)',
            'example': '+ → Stack: [+]',
            'action': 'Push + to stack',
          },
          {
            'step': 'Step 4',
            'description': 'Continue with next operand',
            'example': 'B → Output: AB',
            'action': 'Push B to output',
          },
          {
            'step': 'Step 5',
            'description': '* has higher precedence than +',
            'example': '* → Stack: [+, *]',
            'action': 'Push * to stack',
          },
          {
            'step': 'Step 6',
            'description': 'Last operand to output',
            'example': 'C → Output: ABC',
            'action': 'Push C to output',
          },
          {
            'step': 'Step 7',
            'description': 'Pop all operators from stack',
            'example': 'Result: ABC*+',
            'action': 'Final result!',
          },
        ]);

        _keyPoints.addAll([
          '🎯 Always scan left to right',
          '📤 Operands directly to output',
          '📊 Check operator precedence',
          '🔄 Higher precedence = push to stack',
          '✅ Pop all at the end',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'Stack Operations', 'description': 'Push & Pop mechanics'},
          {'concept': 'Operator Precedence', 'description': 'Priority rules'},
          {'concept': 'Expression Trees', 'description': 'Visual representation'},
        ]);
        break;

      case 1: // Infix to Prefix
        _stepByStepExamples.addAll([
          {
            'step': 'Step 1',
            'description': 'Reverse the infix expression',
            'example': 'A + B * C → C * B + A',
            'action': 'Reverse input',
          },
          {
            'step': 'Step 2',
            'description': 'Swap ( with ) and vice versa',
            'example': '(A + B) → )A + B(',
            'action': 'Swap parentheses',
          },
          {
            'step': 'Step 3',
            'description': 'Apply Infix to Postfix algorithm',
            'example': 'Convert to postfix',
            'action': 'Use postfix rules',
          },
          {
            'step': 'Step 4',
            'description': 'Reverse the result',
            'example': 'CB*A+ → +A*BC',
            'action': 'Final reverse',
          },
        ]);

        _keyPoints.addAll([
          '🔄 Reverse input first',
          '↔️ Swap parentheses',
          '⚙️ Apply postfix algorithm',
          '🔙 Reverse result',
          '✨ Polish notation achieved',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'String Reversal', 'description': 'Core technique'},
          {'concept': 'Postfix Conversion', 'description': 'Intermediate step'},
          {'concept': 'Polish Notation', 'description': 'Historical context'},
        ]);
        break;

      case 2: // Postfix to Infix
        _stepByStepExamples.addAll([
          {
            'step': 'Step 1',
            'description': 'Scan postfix left to right',
            'example': 'ABC*+',
            'action': 'Start scanning',
          },
          {
            'step': 'Step 2',
            'description': 'Push operands to stack',
            'example': 'Stack: [A, B, C]',
            'action': 'Push A, B, C',
          },
          {
            'step': 'Step 3',
            'description': 'When operator found, pop 2 operands',
            'example': 'Pop C, B for *',
            'action': 'Pop 2 elements',
          },
          {
            'step': 'Step 4',
            'description': 'Create infix: (operand1 op operand2)',
            'example': '(B*C)',
            'action': 'Combine with parentheses',
          },
          {
            'step': 'Step 5',
            'description': 'Push result back to stack',
            'example': 'Stack: [A, (B*C)]',
            'action': 'Push combined result',
          },
          {
            'step': 'Step 6',
            'description': 'Continue until end',
            'example': 'Result: (A+(B*C))',
            'action': 'Final infix expression',
          },
        ]);

        _keyPoints.addAll([
          '👀 Scan left to right',
          '📚 Use stack for operands',
          '🔧 Pop 2 for each operator',
          '🎭 Add parentheses',
          '♻️ Push result back',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'Stack Data Structure', 'description': 'LIFO principle'},
          {'concept': 'Expression Building', 'description': 'Reconstruct syntax'},
          {'concept': 'Parenthesization', 'description': 'Proper grouping'},
        ]);
        break;

      case 3: // Prefix to Infix
        _stepByStepExamples.addAll([
          {
            'step': 'Step 1',
            'description': 'Scan prefix RIGHT to LEFT',
            'example': '+A*BC → C → B → * → A → +',
            'action': 'Reverse scanning',
          },
          {
            'step': 'Step 2',
            'description': 'Push operands to stack',
            'example': 'Stack: [C, B]',
            'action': 'Push operands',
          },
          {
            'step': 'Step 3',
            'description': 'When operator found, pop 2 operands',
            'example': 'Pop B, C for *',
            'action': 'Pop in order',
          },
          {
            'step': 'Step 4',
            'description': 'Create infix: (operand1 op operand2)',
            'example': '(B*C)',
            'action': 'Combine properly',
          },
          {
            'step': 'Step 5',
            'description': 'Push result back',
            'example': 'Stack: [(B*C), A]',
            'action': 'Continue process',
          },
          {
            'step': 'Step 6',
            'description': 'Process remaining operators',
            'example': 'Result: (A+(B*C))',
            'action': 'Complete conversion',
          },
        ]);

        _keyPoints.addAll([
          '⬅️ Scan RIGHT to LEFT',
          '📦 Stack for storage',
          '🎯 Maintain operand order',
          '🔗 Combine with parentheses',
          '✅ Pop order matters',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'Reverse Processing', 'description': 'Key difference'},
          {'concept': 'Stack Operations', 'description': 'Core mechanism'},
          {'concept': 'Polish Notation', 'description': 'Historical prefix'},
        ]);
        break;

      case 4: // Stack Structure
        _stepByStepExamples.addAll([
          {
            'step': 'Push Operation',
            'description': 'Add element to top',
            'example': 'Push(A) → [A]',
            'action': 'Add to top',
          },
          {
            'step': 'Push More',
            'description': 'Stack grows upward',
            'example': 'Push(B) → [A, B]',
            'action': 'Stack increases',
          },
          {
            'step': 'Peek Operation',
            'description': 'View top without removing',
            'example': 'Peek() → B',
            'action': 'Non-destructive read',
          },
          {
            'step': 'Pop Operation',
            'description': 'Remove and return top',
            'example': 'Pop() → B, Stack: [A]',
            'action': 'Remove top element',
          },
          {
            'step': 'Is Empty',
            'description': 'Check if stack has elements',
            'example': 'isEmpty() → false',
            'action': 'Boolean check',
          },
        ]);

        _keyPoints.addAll([
          '📚 LIFO - Last In First Out',
          '⬆️ Push adds to top',
          '⬇️ Pop removes from top',
          '👁️ Peek views without removal',
          '🔍 Check isEmpty() before pop',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'Arrays vs Linked List', 'description': 'Implementation'},
          {'concept': 'Time Complexity', 'description': 'O(1) operations'},
          {'concept': 'Applications', 'description': 'Expression evaluation'},
        ]);
        break;

      case 5: // Precedence Rules
        _stepByStepExamples.addAll([
          {
            'step': 'Level 1: Highest',
            'description': 'Exponentiation (^)',
            'example': '2^3^2 = 2^(3^2) = 512',
            'action': 'Right associative',
          },
          {
            'step': 'Level 2: Medium',
            'description': 'Multiplication and Division (* /)',
            'example': 'A*B/C = (A*B)/C',
            'action': 'Left to right',
          },
          {
            'step': 'Level 3: Lowest',
            'description': 'Addition and Subtraction (+ -)',
            'example': 'A+B-C = (A+B)-C',
            'action': 'Left to right',
          },
          {
            'step': 'Parentheses',
            'description': 'Override all precedence',
            'example': '(A+B)*C ≠ A+B*C',
            'action': 'Highest priority',
          },
        ]);

        _keyPoints.addAll([
          '🔝 ^ (Exponent) - Highest',
          '➗ *, / (Multiply, Divide) - Medium',
          '➕ +, - (Add, Subtract) - Lowest',
          '🎯 () overrides everything',
          '↔️ Same level = left to right',
        ]);

        _relatedConcepts.addAll([
          {'concept': 'PEMDAS/BODMAS', 'description': 'Memory aids'},
          {'concept': 'Associativity', 'description': 'Left vs Right'},
          {'concept': 'Expression Trees', 'description': 'Visual hierarchy'},
        ]);
        break;
    }
  }

  @override
  void dispose() {
    _cubeRotationController.dispose();
    _contentController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    if (_showMiniCube) _buildMiniCube(),
                    _buildMainContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: widget.color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showMiniCube ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _showMiniCube = !_showMiniCube;
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: FloatingParticlesPainter(
                    progress: _particleController.value,
                    color: Colors.white.withOpacity(0.2),
                  ),
                );
              },
            ),
            Positioned(
              right: 20,
              top: 60,
              child: Icon(
                widget.icon,
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMiniCube() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      child: Center(
        child: AnimatedBuilder(
          animation: _cubeRotationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(-0.3)
                ..rotateY(_rotationY),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().scale(duration: 600.ms).fadeIn();
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('📚 Overview', widget.color),
          const SizedBox(height: 16),
          _buildOverviewCard(),
          const SizedBox(height: 32),

          _buildSectionTitle('🎯 Key Points', widget.color),
          const SizedBox(height: 16),
          ..._keyPoints.map((point) => _buildKeyPointItem(point)),
          const SizedBox(height: 32),

          _buildSectionTitle('📖 Step-by-Step Example', widget.color),
          const SizedBox(height: 16),
          ..._stepByStepExamples.asMap().entries.map(
                (entry) => _buildStepCard(entry.value, entry.key),
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('🔗 Related Concepts', widget.color),
          const SizedBox(height: 16),
          ..._relatedConcepts.map((concept) => _buildRelatedConceptCard(concept)),
          const SizedBox(height: 32),

          _buildTryItButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.1),
            widget.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.details.map((detail) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: widget.color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detail,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.example,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildKeyPointItem(String point) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.color.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              point,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildStepCard(Map<String, dynamic> step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['step'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['description'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      step['example'],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.play_arrow, color: widget.color, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        step['action'],
                        style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildRelatedConceptCard(Map<String, String> concept) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.1),
            widget.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.link, color: widget.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concept['concept']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  concept['description']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: widget.color, size: 16),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }

  Widget _buildTryItButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.color, widget.color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          // Go back and switch to converter tab
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_filled, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              'Try it in Converter',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).scale();
  }
}

// Custom painter for floating particles
class FloatingParticlesPainter extends CustomPainter {
  final double progress;
  final Color color;

  FloatingParticlesPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i * 37.5) % size.width;
      final y = ((progress * size.height) + (i * 50)) % size.height;
      final opacity = (1 - (y / size.height)).clamp(0.0, 1.0);

      paint.color = color.withOpacity(opacity * 0.6);

      canvas.drawCircle(
        Offset(x, y),
        3 + (i % 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FloatingParticlesPainter oldDelegate) => true;
}