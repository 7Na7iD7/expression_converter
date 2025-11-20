import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class AdvancedQuizScreen extends StatefulWidget {
  const AdvancedQuizScreen({super.key});

  @override
  State<AdvancedQuizScreen> createState() => _AdvancedQuizScreenState();
}

class _AdvancedQuizScreenState extends State<AdvancedQuizScreen> with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _totalQuestions = 0;
  bool _isAnswered = false;
  int? _selectedAnswer;
  bool _quizCompleted = false;
  List<int> _userAnswers = [];
  List<bool> _correctAnswers = [];
  late AnimationController _timerController;
  late AnimationController _celebrationController;
  int _timeRemaining = 30;
  bool _showHint = false;

  final List<QuizQuestion> _questions = [

    QuizQuestion(
      question: 'What does LIFO stand for in Stack data structure?',
      options: [
        'Last In First Out',
        'Last In Forever Out',
        'Latest In First Out',
        'Linear In First Out',
      ],
      correctAnswer: 0,
      explanation: 'LIFO stands for Last In First Out, meaning the last element added to the stack is the first one to be removed, just like a stack of plates.',
      hint: 'Think about a stack of plates - which plate do you take first?',
      difficulty: QuizDifficulty.easy,
    ),

    QuizQuestion(
      question: 'Convert the infix expression "A + B" to postfix notation.',
      options: [
        'A B +',
        '+ A B',
        'A + B',
        'B A +',
      ],
      correctAnswer: 0,
      explanation: 'In postfix notation, operators come after operands. So "A + B" becomes "A B +".',
      hint: 'In postfix, the operator comes AFTER the operands.',
      difficulty: QuizDifficulty.easy,
    ),

    QuizQuestion(
      question: 'Which operator has the HIGHEST precedence?',
      options: [
        'Addition (+)',
        'Multiplication (×)',
        'Exponentiation (^)',
        'Subtraction (-)',
      ],
      correctAnswer: 2,
      explanation: 'Exponentiation (^) has the highest precedence, followed by multiplication/division, then addition/subtraction.',
      hint: 'Remember PEMDAS/BODMAS - which operation comes first?',
      difficulty: QuizDifficulty.easy,
    ),

    QuizQuestion(
      question: 'Convert "(A + B) × C" to postfix notation.',
      options: [
        'A B C + ×',
        'A B + C ×',
        'A B × C +',
        '+ A B × C',
      ],
      correctAnswer: 1,
      explanation: 'Parentheses are evaluated first. So (A+B) becomes "A B +", then multiply by C: "A B + C ×".',
      hint: 'Process what\'s inside parentheses first!',
      difficulty: QuizDifficulty.medium,
    ),

    QuizQuestion(
      question: 'Evaluate the postfix expression: "5 3 + 2 ×"',
      options: [
        '10',
        '16',
        '11',
        '13',
      ],
      correctAnswer: 1,
      explanation: 'Step 1: 5 + 3 = 8\nStep 2: 8 × 2 = 16\nAnswer: 16',
      hint: 'When you see an operator, apply it to the two previous numbers.',
      difficulty: QuizDifficulty.medium,
    ),

    QuizQuestion(
      question: 'What is the associativity of the exponentiation operator (^)?',
      options: [
        'Left to Right',
        'Right to Left',
        'No Associativity',
        'Both directions',
      ],
      correctAnswer: 1,
      explanation: 'Exponentiation (^) is right-associative, meaning 2^3^2 = 2^(3^2) = 2^9 = 512, not (2^3)^2 = 8^2 = 64.',
      hint: 'Is 2^3^2 equal to (2^3)^2 or 2^(3^2)?',
      difficulty: QuizDifficulty.medium,
    ),

    QuizQuestion(
      question: 'Convert "A + B × C - D" to postfix (without parentheses).',
      options: [
        'A B C × + D -',
        'A B + C × D -',
        'A B C + × D -',
        'A B C D × + -',
      ],
      correctAnswer: 0,
      explanation: 'Following operator precedence: × is done first (B C ×), then + and - from left to right: "A B C × + D -".',
      hint: 'Multiplication has higher precedence than addition and subtraction!',
      difficulty: QuizDifficulty.hard,
    ),

    QuizQuestion(
      question: 'In the Infix to Postfix conversion algorithm, when do we pop an operator from the stack?',
      options: [
        'When we encounter a higher precedence operator',
        'When we encounter a lower or equal precedence operator',
        'When we encounter a closing parenthesis',
        'Both B and C',
      ],
      correctAnswer: 3,
      explanation: 'We pop operators when: 1) We encounter an operator with lower or equal precedence, 2) We encounter a closing parenthesis.',
      hint: 'Think about when we need to output operators before continuing.',
      difficulty: QuizDifficulty.hard,
    ),

    QuizQuestion(
      question: 'What is the time complexity of converting an infix expression of length n to postfix?',
      options: [
        'O(n²)',
        'O(n log n)',
        'O(n)',
        'O(1)',
      ],
      correctAnswer: 2,
      explanation: 'The conversion takes O(n) time because we scan through the expression once, and each element is pushed and popped from the stack at most once.',
      hint: 'We process each character in the expression exactly once.',
      difficulty: QuizDifficulty.medium,
    ),

    QuizQuestion(
      question: 'Evaluate: "8 2 / 3 + 5 ×"',
      options: [
        '25',
        '35',
        '30',
        '20',
      ],
      correctAnswer: 1,
      explanation: 'Step 1: 8 / 2 = 4\nStep 2: 4 + 3 = 7\nStep 3: 7 × 5 = 35\nAnswer: 35',
      hint: 'Work through it step by step: divide first, then add, then multiply.',
      difficulty: QuizDifficulty.hard,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _totalQuestions = _questions.length;
    _userAnswers = List.filled(_totalQuestions, -1);
    _correctAnswers = List.filled(_totalQuestions, false);

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _startTimer();
  }

  void _startTimer() {
    _timerController.reset();
    _timeRemaining = 30;
    _timerController.forward();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && !_isAnswered && !_quizCompleted) {
        setState(() {
          _timeRemaining--;
          if (_timeRemaining <= 0) {
            _handleTimeout();
          }
        });
        return _timeRemaining > 0;
      }
      return false;
    });
  }

  void _handleTimeout() {
    setState(() {
      _isAnswered = true;
      _userAnswers[_currentQuestionIndex] = -1;
      _correctAnswers[_currentQuestionIndex] = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _selectAnswer(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      _timerController.stop();

      final isCorrect = index == _questions[_currentQuestionIndex].correctAnswer;
      _userAnswers[_currentQuestionIndex] = index;
      _correctAnswers[_currentQuestionIndex] = isCorrect;

      if (isCorrect) {
        _score++;
        _celebrationController.forward(from: 0);
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
        _showHint = false;
      });
      _startTimer();
    } else {
      setState(() {
        _quizCompleted = true;
        _timerController.stop();
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _isAnswered = false;
      _quizCompleted = false;
      _showHint = false;
      _userAnswers = List.filled(_totalQuestions, -1);
      _correctAnswers = List.filled(_totalQuestions, false);
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.indigo.shade600,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: _quizCompleted
              ? _buildResultsScreen(l10n)
              : _buildQuizScreen(l10n),
        ),
      ),
    );
  }

  Widget _buildQuizScreen(AppLocalizations l10n) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      children: [
        _buildAppBar(l10n),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 20),
              _buildTimerCard(l10n),
              const SizedBox(height: 24),
              _buildQuestionCard(currentQuestion, l10n),
              const SizedBox(height: 24),
              _buildOptionsGrid(currentQuestion),
              if (_isAnswered) ...[
                const SizedBox(height: 24),
                _buildExplanationCard(currentQuestion, l10n),
              ],
              const SizedBox(height: 24),
              if (_isAnswered) _buildNextButton(l10n),
              if (!_isAnswered && !_showHint) _buildHintButton(l10n),
              if (_showHint && !_isAnswered) _buildHintCard(currentQuestion, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advanced Quiz',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Test Your Knowledge',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          _buildScoreChip(),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildScoreChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 22),
          const SizedBox(width: 8),
          Text(
            '$_score/$_totalQuestions',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/$_totalQuestions',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${((_currentQuestionIndex + 1) / _totalQuestions * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _totalQuestions,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 12,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildTimerCard(AppLocalizations l10n) {
    final color = _timeRemaining > 10 ? Colors.green : (_timeRemaining > 5 ? Colors.orange : Colors.red);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Text(
            '$_timeRemaining',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'seconds',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).animate(target: _timeRemaining <= 5 ? 1 : 0)
        .shake(duration: 300.ms, hz: 4);
  }

  Widget _buildQuestionCard(QuizQuestion question, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDifficultyBadge(question.difficulty),
              const Spacer(),
              if (!_isAnswered)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                      color: Colors.amber.shade700,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _showHint = !_showHint;
                      });
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildDifficultyBadge(QuizDifficulty difficulty) {
    Color color;
    String text;
    IconData icon;

    switch (difficulty) {
      case QuizDifficulty.easy:
        color = Colors.green;
        text = 'Easy';
        icon = Icons.sentiment_satisfied;
        break;
      case QuizDifficulty.medium:
        color = Colors.orange;
        text = 'Medium';
        icon = Icons.sentiment_neutral;
        break;
      case QuizDifficulty.hard:
        color = Colors.red;
        text = 'Hard';
        icon = Icons.sentiment_very_dissatisfied;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(QuizQuestion question) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;

        Color cardColor = Colors.white;
        Color borderColor = Colors.grey.shade300;
        IconData? icon;

        if (_isAnswered) {
          if (index == question.correctAnswer) {
            cardColor = Colors.green.shade50;
            borderColor = Colors.green;
            icon = Icons.check_circle;
          } else if (index == _selectedAnswer) {
            cardColor = Colors.red.shade50;
            borderColor = Colors.red;
            icon = Icons.cancel;
          }
        } else if (index == _selectedAnswer) {
          cardColor = Colors.blue.shade50;
          borderColor = Colors.blue;
        }

        return GestureDetector(
          onTap: () => _selectAnswer(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isAnswered && index == question.correctAnswer
                        ? Colors.green
                        : _isAnswered && index == _selectedAnswer
                        ? Colors.red
                        : Colors.deepPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: icon != null
                        ? Icon(icon, color: Colors.white, size: 26)
                        : Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isAnswered && index == question.correctAnswer
                            ? Colors.white
                            : _isAnswered && index == _selectedAnswer
                            ? Colors.white
                            : Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: (index * 80).ms).slideX(begin: 0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildExplanationCard(QuizQuestion question, AppLocalizations l10n) {
    final isCorrect = _selectedAnswer == question.correctAnswer;
    final wasTimeout = _selectedAnswer == null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: wasTimeout
              ? [Colors.orange.shade50, Colors.orange.shade100]
              : isCorrect
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: wasTimeout ? Colors.orange : (isCorrect ? Colors.green : Colors.red),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (wasTimeout ? Colors.orange : (isCorrect ? Colors.green : Colors.red)).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                wasTimeout ? Icons.access_time : (isCorrect ? Icons.check_circle : Icons.cancel),
                color: wasTimeout ? Colors.orange : (isCorrect ? Colors.green : Colors.red),
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                wasTimeout ? 'Time\'s Up!' : (isCorrect ? 'Correct!' : 'Incorrect'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: wasTimeout ? Colors.orange : (isCorrect ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Correct Answer: ${String.fromCharCode(65 + question.correctAnswer)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explanation:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildHintButton(AppLocalizations l10n) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _showHint = true;
          });
        },
        icon: const Icon(Icons.lightbulb_outline, size: 24),
        label: const Text(
          'Show Hint',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildHintCard(QuizQuestion question, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade50, Colors.yellow.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.amber, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hint 💡',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.hint,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildNextButton(AppLocalizations l10n) {
    final isLastQuestion = _currentQuestionIndex >= _totalQuestions - 1;

    return Center(
      child: ElevatedButton.icon(
        onPressed: _nextQuestion,
        icon: Icon(
          isLastQuestion ? Icons.check : Icons.arrow_forward,
          size: 24,
        ),
        label: Text(
          isLastQuestion ? 'Finish Quiz' : 'Next Question',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: Colors.deepPurple.withOpacity(0.5),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildResultsScreen(AppLocalizations l10n) {
    final percentage = (_score / _totalQuestions * 100).round();
    String feedback;
    Color feedbackColor;
    IconData feedbackIcon;

    if (percentage >= 90) {
      feedback = 'Outstanding! You\'re a master!';
      feedbackColor = Colors.green;
      feedbackIcon = Icons.emoji_events;
    } else if (percentage >= 70) {
      feedback = 'Great job! Keep it up!';
      feedbackColor = Colors.blue;
      feedbackIcon = Icons.thumb_up;
    } else if (percentage >= 50) {
      feedback = 'Good effort! Review and try again!';
      feedbackColor = Colors.orange;
      feedbackIcon = Icons.sentiment_neutral;
    } else {
      feedback = 'Keep practicing! You\'ll get better!';
      feedbackColor = Colors.red;
      feedbackIcon = Icons.sentiment_dissatisfied;
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feedbackColor.withOpacity(0.6),
                feedbackColor,
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: feedbackColor.withOpacity(0.5),
                blurRadius: 35,
                offset: const Offset(0, 15),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(feedbackIcon, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreStat('Score', '$_score/$_totalQuestions', Icons.star),
                  const SizedBox(width: 24),
                  _buildScoreStat('Percentage', '$percentage%', Icons.percent),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.85, 0.85)),
        const SizedBox(height: 32),
        _buildDetailedResults(l10n),
        const SizedBox(height: 32),
        _buildActionButtons(l10n),
      ],
    );
  }

  Widget _buildScoreStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResults(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics, color: Colors.deepPurple, size: 32),
              ),
              const SizedBox(width: 16),
              const Text(
                'Detailed Results',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final isCorrect = _correctAnswers[index];
            final userAnswer = _userAnswers[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCorrect ? Colors.green : Colors.red,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          question.question.length > 50
                              ? '${question.question.substring(0, 50)}...'
                              : question.question,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 32,
                      ),
                    ],
                  ),
                  if (!isCorrect && userAnswer != -1) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.close, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Your answer: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  question.options[userAnswer],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.check, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Correct answer: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  question.options[question.correctAnswer],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else if (userAnswer == -1) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Time out - No answer given',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _restartQuiz,
            icon: const Icon(Icons.replay, size: 28),
            label: const Text(
              'Retry Quiz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8,
              shadowColor: Colors.deepPurple.withOpacity(0.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 28),
            label: const Text(
              'Back to Tutorial',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              side: const BorderSide(color: Colors.white, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.3, end: 0);
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String hint;
  final QuizDifficulty difficulty;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.hint,
    required this.difficulty,
  });
}

enum QuizDifficulty {
  easy,
  medium,
  hard,
}