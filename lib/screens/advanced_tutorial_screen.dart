import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class AdvancedTutorialScreen extends StatefulWidget {
  const AdvancedTutorialScreen({super.key});

  @override
  State<AdvancedTutorialScreen> createState() => _AdvancedTutorialScreenState();
}

class _AdvancedTutorialScreenState extends State<AdvancedTutorialScreen> with TickerProviderStateMixin {
  int _expandedIndex = -1;
  late TabController _tabController;
  int _currentAlgorithmStep = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('advanced_tutorial_title')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate('bookmark_saved')),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAdvancedIntroCard(l10n),
          const SizedBox(height: 20),
          _buildOperatorPrecedenceSection(l10n),
          const SizedBox(height: 20),
          _buildAssociativitySection(l10n),
          const SizedBox(height: 20),
          _buildParenthesesHandlingSection(l10n),
          const SizedBox(height: 20),
          _buildComplexExamplesSection(l10n),
          const SizedBox(height: 20),
          _buildAlgorithmVisualizerSection(l10n),
          const SizedBox(height: 20),
          _buildOptimizationTechniquesSection(l10n),
          const SizedBox(height: 20),
          _buildEdgeCasesSection(l10n),
          const SizedBox(height: 20),
          _buildTimeComplexitySection(l10n),
          const SizedBox(height: 20),
          _buildComparativeAnalysisSection(l10n),
          const SizedBox(height: 20),
          _buildInteractiveQuizCard(l10n),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAdvancedIntroCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade400,
            Colors.indigo.shade600,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            blurRadius: 30,
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
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rocket_launch,
              size: 70,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('advanced_intro_title'),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('advanced_intro_desc'),
            style: TextStyle(
              fontSize: 17,
              color: Colors.white.withOpacity(0.95),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatBadge(Icons.trending_up, l10n.translate('advanced_level'), Colors.amber),
              _buildStatBadge(Icons.timer, l10n.translate('estimated_time'), Colors.green),
              _buildStatBadge(Icons.emoji_events, l10n.translate('expert_mode'), Colors.orange),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.85, 0.85));
  }

  Widget _buildStatBadge(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOperatorPrecedenceSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      0,
      l10n.translate('operator_precedence'),
      Icons.format_list_numbered,
      Colors.deepOrange,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('precedence_definition'),
            l10n.translate('precedence_explanation'),
            Colors.deepOrange,
            Icons.priority_high,
          ),
          const SizedBox(height: 20),
          _buildPrecedenceTable(l10n),
          const SizedBox(height: 20),
          _buildPrecedenceExample(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildPrecedenceTable(AppLocalizations l10n) {
    final operators = [
      {'level': '1', 'ops': '^', 'name': l10n.translate('exponentiation'), 'color': Colors.red},
      {'level': '2', 'ops': '× ÷', 'name': l10n.translate('multiplication_division'), 'color': Colors.orange},
      {'level': '3', 'ops': '+ -', 'name': l10n.translate('addition_subtraction'), 'color': Colors.blue},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.table_chart, color: Colors.deepOrange),
                const SizedBox(width: 12),
                Text(
                  l10n.translate('precedence_table'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          ...operators.map((op) => _buildPrecedenceRow(
            op['level'] as String,
            op['ops'] as String,
            op['name'] as String,
            op['color'] as Color,
          )),
        ],
      ),
    );
  }

  Widget _buildPrecedenceRow(String level, String ops, String name, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                level,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Text(
              ops,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecedenceExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.red.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.translate('precedence_example'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExpressionBreakdown(
            '3 + 4 × 2',
            [
              l10n.translate('precedence_step1'),
              l10n.translate('precedence_step2'),
              l10n.translate('precedence_step3'),
            ],
            '11',
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionBreakdown(String expression, List<String> steps, String result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            expression,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: Colors.indigo,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text(
                'Result: $result',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssociativitySection(AppLocalizations l10n) {
    return _buildExpandableCard(
      1,
      l10n.translate('associativity'),
      Icons.swap_horiz,
      Colors.purple,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('associativity_definition'),
            l10n.translate('associativity_explanation'),
            Colors.purple,
            Icons.compare_arrows,
          ),
          const SizedBox(height: 20),
          _buildAssociativityComparison(l10n),
          const SizedBox(height: 20),
          _buildAssociativityExamples(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildAssociativityComparison(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildAssociativityCard(
            l10n.translate('left_to_right'),
            '+ - × ÷',
            l10n.translate('left_assoc_example'),
            Colors.blue,
            Icons.arrow_forward,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAssociativityCard(
            l10n.translate('right_to_left'),
            '^',
            l10n.translate('right_assoc_example'),
            Colors.pink,
            Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  Widget _buildAssociativityCard(String title, String operators, String example, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              operators,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            example,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAssociativityExamples(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('detailed_examples'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 16),
          _buildAssociativityExample(
            '10 - 5 - 2',
            l10n.translate('left_assoc_desc'),
            '(10 - 5) - 2 = 5 - 2 = 3',
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildAssociativityExample(
            '2 ^ 3 ^ 2',
            l10n.translate('right_assoc_desc'),
            '2 ^ (3 ^ 2) = 2 ^ 9 = 512',
            Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildAssociativityExample(String expression, String description, String calculation, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expression,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              calculation,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParenthesesHandlingSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      2,
      l10n.translate('parentheses_handling'),
      Icons.code,
      Colors.teal,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('parentheses_rules'),
            l10n.translate('parentheses_explanation'),
            Colors.teal,
            Icons.data_array,
          ),
          const SizedBox(height: 20),
          _buildParenthesesAlgorithm(l10n),
          const SizedBox(height: 20),
          _buildNestedParenthesesExample(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildParenthesesAlgorithm(AppLocalizations l10n) {
    final rules = [
      {'icon': Icons.login, 'text': l10n.translate('paren_rule1'), 'color': Colors.green},
      {'icon': Icons.logout, 'text': l10n.translate('paren_rule2'), 'color': Colors.orange},
      {'icon': Icons.block, 'text': l10n.translate('paren_rule3'), 'color': Colors.red},
    ];

    return Column(
      children: rules.map((rule) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (rule['color'] as Color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: (rule['color'] as Color).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: rule['color'] as Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                rule['icon'] as IconData,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                rule['text'] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildNestedParenthesesExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.cyan.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree, color: Colors.teal, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.translate('nested_example'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNestedStepByStep(l10n),
        ],
      ),
    );
  }

  Widget _buildNestedStepByStep(AppLocalizations l10n) {
    final steps = [
      {'expr': '((A+B)*C)', 'desc': l10n.translate('nested_step1')},
      {'expr': '(A+B)*C', 'desc': l10n.translate('nested_step2')},
      {'expr': 'AB+C*', 'desc': l10n.translate('nested_step3')},
    ];

    return Column(
      children: steps.map((step) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step['expr'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step['desc'] as String,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildComplexExamplesSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      3,
      l10n.translate('complex_examples'),
      Icons.psychology,
      Colors.indigo,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComplexExample(
            'A+(B*C-(D/E^F)*G)*H',
            l10n.translate('complex_example1_desc'),
            l10n,
          ),
          const SizedBox(height: 20),
          _buildComplexExample(
            '((A+B)*C)^(D-E)',
            l10n.translate('complex_example2_desc'),
            l10n,
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildComplexExample(String infix, String description, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('infix_expression'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              infix,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: Colors.indigo,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmVisualizerSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      4,
      l10n.translate('algorithm_visualizer'),
      Icons.animation,
      Colors.pink,
      Column(
        children: [
          _buildAnimatedAlgorithmDemo(l10n),
          const SizedBox(height: 20),
          _buildControlButtons(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildAnimatedAlgorithmDemo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            l10n.translate('visualizing_step', args: [(_currentAlgorithmStep + 1).toString()]),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 20),
          _buildVisualStack(),
          const SizedBox(height: 20),
          _buildCurrentOperation(l10n),
        ],
      ),
    );
  }

  Widget _buildVisualStack() {
    final stackItems = ['C', 'B', 'A'];

    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 120,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ...stackItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Positioned(
              bottom: (index * 50.0) + 10,
              child: Container(
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade500],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).animate(target: _isAnimating ? 1 : 0)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.2, end: 0),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCurrentOperation(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.touch_app, color: Colors.pink),
          const SizedBox(width: 12),
          Text(
            l10n.translate('current_operation'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              if (_currentAlgorithmStep > 0) {
                _currentAlgorithmStep--;
              }
            });
          },
          icon: const Icon(Icons.skip_previous),
          label: Text(l10n.translate('previous')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isAnimating = true;
            });
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                _isAnimating = false;
              });
            });
          },
          icon: const Icon(Icons.play_arrow),
          label: Text(l10n.translate('animate')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              if (_currentAlgorithmStep < 10) {
                _currentAlgorithmStep++;
              }
            });
          },
          icon: const Icon(Icons.skip_next),
          label: Text(l10n.translate('next')),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptimizationTechniquesSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      5,
      l10n.translate('optimization_techniques'),
      Icons.speed,
      Colors.cyan,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('optimization_intro'),
            l10n.translate('optimization_desc'),
            Colors.cyan,
            Icons.tune,
          ),
          const SizedBox(height: 20),
          _buildOptimizationTechnique(
            l10n.translate('technique1_title'),
            l10n.translate('technique1_desc'),
            Icons.memory,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildOptimizationTechnique(
            l10n.translate('technique2_title'),
            l10n.translate('technique2_desc'),
            Icons.compress,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildOptimizationTechnique(
            l10n.translate('technique3_title'),
            l10n.translate('technique3_desc'),
            Icons.flash_on,
            Colors.amber,
          ),
          const SizedBox(height: 20),
          _buildCodeComparison(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildOptimizationTechnique(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeComparison(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: Colors.cyan, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.translate('code_comparison'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCodeBlock(
                  l10n.translate('before'),
                  'O(n²)',
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward, color: Colors.green, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCodeBlock(
                  l10n.translate('after'),
                  'O(n)',
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String label, String complexity, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            complexity,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEdgeCasesSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      6,
      l10n.translate('edge_cases'),
      Icons.error_outline,
      Colors.amber,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('edge_cases_intro'),
            l10n.translate('edge_cases_desc'),
            Colors.amber,
            Icons.bug_report,
          ),
          const SizedBox(height: 20),
          _buildEdgeCase(
            l10n.translate('edge_case1_title'),
            l10n.translate('edge_case1_example'),
            l10n.translate('edge_case1_solution'),
            Colors.red,
            Icons.close,
          ),
          const SizedBox(height: 12),
          _buildEdgeCase(
            l10n.translate('edge_case2_title'),
            l10n.translate('edge_case2_example'),
            l10n.translate('edge_case2_solution'),
            Colors.orange,
            Icons.balance,
          ),
          const SizedBox(height: 12),
          _buildEdgeCase(
            l10n.translate('edge_case3_title'),
            l10n.translate('edge_case3_example'),
            l10n.translate('edge_case3_solution'),
            Colors.purple,
            Icons.low_priority,
          ),
          const SizedBox(height: 12),
          _buildEdgeCase(
            l10n.translate('edge_case4_title'),
            l10n.translate('edge_case4_example'),
            l10n.translate('edge_case4_solution'),
            Colors.blue,
            Icons.notes,
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildEdgeCase(String title, String example, String solution, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              example,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    solution,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeComplexitySection(AppLocalizations l10n) {
    return _buildExpandableCard(
      7,
      l10n.translate('time_complexity'),
      Icons.access_time,
      Colors.deepPurple,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdvancedInfoBox(
            l10n.translate('complexity_analysis'),
            l10n.translate('complexity_desc'),
            Colors.deepPurple,
            Icons.analytics,
          ),
          const SizedBox(height: 20),
          _buildComplexityTable(l10n),
          const SizedBox(height: 20),
          _buildSpaceComplexityInfo(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildComplexityTable(AppLocalizations l10n) {
    final operations = [
      {
        'operation': l10n.translate('infix_to_postfix'),
        'time': 'O(n)',
        'space': 'O(n)',
        'color': Colors.green
      },
      {
        'operation': l10n.translate('postfix_evaluation'),
        'time': 'O(n)',
        'space': 'O(n)',
        'color': Colors.green
      },
      {
        'operation': l10n.translate('stack_operations'),
        'time': 'O(1)',
        'space': 'O(1)',
        'color': Colors.blue
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade100, Colors.purple.shade100],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.translate('operation'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.translate('time'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.translate('space'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ...operations.map((op) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    op['operation'] as String,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (op['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      op['time'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: op['color'] as Color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (op['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      op['space'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: op['color'] as Color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSpaceComplexityInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.translate('space_complexity_note'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('space_complexity_explanation'),
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparativeAnalysisSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      8,
      l10n.translate('comparative_analysis'),
      Icons.compare,
      Colors.green,
      Column(
        children: [
          _buildNotationComparison(l10n),
          const SizedBox(height: 20),
          _buildAdvantagesDisadvantages(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildNotationComparison(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.teal.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            l10n.translate('notation_comparison'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          _buildNotationRow(
            l10n.translate('infix'),
            'A + B',
            l10n.translate('infix_desc'),
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildNotationRow(
            l10n.translate('postfix'),
            'A B +',
            l10n.translate('postfix_desc'),
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildNotationRow(
            l10n.translate('prefix'),
            '+ A B',
            l10n.translate('prefix_desc'),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildNotationRow(String name, String example, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  example,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantagesDisadvantages(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildProConCard(
            l10n.translate('advantages'),
            [
              l10n.translate('advantage1'),
              l10n.translate('advantage2'),
              l10n.translate('advantage3'),
            ],
            Colors.green,
            Icons.check_circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildProConCard(
            l10n.translate('disadvantages'),
            [
              l10n.translate('disadvantage1'),
              l10n.translate('disadvantage2'),
            ],
            Colors.red,
            Icons.cancel,
          ),
        ),
      ],
    );
  }

  Widget _buildProConCard(String title, List<String> points, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInteractiveQuizCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('quiz_title'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('quiz_desc'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.95),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to quiz
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate('quiz_coming_soon')),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.play_arrow, size: 28),
            label: Text(
              l10n.translate('start_quiz'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms, delay: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildAdvancedInfoBox(String title, String content, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(
      int index,
      String title,
      IconData icon,
      Color color,
      Widget content,
      AppLocalizations l10n,
      ) {
    final isExpanded = _expandedIndex == index;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? -1 : index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.25),
                      color.withOpacity(0.15),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: color,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: isExpanded
                  ? Padding(
                padding: const EdgeInsets.all(24),
                child: content,
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 450.ms, delay: (index * 120).ms).slideX(begin: 0.2, end: 0);
  }
}