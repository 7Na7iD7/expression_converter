import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../l10n/app_localizations.dart';

class StackVisualizer extends StatelessWidget {
  final List<String> stack;
  final String output;
  final bool isAnimated;

  const StackVisualizer({
    super.key,
    required this.stack,
    required this.output,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStackView(context, l10n),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOutputView(context, l10n),
        ),
      ],
    );
  }

  Widget _buildStackView(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          context,
          l10n.translate('stack'),
          Icons.layers,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.withOpacity(0.05),
                Colors.blue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: stack.isEmpty
                ? _buildEmptyState(context, l10n, l10n.translate('empty_stack'))
                : _buildStackItems(context, l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildStackItems(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Top label
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            border: Border(
              bottom: BorderSide(
                color: Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '↓ ${l10n.translate('top')} ↓',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        // Stack items (reversed to show top at top)
        ...List.generate(
          stack.length,
              (index) {
            final reversedIndex = stack.length - 1 - index;
            final item = stack[reversedIndex];
            final isTop = reversedIndex == stack.length - 1;

            return _buildStackItem(
              context,
              item,
              isTop,
              index,
            );
          },
        ),
        // Bottom label
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            border: Border(
              top: BorderSide(
                color: Colors.blue.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              '↑ ${l10n.translate('bottom')} ↑',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStackItem(
      BuildContext context,
      String item,
      bool isTop,
      int index,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isTop
              ? [
            Colors.blue.shade400,
            Colors.blue.shade600,
          ]
              : [
            Colors.blue.shade100,
            Colors.blue.shade200,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isTop ? Colors.blue.withOpacity(0.4) : Colors.blue.withOpacity(0.2),
            blurRadius: isTop ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isTop)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_upward,
                size: 12,
                color: Colors.blue,
              ),
            ),
          if (isTop) const SizedBox(width: 8),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isTop ? Colors.white : Colors.blue.shade900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate(target: isAnimated ? 1 : 0).slideY(
      begin: -0.5,
      end: 0,
      duration: 300.ms,
      delay: (index * 100).ms,
    ).fadeIn(duration: 300.ms, delay: (index * 100).ms);
  }

  Widget _buildOutputView(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          context,
          l10n.translate('output'),
          Icons.output,
          Colors.green,
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.withOpacity(0.05),
                Colors.green.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: output.isEmpty
              ? _buildEmptyState(context, l10n, l10n.translate('no_output_yet'))
              : _buildOutputContent(context, l10n),
        ),
      ],
    );
  }

  Widget _buildOutputContent(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.translate('current_output'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
            ),
          ),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: output.split('').map((char) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade400,
                      Colors.green.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  char,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ).animate(target: isAnimated ? 1 : 0).shimmer(
          duration: 1500.ms,
          color: Colors.green.withOpacity(0.3),
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.translate('length')}: ${output.length} ${l10n.translate('characters')}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}