import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/example_model.dart';
import '../l10n/app_localizations.dart';

class ExamplesScreen extends StatefulWidget {
  final Function(String expression, String conversionType) onExampleSelected;

  const ExamplesScreen({
    super.key,
    required this.onExampleSelected,
  });

  @override
  State<ExamplesScreen> createState() => _ExamplesScreenState();
}

class _ExamplesScreenState extends State<ExamplesScreen> {
  DifficultyLevel? _selectedDifficulty;
  String? _selectedConversionType;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final List<ExampleModel> _allExamples = ExampleModel.getAllExamples();

  List<String> _getConversionTypes(AppLocalizations l10n) {
    return [
      l10n.translate('infix_to_postfix'),
      l10n.translate('infix_to_prefix'),
      l10n.translate('postfix_to_infix'),
      l10n.translate('prefix_to_infix'),
    ];
  }

  List<ExampleModel> get _filteredExamples {
    var filtered = _allExamples;

    if (_selectedDifficulty != null) {
      filtered = filtered.where((e) => e.difficulty == _selectedDifficulty).toList();
    }

    if (_selectedConversionType != null) {
      filtered = filtered.where((e) => e.conversionType == _selectedConversionType).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((e) {
        final query = _searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(query) ||
            e.expression.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query) ||
            (e.tags?.any((tag) => tag.toLowerCase().contains(query)) ?? false);
      }).toList();
    }

    return filtered;
  }

  bool get _hasActiveFilters =>
      _selectedDifficulty != null || _selectedConversionType != null || _searchQuery.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _selectedDifficulty = null;
      _selectedConversionType = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(l10n),
                const SizedBox(height: 20),
                _buildSearchBar(l10n),
                const SizedBox(height: 20),
                _buildDifficultyFilters(l10n),
                const SizedBox(height: 16),
                _buildConversionTypeFilters(l10n),
                const SizedBox(height: 20),
                _buildStatsRow(l10n),
                const SizedBox(height: 16),
                _buildResultsHeader(l10n),
              ],
            ),
          ),
        ),
        _filteredExamples.isEmpty
            ? SliverFillRemaining(child: _buildEmptyState(l10n))
            : SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final example = _filteredExamples[index];
                return _buildExampleCard(example, index, l10n);
              },
              childCount: _filteredExamples.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildHeaderCard(AppLocalizations l10n) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lightbulb,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('practice_examples'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_allExamples.length} ${l10n.translate('examples_count')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale();
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: l10n.translate('search_placeholder'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _buildDifficultyFilters(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.translate('difficulty'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: Text(l10n.translate('clear_filters')),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(l10n.translate('all'), null, Icons.apps, _selectedDifficulty == null, l10n),
              const SizedBox(width: 8),
              _buildFilterChip(l10n.translate('easy'), DifficultyLevel.easy, Icons.check_circle,
                  _selectedDifficulty == DifficultyLevel.easy, l10n),
              const SizedBox(width: 8),
              _buildFilterChip(l10n.translate('medium'), DifficultyLevel.medium, Icons.pending,
                  _selectedDifficulty == DifficultyLevel.medium, l10n),
              const SizedBox(width: 8),
              _buildFilterChip(
                  l10n.translate('hard'), DifficultyLevel.hard, Icons.flag, _selectedDifficulty == DifficultyLevel.hard, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversionTypeFilters(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('conversion_type_label'),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTypeChip(l10n.translate('all_types'), null, _selectedConversionType == null, l10n),
            ..._getConversionTypes(l10n).map(
                  (type) => _buildTypeChip(type, type, _selectedConversionType == type, l10n),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, DifficultyLevel? difficulty, IconData icon, bool isSelected, AppLocalizations l10n) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDifficulty = selected ? difficulty : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  Widget _buildTypeChip(String label, String? type, bool isSelected, AppLocalizations l10n) {
    IconData icon;
    if (type == l10n.translate('infix_to_postfix')) {
      icon = Icons.arrow_forward;
    } else if (type == l10n.translate('infix_to_prefix')) {
      icon = Icons.arrow_upward;
    } else if (type == l10n.translate('postfix_to_infix')) {
      icon = Icons.arrow_back;
    } else if (type == l10n.translate('prefix_to_infix')) {
      icon = Icons.arrow_downward;
    } else {
      icon = Icons.filter_alt;
    }

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedConversionType = selected ? type : null;
        });
      },
      selectedColor: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }

  Widget _buildStatsRow(AppLocalizations l10n) {
    final stats = ExampleModel.getStatistics();
    final easyCount = stats[DifficultyLevel.easy] ?? 0;
    final mediumCount = stats[DifficultyLevel.medium] ?? 0;
    final hardCount = stats[DifficultyLevel.hard] ?? 0;

    return Row(
      children: [
        Expanded(child: _buildStatCard('🟢', l10n.translate('easy'), easyCount, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('🟡', l10n.translate('medium'), mediumCount, Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('🔴', l10n.translate('hard'), hardCount, Colors.red)),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildStatCard(String emoji, String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.list_alt, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '${_filteredExamples.length} ${_filteredExamples.length != 1 ? l10n.translate('results_plural') : l10n.translate('results')}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.translate('no_examples_found'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('adjust_filters'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.translate('clear_all_filters')),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildExampleCard(ExampleModel example, int index, AppLocalizations l10n) {
    Color difficultyColor;
    switch (example.difficulty) {
      case DifficultyLevel.easy:
        difficultyColor = Colors.green;
        break;
      case DifficultyLevel.medium:
        difficultyColor = Colors.orange;
        break;
      case DifficultyLevel.hard:
        difficultyColor = Colors.red;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: difficultyColor.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          widget.onExampleSelected(example.expression, example.conversionType);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${l10n.translate('example_loaded')}: ${example.title}')),
                ],
              ),
              backgroundColor: difficultyColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [difficultyColor, difficultyColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(example.difficulty.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          example.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: difficultyColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            example.difficulty.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: difficultyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_filled, color: difficultyColor, size: 32),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.code, size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('${l10n.translate('expression')}:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        example.expression,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.swap_horiz,
                      size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(example.conversionType,
                      style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                example.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              if (example.hint != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${l10n.translate('hint')}: ',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          example.hint!,
                          style: const TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('${l10n.translate('expected')}:',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example.expectedResult,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              if (example.tags != null && example.tags!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: example.tags!
                      .map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 80).ms).fadeIn(duration: 400.ms).slideX(begin: 0.2, end: 0);
  }
}