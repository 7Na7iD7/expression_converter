import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/conversion_step.dart';
import '../l10n/app_localizations.dart';
import '../widgets/stack_visualizer.dart';

class AdvancedStepCard extends StatelessWidget {
  final ConversionStep step;
  final int stepNumber;
  final bool isActive;
  final bool isPast;

  const AdvancedStepCard({
    super.key,
    required this.step,
    required this.stepNumber,
    this.isActive = false,
    this.isPast = false,
  });

  Color _getActionColor(BuildContext context, StepAction action) {
    switch (action) {
      case StepAction.start:
        return Colors.blue;
      case StepAction.pushOperand:
        return Colors.green;
      case StepAction.pushOperator:
        return Colors.orange;
      case StepAction.popOperator:
        return Colors.red;
      case StepAction.pushParenthesis:
        return Colors.purple;
      case StepAction.popParenthesis:
        return Colors.pink;
      case StepAction.combine:
        return Colors.teal;
      case StepAction.complete:
        return Colors.indigo;
    }
  }

  String _getActionDisplayName(AppLocalizations l10n, StepAction action) {
    switch (action) {
      case StepAction.start:
        return l10n.translate('action_start');
      case StepAction.pushOperand:
        return l10n.translate('action_push_operand');
      case StepAction.pushOperator:
        return l10n.translate('action_push_operator');
      case StepAction.popOperator:
        return l10n.translate('action_pop_operator');
      case StepAction.pushParenthesis:
        return l10n.translate('action_push_parenthesis');
      case StepAction.popParenthesis:
        return l10n.translate('action_pop_parenthesis');
      case StepAction.combine:
        return l10n.translate('action_combine');
      case StepAction.complete:
        return l10n.translate('action_complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actionColor = _getActionColor(context, step.action);
    final borderColor = isActive
        ? Theme.of(context).colorScheme.primary
        : isPast
        ? Theme.of(context).colorScheme.outlineVariant
        : Theme.of(context).colorScheme.outline.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: isActive ? 3 : 1,
        ),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: isActive
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: () {
              _showStepDetails(context, l10n);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, l10n, actionColor),
                  const SizedBox(height: 16),
                  _buildDescription(context),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  StackVisualizer(
                    stack: step.stack,
                    output: step.output,
                    isAnimated: isActive,
                  ),
                  if (step.poppedValue != null || step.pushedValue != null) ...[
                    const SizedBox(height: 16),
                    _buildActionInfo(context, l10n),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(target: isActive ? 1 : 0).scale(
      duration: 300.ms,
      begin: const Offset(0.95, 0.95),
      end: const Offset(1.0, 1.0),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, Color actionColor) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                actionColor,
                actionColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: actionColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$stepNumber',
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
              Row(
                children: [
                  Text(
                    step.action.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getActionDisplayName(l10n, step.action),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: actionColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${l10n.translate('current_token')}: ${step.currentToken}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1500.ms),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Text(
        step.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildActionInfo(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (step.poppedValue != null) ...[
            Expanded(
              child: _buildInfoChip(
                context,
                l10n,
                'popped',
                step.poppedValue!,
                Icons.arrow_upward,
                Colors.red,
              ),
            ),
          ],
          if (step.poppedValue != null && step.pushedValue != null)
            const SizedBox(width: 12),
          if (step.pushedValue != null) ...[
            Expanded(
              child: _buildInfoChip(
                context,
                l10n,
                'pushed',
                step.pushedValue!,
                Icons.arrow_downward,
                Colors.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context,
      AppLocalizations l10n,
      String labelKey,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate(labelKey),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStepDetails(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            step.action.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.translate('step')} $stepNumber',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getActionDisplayName(l10n, step.action),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(context, l10n, 'current_token', step.currentToken),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      l10n,
                      'stack_state',
                      step.stack.isEmpty ? l10n.translate('empty') : step.stack.join(', '),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      l10n,
                      'output',
                      step.output.isEmpty ? l10n.translate('empty') : step.output,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.translate('description'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    StackVisualizer(
                      stack: step.stack,
                      output: step.output,
                      isAnimated: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, AppLocalizations l10n, String labelKey, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              l10n.translate(labelKey),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}