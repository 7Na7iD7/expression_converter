import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class CustomTutorialScreen extends StatefulWidget {
  const CustomTutorialScreen({super.key});

  @override
  State<CustomTutorialScreen> createState() => _CustomTutorialScreenState();
}

class _CustomTutorialScreenState extends State<CustomTutorialScreen> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('custom_tutorial_title')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildIntroCard(l10n),
          const SizedBox(height: 20),
          _buildStackBasicsSection(l10n),
          const SizedBox(height: 20),
          _buildInfixToPostfixSection(l10n),
          const SizedBox(height: 20),
          _buildPostfixEvaluationSection(l10n),
          const SizedBox(height: 20),
          _buildCommonMistakesSection(l10n),
          const SizedBox(height: 20),
          _buildPracticeCard(l10n),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIntroCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade300,
            Colors.blue.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('custom_intro_title'),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('custom_intro_desc'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildStackBasicsSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      0,
      l10n.translate('stack_how_works'),
      Icons.layers_outlined,
      Colors.indigo,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox(
            l10n.translate('real_world_analogy'),
            l10n.translate('stack_plate_analogy'),
            Colors.indigo,
            Icons.restaurant,
          ),
          const SizedBox(height: 16),
          _buildAnimatedStackDemo(l10n),
          const SizedBox(height: 16),
          _buildInfoBox(
            l10n.translate('what_is_lifo'),
            l10n.translate('lifo_explanation'),
            Colors.teal,
            Icons.input,
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildAnimatedStackDemo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            l10n.translate('practical_example'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.indigo.shade700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Push
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.green, size: 24),
                        const SizedBox(height: 8),
                        Text('Push(5)', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMiniStack(['5', '3', '1']),
                ],
              ),
              // Pop
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.red, size: 24),
                        const SizedBox(height: 8),
                        Text('Pop() = 5', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMiniStack(['3', '1']),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStack(List<String> items) {
    return Column(
      children: items.map((item) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade700, width: 2),
        ),
        child: Text(
          item,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildInfixToPostfixSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      1,
      l10n.translate('infix_to_postfix_steps'),
      Icons.transform,
      Colors.orange,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox(
            l10n.translate('why_postfix_title'),
            l10n.translate('why_postfix_reasons'),
            Colors.orange,
            Icons.question_answer,
          ),
          const SizedBox(height: 16),
          _buildDetailedConversionExample(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildDetailedConversionExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('conversion_example'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(height: 16),
          _buildConversionStep('1', l10n.translate('step1_read'), l10n.translate('step1_action'), l10n.translate('step1_result'), Colors.blue),
          _buildConversionStep('2', l10n.translate('step2_read'), l10n.translate('step2_action'), l10n.translate('step2_result'), Colors.green),
          _buildConversionStep('3', l10n.translate('step3_read'), l10n.translate('step3_action'), l10n.translate('step3_result'), Colors.blue),
          _buildConversionStep('4', l10n.translate('step4_read'), l10n.translate('step4_action'), l10n.translate('step4_result'), Colors.green),
          _buildConversionStep('5', l10n.translate('step5_read'), l10n.translate('step5_action'), l10n.translate('step5_result'), Colors.orange),
          _buildConversionStep('6', l10n.translate('step6_read'), l10n.translate('step6_action'), l10n.translate('step6_result'), Colors.blue),
          _buildConversionStep('7', l10n.translate('step7_read'), l10n.translate('step7_action'), l10n.translate('step7_result'), Colors.green),
          _buildConversionStep('8', l10n.translate('step8_read'), l10n.translate('step8_action'), l10n.translate('step8_result'), Colors.orange),
          _buildConversionStep('9', l10n.translate('step9_read'), l10n.translate('step9_action'), l10n.translate('step9_result'), Colors.green),
          _buildConversionStep('10', l10n.translate('step10_read'), l10n.translate('step10_action'), l10n.translate('step10_result'), Colors.red),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.translate('final_result'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
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

  Widget _buildConversionStep(String step, String action, String description, String result, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostfixEvaluationSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      2,
      l10n.translate('postfix_evaluation'),
      Icons.calculate,
      Colors.teal,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox(
            l10n.translate('evaluation_algorithm'),
            l10n.translate('evaluation_steps'),
            Colors.teal,
            Icons.rule,
          ),
          const SizedBox(height: 16),
          _buildEvaluationExample(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildEvaluationExample(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.pink.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade300, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('evaluation_example'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade900,
            ),
          ),
          const SizedBox(height: 16),
          _buildEvalStep('1', l10n.translate('eval_step1_action'), l10n.translate('eval_step1_op'), l10n.translate('eval_step1_stack'), Colors.blue),
          _buildEvalStep('2', l10n.translate('eval_step2_action'), l10n.translate('eval_step2_op'), l10n.translate('eval_step2_stack'), Colors.blue),
          _buildEvalStep('3', l10n.translate('eval_step3_action'), l10n.translate('eval_step3_op'), l10n.translate('eval_step3_stack'), Colors.green),
          _buildEvalStep('4', l10n.translate('eval_step4_action'), l10n.translate('eval_step4_op'), l10n.translate('eval_step4_stack'), Colors.blue),
          _buildEvalStep('5', l10n.translate('eval_step5_action'), l10n.translate('eval_step5_op'), l10n.translate('eval_step5_stack'), Colors.green),
          _buildEvalStep('6', l10n.translate('eval_step6_action'), l10n.translate('eval_step6_op'), l10n.translate('eval_step6_stack'), Colors.blue),
          _buildEvalStep('7', l10n.translate('eval_step7_action'), l10n.translate('eval_step7_op'), l10n.translate('eval_step7_stack'), Colors.green),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade700, size: 32),
                const SizedBox(width: 12),
                Text(
                  l10n.translate('eval_final_answer'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvalStep(String step, String action, String operation, String stack, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
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
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    operation,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stack,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonMistakesSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      3,
      l10n.translate('common_mistakes'),
      Icons.warning_amber,
      Colors.red,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMistakeItem(
            l10n.translate('wrong_label'),
            l10n.translate('mistake1_wrong'),
            l10n.translate('correct_label'),
            l10n.translate('mistake1_correct'),
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            l10n.translate('wrong_label'),
            l10n.translate('mistake2_wrong'),
            l10n.translate('correct_label'),
            l10n.translate('mistake2_correct'),
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            l10n.translate('wrong_label'),
            l10n.translate('mistake3_wrong'),
            l10n.translate('correct_label'),
            l10n.translate('mistake3_correct'),
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _buildMistakeItem(
            l10n.translate('wrong_label'),
            l10n.translate('mistake4_wrong'),
            l10n.translate('correct_label'),
            l10n.translate('mistake4_correct'),
            Colors.green,
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildMistakeItem(String wrongLabel, String wrongText, String rightLabel, String rightText, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                wrongLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  wrongText,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: color),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                rightLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rightText,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.fitness_center, size: 50, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            l10n.translate('practice_title'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('practice_desc'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildInfoBox(String title, String content, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.6),
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
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? -1 : index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.2),
                      color.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
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
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: content,
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
  }
}