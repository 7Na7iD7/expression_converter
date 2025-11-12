import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(l10n),
        const SizedBox(height: 20),
        _buildStackSection(l10n),
        const SizedBox(height: 20),
        _buildNotationsSection(l10n),
        const SizedBox(height: 20),
        _buildPrecedenceSection(l10n),
        const SizedBox(height: 20),
        _buildExamplesSection(l10n),
        const SizedBox(height: 20),
        _buildTipsCard(l10n),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWelcomeCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.school,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('welcome_title'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.translate('welcome_description'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStackSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      0,
      l10n.translate('what_is_stack'),
      Icons.layers,
      Colors.blue,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('stack_description'),
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 16),
          _buildStackVisualization(l10n),
          const SizedBox(height: 16),
          _buildOperationsList(l10n),
        ],
      ),
      l10n,
    );
  }

  Widget _buildStackVisualization(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            l10n.translate('stack_visualization'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildStackBox('C', true, l10n.translate('top')),
          const SizedBox(height: 8),
          _buildStackBox('B', false, ''),
          const SizedBox(height: 8),
          _buildStackBox('A', false, l10n.translate('bottom')),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.translate('push_pop_direction'),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStackBox(String value, bool isTop, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isTop
              ? [Colors.blue.shade400, Colors.blue.shade600]
              : [Colors.blue.shade100, Colors.blue.shade200],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (label.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isTop ? Colors.white : Colors.blue.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildOperationsList(AppLocalizations l10n) {
    final operations = [
      {'icon': Icons.add_circle, 'name': l10n.translate('push'), 'desc': l10n.translate('push_desc'), 'color': Colors.green},
      {'icon': Icons.remove_circle, 'name': l10n.translate('pop'), 'desc': l10n.translate('pop_desc'), 'color': Colors.red},
      {'icon': Icons.visibility, 'name': l10n.translate('peek'), 'desc': l10n.translate('peek_desc'), 'color': Colors.blue},
      {'icon': Icons.check_circle, 'name': l10n.translate('is_empty'), 'desc': l10n.translate('is_empty_desc'), 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('stack_operations'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...operations.map((op) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildOperationItem(
            op['icon'] as IconData,
            op['name'] as String,
            op['desc'] as String,
            op['color'] as Color,
          ),
        )),
      ],
    );
  }

  Widget _buildOperationItem(IconData icon, String name, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotationsSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      1,
      l10n.translate('expression_notations'),
      Icons.text_fields,
      Colors.green,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotationItem(
            l10n.translate('infix'),
            l10n.translate('infix_desc'),
            'A + B',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildNotationItem(
            l10n.translate('postfix'),
            l10n.translate('postfix_desc'),
            'AB+',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildNotationItem(
            l10n.translate('prefix'),
            l10n.translate('prefix_desc'),
            '+AB',
            Colors.purple,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      l10n.translate('why_postfix_prefix'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${l10n.translate('no_parentheses')}\n'
                      '${l10n.translate('no_precedence')}\n'
                      '${l10n.translate('easy_stack')}\n'
                      '${l10n.translate('used_in')}',
                  style: const TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildNotationItem(String name, String desc, String example, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                example,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecedenceSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      2,
      l10n.translate('operator_precedence'),
      Icons.format_list_numbered,
      Colors.orange,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('precedence_description'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildPrecedenceItem(1, l10n.translate('exponentiation'), l10n.translate('highest'), Colors.red),
          const SizedBox(height: 8),
          _buildPrecedenceItem(2, l10n.translate('multiply_divide'), 'Medium', Colors.orange),
          const SizedBox(height: 8),
          _buildPrecedenceItem(3, l10n.translate('add_subtract'), l10n.translate('lowest'), Colors.green),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.priority_high, color: Colors.purple.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.translate('parentheses_note'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildPrecedenceItem(int level, String operators, String priority, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$level',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operators,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  priority,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesSection(AppLocalizations l10n) {
    return _buildExpandableCard(
      3,
      l10n.translate('step_by_step_examples'),
      Icons.lightbulb,
      Colors.purple,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExample(
            l10n.translate('infix_to_postfix'),
            'A + B * C',
            'ABC*+',
            [
              '1. Read A → Output: A',
              '2. Read + → Push to stack',
              '3. Read B → Output: AB',
              '4. Read * → Push (* > +)',
              '5. Read C → Output: ABC',
              '6. Pop * → Output: ABC*',
              '7. Pop + → Output: ABC*+',
            ],
            Colors.blue,
            l10n,
          ),
          const SizedBox(height: 16),
          _buildExample(
            l10n.translate('postfix_to_infix'),
            'AB+C*',
            '(A+B)*C',
            [
              '1. Read A → Push A',
              '2. Read B → Push B',
              '3. Read + → Pop B, A → Push (A+B)',
              '4. Read C → Push C',
              '5. Read * → Pop C, (A+B) → Result: (A+B)*C',
            ],
            Colors.green,
            l10n,
          ),
        ],
      ),
      l10n,
    );
  }

  Widget _buildExample(
      String title,
      String input,
      String output,
      List<String> steps,
      Color color,
      AppLocalizations l10n,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildIORow(l10n.translate('input'), input, Colors.orange),
          const SizedBox(height: 8),
          _buildIORow(l10n.translate('output'), output, Colors.green),
          const SizedBox(height: 12),
          Text(
            l10n.translate('process'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...steps.map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      height: 1.5,
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

  Widget _buildIORow(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade100,
            Colors.orange.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tips_and_updates,
                  color: Colors.orange.shade700,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                l10n.translate('pro_tips'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTipItem(Icons.check_circle, l10n.translate('tip_parentheses')),
          _buildTipItem(Icons.check_circle, l10n.translate('tip_simple')),
          _buildTipItem(Icons.check_circle, l10n.translate('tip_watch')),
          _buildTipItem(Icons.check_circle, l10n.translate('tip_spaces')),
          _buildTipItem(Icons.check_circle, l10n.translate('tip_practice')),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
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