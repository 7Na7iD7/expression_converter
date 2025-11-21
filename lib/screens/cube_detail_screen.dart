import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';

/// Interactive Concept World - Each face opens a unique interactive experience
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
  late AnimationController _worldController;
  late AnimationController _interactiveController;

  int _currentChallenge = 0;
  int _score = 0;
  bool _showingHint = false;

  // Interactive elements state
  String _userInput = '';
  bool _animatingSuccess = false;

  @override
  void initState() {
    super.initState();

    _worldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _interactiveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _worldController.dispose();
    _interactiveController.dispose();
    super.dispose();
  }

  // Get unique content for each face
  Map<String, dynamic> _getWorldContent() {
    switch (widget.faceIndex) {
      case 0: // Infix → Postfix - "Compiler World"
        return {
          'worldName': '🏭 Compiler Factory',
          'description': 'See how JavaScript engines process your code in real-time',
          'interactiveType': 'compiler_simulation',
          'challenges': [
            {
              'input': 'a + b',
              'correct': 'ab+',
              'hint': 'Operands first, then operator',
              'reward': 10,
            },
            {
              'input': 'a + b * c',
              'correct': 'abc*+',
              'hint': 'Remember: * has higher precedence',
              'reward': 15,
            },
            {
              'input': '(a + b) * c',
              'correct': 'ab+c*',
              'hint': 'Parentheses first!',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'V8 Engine Processing',
            'code': 'const result = x + y * z;',
            'steps': [
              'Parse: Tokenize expression',
              'Convert: x y z * +',
              'Stack: Push x, y, z',
              'Execute: Pop, multiply, add',
              'Result: Optimized bytecode',
            ],
          },
          'funFacts': [
            '💡 Every JavaScript calculation goes through postfix conversion',
            '🚀 V8 Engine processes millions of expressions per second',
            '⚡ Postfix notation eliminates parsing ambiguity',
          ],
        };

      case 1: // Infix → Prefix - "LISP World"
        return {
          'worldName': '🤖 AI Research Lab',
          'description': 'Experience how AI systems think in prefix notation',
          'interactiveType': 'lisp_playground',
          'challenges': [
            {
              'input': 'a + b',
              'correct': '+ab',
              'hint': 'Operator comes first in LISP',
              'reward': 10,
            },
            {
              'input': 'a * b + c',
              'correct': '+*abc',
              'hint': 'Start from the last operator',
              'reward': 15,
            },
            {
              'input': '(a + b) * (c - d)',
              'correct': '*+ab-cd',
              'hint': 'Process each group separately',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'LISP Code Evolution',
            'code': '(+ (* 2 3) (/ 8 4))',
            'steps': [
              'AI reads: + operator first',
              'Left branch: (* 2 3) = 6',
              'Right branch: (/ 8 4) = 2',
              'Combine: (+ 6 2) = 8',
              'Result: Symbolic computation',
            ],
          },
          'funFacts': [
            '🧠 Created by John McCarthy in 1958 for AI',
            '🎯 Still used in Clojure, Racket, and Emacs',
            '✨ Prefix notation is closer to how computers "think"',
          ],
        };

      case 2: // Postfix → Infix - "Reverse Engineer Lab"
        return {
          'worldName': '🔬 Decompiler Lab',
          'description': 'Reverse engineer machine code back to readable format',
          'interactiveType': 'reverse_engineering',
          'challenges': [
            {
              'input': 'ab+',
              'correct': 'a+b',
              'hint': 'Build expression from stack',
              'reward': 10,
            },
            {
              'input': 'abc*+',
              'correct': 'a+b*c',
              'hint': 'Remember precedence rules',
              'reward': 15,
            },
            {
              'input': 'ab+cd-*',
              'correct': '(a+b)*(c-d)',
              'hint': 'Two separate groups',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'Ghidra Decompilation',
            'code': 'Assembly: PUSH A, PUSH B, ADD',
            'steps': [
              'Scan bytecode: ab+',
              'Stack simulation: [a, b]',
              'Process +: pop b, a',
              'Reconstruct: (a + b)',
              'Result: Human-readable C code',
            ],
          },
          'funFacts': [
            '🛡️ NSA uses this in Ghidra for malware analysis',
            '🔍 Essential for understanding compiled programs',
            '⚙️ Helps find security vulnerabilities',
          ],
        };

      case 3: // Prefix → Infix - "Functional World"
        return {
          'worldName': '⚡ Functional Programming Arena',
          'description': 'Transform functional code to imperative style',
          'interactiveType': 'functional_converter',
          'challenges': [
            {
              'input': '+ab',
              'correct': 'a+b',
              'hint': 'Operator is already at the front',
              'reward': 10,
            },
            {
              'input': '*+abc',
              'correct': '(a+b)*c',
              'hint': 'Process from right to left',
              'reward': 15,
            },
            {
              'input': '+*ab-cd',
              'correct': 'a*b+c-d',
              'hint': 'Multiple operations nested',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'Racket to JavaScript',
            'code': '(* (+ 2 3) 4)',
            'steps': [
              'Read prefix: * + 2 3 4',
              'Parse inner: (+ 2 3)',
              'Convert: (2 + 3)',
              'Outer operation: * 4',
              'Result: (2 + 3) * 4',
            ],
          },
          'funFacts': [
            '📚 Used in academic language research',
            '🎓 MIT still teaches LISP in AI courses',
            '🔄 Bridges functional and imperative paradigms',
          ],
        };

      case 4: // Stack Structure - "Memory World"
        return {
          'worldName': '🏗️ Memory Architecture Zone',
          'description': 'Build and manipulate the stack like a CPU',
          'interactiveType': 'stack_builder',
          'challenges': [
            {
              'input': 'Push 3 items',
              'correct': 'ABC',
              'hint': 'Add elements one by one',
              'reward': 10,
            },
            {
              'input': 'Undo 2 operations',
              'correct': 'Pop twice',
              'hint': 'Remove from top',
              'reward': 15,
            },
            {
              'input': 'Evaluate: AB+',
              'correct': 'A+B',
              'hint': 'Use stack to solve',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'Browser Back Button',
            'code': 'Navigation: Home → About → Contact',
            'steps': [
              'Visit Home: Stack = [Home]',
              'Visit About: Stack = [Home, About]',
              'Visit Contact: Stack = [Home, About, Contact]',
              'Back button: Pop → About',
              'Back again: Pop → Home',
            ],
          },
          'funFacts': [
            '🌐 Every browser tab uses a stack for history',
            '💾 Function calls in ALL programs use stack',
            '⚠️ Stack Overflow = Too many function calls!',
          ],
        };

      case 5: // Precedence Rules - "Calculator World"
        return {
          'worldName': '🧮 Excel Formula Arena',
          'description': 'Master operator precedence like a spreadsheet pro',
          'interactiveType': 'precedence_puzzle',
          'challenges': [
            {
              'input': '2+3*4',
              'correct': '14',
              'hint': 'Multiplication first!',
              'reward': 10,
            },
            {
              'input': '10-2*3',
              'correct': '4',
              'hint': '* before -',
              'reward': 15,
            },
            {
              'input': '2^3^2',
              'correct': '512',
              'hint': 'Right associative!',
              'reward': 20,
            },
          ],
          'realWorldDemo': {
            'title': 'Excel Formula Bug',
            'code': '=A1+B1*C1',
            'steps': [
              'Excel reads: A1 + B1 * C1',
              'Step 1: Calculate B1 * C1 first',
              'Step 2: Add result to A1',
              'Common error: (A1+B1)*C1',
              'Fix: Use parentheses explicitly',
            ],
          },
          'funFacts': [
            '🐛 Excel once calculated -2^2 as 4 (bug fixed!)',
            '📊 PEMDAS = Please Excuse My Dear Aunt Sally',
            '🎯 Most spreadsheet errors come from wrong precedence',
          ],
        };

      default:
        return {
          'worldName': '🎯 Concept World',
          'description': 'Explore interactive concepts',
          'interactiveType': 'default',
          'challenges': [],
          'realWorldDemo': {
            'title': 'Demo',
            'code': 'Code example',
            'steps': ['Step 1'],
          },
          'funFacts': ['Fun fact'],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final worldContent = _getWorldContent();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.2),
              Colors.black87,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildWorldHeader(worldContent),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildWorldIntro(worldContent),
                    _buildInteractiveChallenge(worldContent),
                    _buildRealWorldDemo(worldContent),
                    _buildFunFacts(worldContent),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingScore(),
    );
  }

  Widget _buildWorldHeader(Map<String, dynamic> content) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: widget.color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          content['worldName'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 2),
                blurRadius: 8,
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
                    widget.color.withOpacity(0.6),
                    Colors.black87,
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _worldController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WorldBackgroundPainter(
                    progress: _worldController.value,
                    color: Colors.white.withOpacity(0.1),
                    faceIndex: widget.faceIndex,
                  ),
                );
              },
            ),
            Positioned(
              right: 20,
              top: 80,
              child: Transform.rotate(
                angle: _worldController.value * math.pi * 2,
                child: Icon(
                  widget.icon,
                  size: 120,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorldIntro(Map<String, dynamic> content) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.3),
            widget.color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(widget.icon, color: Colors.white, size: 60),
          const SizedBox(height: 16),
          Text(
            content['description'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  'Interactive Learning Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale();
  }

  Widget _buildInteractiveChallenge(Map<String, dynamic> content) {
    final challenges = content['challenges'] as List<Map<String, dynamic>>? ?? [];
    if (challenges.isEmpty || _currentChallenge >= challenges.length) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.green.shade700],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.emoji_events, color: Colors.white, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You\'ve completed all challenges!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentChallenge = 0;
                  _score = 0;
                  _userInput = '';
                  _showingHint = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn().scale();
    }

    final challenge = challenges[_currentChallenge];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${_currentChallenge + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Challenge',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+${challenge['reward']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.input, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    challenge['input'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            key: ValueKey('input_$_currentChallenge'),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'monospace',
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Your answer...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              filled: true,
              fillColor: Colors.black.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.color),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.color.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.color, width: 2),
              ),
              suffixIcon: Icon(Icons.edit, color: widget.color),
            ),
            onChanged: (value) {
              setState(() {
                _userInput = value;
              });
            },
            onSubmitted: (_) => _checkAnswer(challenge),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showingHint = !_showingHint;
                    });
                  },
                  icon: Icon(_showingHint ? Icons.visibility_off : Icons.lightbulb),
                  label: Text(_showingHint ? 'Hide Hint' : 'Show Hint'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _userInput.isEmpty ? null : () => _checkAnswer(challenge),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showingHint) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      challenge['hint'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_animatingSuccess) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.celebration, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Correct! Amazing work! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().shake(),
          ],
        ],
      ),
    );
  }

  void _checkAnswer(Map<String, dynamic> challenge) {
    final correct = challenge['correct'].toString().toLowerCase();
    final userAnswer = _userInput.trim().toLowerCase();

    if (userAnswer == correct) {
      setState(() {
        _animatingSuccess = true;
        _score += challenge['reward'] as int;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _animatingSuccess = false;
            _currentChallenge++;
            _userInput = '';
            _showingHint = false;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again! Think about the hint.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildRealWorldDemo(Map<String, dynamic> content) {
    final demo = content['realWorldDemo'] as Map<String, dynamic>?;
    if (demo == null) return Container();

    final steps = demo['steps'] as List<String>? ?? [];

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.computer, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Real-World Demo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            demo['title'] ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              demo['code'] ?? '',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: entry.key * 100))
                .fadeIn()
                .slideX(begin: -0.2, end: 0);
          }),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms);
  }

  Widget _buildFunFacts(Map<String, dynamic> content) {
    final facts = content['funFacts'] as List<String>? ?? [];
    if (facts.isEmpty) return Container();

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber, size: 28),
              SizedBox(width: 12),
              Text(
                'Fun Facts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...facts.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.2),
                    Colors.orange.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Text(
                entry.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ).animate(delay: Duration(milliseconds: entry.key * 150))
                .fadeIn()
                .slideY(begin: 0.3, end: 0);
          }),
        ],
      ),
    );
  }

  Widget _buildFloatingScore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            '$_score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'pts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      duration: 1500.ms,
      begin: const Offset(1, 1),
      end: const Offset(1.05, 1.05),
    );
  }
}

