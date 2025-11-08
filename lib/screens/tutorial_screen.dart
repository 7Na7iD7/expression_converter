import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(),
        const SizedBox(height: 20),
        _buildStackSection(),
        const SizedBox(height: 20),
        _buildNotationsSection(),
        const SizedBox(height: 20),
        _buildPrecedenceSection(),
        const SizedBox(height: 20),
        _buildExamplesSection(),
        const SizedBox(height: 20),
        _buildTipsCard(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWelcomeCard() {
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
            'Welcome to Expression Converter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn how to convert between Infix, Postfix, and Prefix notations using stack data structure',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildStackSection() {
    return _buildExpandableCard(
      0,
      'What is a Stack?',
      Icons.layers,
      Colors.blue,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A stack is a linear data structure that follows the Last-In-First-Out (LIFO) principle.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 16),
          _buildStackVisualization(),
          const SizedBox(height: 16),
          _buildOperationsList(),
        ],
      ),
    );
  }

  Widget _buildStackVisualization() {
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
            'Stack Visualization',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildStackBox('C', true, 'TOP'),
          const SizedBox(height: 8),
          _buildStackBox('B', false, ''),
          const SizedBox(height: 8),
          _buildStackBox('A', false, 'BOTTOM'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Push/Pop Direction',
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

  Widget _buildOperationsList() {
    final operations = [
      {'icon': Icons.add_circle, 'name': 'Push', 'desc': 'Add element to top', 'color': Colors.green},
      {'icon': Icons.remove_circle, 'name': 'Pop', 'desc': 'Remove top element', 'color': Colors.red},
      {'icon': Icons.visibility, 'name': 'Peek', 'desc': 'View top element', 'color': Colors.blue},
      {'icon': Icons.check_circle, 'name': 'isEmpty', 'desc': 'Check if empty', 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stack Operations:',
          style: TextStyle(
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

  Widget _buildNotationsSection() {
    return _buildExpandableCard(
      1,
      'Expression Notations',
      Icons.text_fields,
      Colors.green,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotationItem(
            'Infix',
            'Operators between operands',
            'A + B',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildNotationItem(
            'Postfix (RPN)',
            'Operators after operands',
            'AB+',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildNotationItem(
            'Prefix (Polish)',
            'Operators before operands',
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
                    const Text(
                      'Why use Postfix/Prefix?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '✓ No parentheses needed\n'
                      '✓ No operator precedence confusion\n'
                      '✓ Easy to evaluate using stack\n'
                      '✓ Used in compilers and calculators',
                  style: TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildPrecedenceSection() {
    return _buildExpandableCard(
      2,
      'Operator Precedence',
      Icons.format_list_numbered,
      Colors.orange,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'From Highest to Lowest Priority:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildPrecedenceItem(1, '^ (Exponentiation)', 'Highest', Colors.red),
          const SizedBox(height: 8),
          _buildPrecedenceItem(2, '* / (Multiply, Divide)', 'Medium', Colors.orange),
          const SizedBox(height: 8),
          _buildPrecedenceItem(3, '+ - (Add, Subtract)', 'Lowest', Colors.green),
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
                const Expanded(
                  child: Text(
                    'Parentheses () have the highest priority and override all operator precedence',
                    style: TextStyle(
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

  Widget _buildExamplesSection() {
    return _buildExpandableCard(
      3,
      'Step-by-Step Examples',
      Icons.lightbulb,
      Colors.purple,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExample(
            'Infix to Postfix',
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
          ),
          const SizedBox(height: 16),
          _buildExample(
            'Postfix to Infix',
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
          ),
        ],
      ),
    );
  }

  Widget _buildExample(
      String title,
      String input,
      String output,
      List<String> steps,
      Color color,
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
          _buildIORow('Input', input, Colors.orange),
          const SizedBox(height: 8),
          _buildIORow('Output', output, Colors.green),
          const SizedBox(height: 12),
          const Text(
            'Process:',
            style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildTipsCard() {
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
              const Text(
                'Pro Tips',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTipItem(Icons.check_circle, 'Use parentheses to control evaluation order'),
          _buildTipItem(Icons.check_circle, 'Start with simple expressions first'),
          _buildTipItem(Icons.check_circle, 'Watch the stack changes carefully'),
          _buildTipItem(Icons.check_circle, 'Spaces are ignored in expressions'),
          _buildTipItem(Icons.check_circle, 'Practice makes perfect!'),
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