/// Custom painter for world-specific backgrounds
class WorldBackgroundPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int faceIndex;

  WorldBackgroundPainter({
    required this.progress,
    required this.color,
    required this.faceIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (faceIndex) {
      case 0: // Compiler Factory - Grid pattern
        _drawGridPattern(canvas, size, paint);
        break;
      case 1: // AI Lab - Neural network
        _drawNeuralNetwork(canvas, size, paint);
        break;
      case 2: // Reverse Engineer - Circuit board
        _drawCircuitBoard(canvas, size, paint);
        break;
      case 3: // Functional - Lambda symbols
        _drawLambdaPattern(canvas, size, paint);
        break;
      case 4: // Memory - Stack layers
        _drawStackLayers(canvas, size, paint);
        break;
      case 5: // Calculator - Math symbols
        _drawMathSymbols(canvas, size, paint);
        break;
    }
  }

  void _drawGridPattern(Canvas canvas, Size size, Paint paint) {
    const spacing = 40.0;
    final animatedOffset = progress * spacing;

    for (double i = -spacing; i < size.width + spacing; i += spacing) {
      canvas.drawLine(
        Offset((i + animatedOffset) % (size.width + spacing), 0),
        Offset((i + animatedOffset) % (size.width + spacing), size.height),
        paint,
      );
    }

    for (double i = -spacing; i < size.height + spacing; i += spacing) {
      canvas.drawLine(
        Offset(0, (i + animatedOffset) % (size.height + spacing)),
        Offset(size.width, (i + animatedOffset) % (size.height + spacing)),
        paint,
      );
    }
  }

  void _drawNeuralNetwork(Canvas canvas, Size size, Paint paint) {
    final random = math.Random(42);
    final nodes = <Offset>[];

    // Generate node positions
    for (int i = 0; i < 20; i++) {
      nodes.add(Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      ));
    }

    // Draw connections with animation
    paint.strokeWidth = 1;
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if ((nodes[i] - nodes[j]).distance < 150) {
          final opacity = (1 - (nodes[i] - nodes[j]).distance / 150) *
              (0.3 + 0.3 * math.sin(progress * math.pi * 2 + i));
          paint.color = color.withOpacity(opacity.clamp(0.0, 1.0));
          canvas.drawLine(nodes[i], nodes[j], paint);
        }
      }
    }

    // Draw nodes
    paint.style = PaintingStyle.fill;
    for (var node in nodes) {
      paint.color = color.withOpacity(0.6);
      canvas.drawCircle(node, 4, paint);
    }
  }

  void _drawCircuitBoard(Canvas canvas, Size size, Paint paint) {
    paint.strokeWidth = 2;
    final offset = progress * 100;

    // Draw circuit traces
    for (int i = 0; i < 5; i++) {
      final y = (i * 50 + offset) % size.height;
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x < size.width; x += 50) {
        if (x % 100 == 0) {
          path.lineTo(x, y - 20);
          path.lineTo(x + 50, y - 20);
        } else {
          path.lineTo(x + 50, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Draw connection points
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 6; j++) {
        final x = i * (size.width / 7);
        final y = (j * 50 + offset) % size.height;
        canvas.drawCircle(Offset(x, y), 5, paint);
      }
    }
  }

  void _drawLambdaPattern(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;

    final angle = progress * math.pi * 2;

    for (int i = 0; i < 3; i++) {
      final centerX = size.width * (0.25 + i * 0.25);
      final centerY = size.height * 0.5;
      final radius = 40 + math.sin(angle + i) * 10;

      // Draw lambda symbol (simplified)
      final path = Path();
      path.moveTo(centerX - radius, centerY + radius);
      path.lineTo(centerX, centerY - radius);
      path.lineTo(centerX + radius, centerY + radius);

      canvas.drawPath(path, paint);
    }
  }

  void _drawStackLayers(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    final layers = 8;
    final layerHeight = size.height / layers;
    final offset = progress * layerHeight;

    for (int i = 0; i < layers + 1; i++) {
      final y = (i * layerHeight - offset) % size.height;
      final indent = (i % 2) * 20;

      final path = Path();
      path.moveTo(indent.toDouble(), y);
      path.lineTo(size.width - indent, y);

      canvas.drawPath(path, paint);

      // Draw stack indicators
      if (i < layers) {
        canvas.drawLine(
          Offset(10, y + 5),
          Offset(10, y + layerHeight - 5),
          paint,
        );
      }
    }
  }

  void _drawMathSymbols(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    final symbols = ['+', '-', '×', '÷', '^', '()'];
    final random = math.Random(123);

    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + progress * 50) % size.height;

      final opacity = (1 - y / size.height) * 0.5;
      paint.color = color.withOpacity(opacity);

      // Simple symbol representation with circle
      canvas.drawCircle(Offset(x, y), 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WorldBackgroundPainter oldDelegate) => true;
}