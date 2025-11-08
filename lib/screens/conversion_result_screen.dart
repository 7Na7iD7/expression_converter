import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/converter_provider.dart';
import '../widgets/advanced_step_card.dart';
import 'dart:async';

class ConversionResultScreen extends StatefulWidget {
  const ConversionResultScreen({super.key});

  @override
  State<ConversionResultScreen> createState() => _ConversionResultScreenState();
}

class _ConversionResultScreenState extends State<ConversionResultScreen> with TickerProviderStateMixin {
  Timer? _autoPlayTimer;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _resultAnimationController;

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _resultAnimationController.forward();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _scrollController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    final provider = Provider.of<ConverterProvider>(context, listen: false);
    if (provider.steps.isEmpty) return;

    provider.startAnimation();
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (provider.currentStepIndex < provider.steps.length - 1) {
        provider.setCurrentStepIndex(provider.currentStepIndex + 1);
        _scrollToCurrentStep();
      } else {
        timer.cancel();
        provider.stopAnimation();
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    final provider = Provider.of<ConverterProvider>(context, listen: false);
    provider.stopAnimation();
  }

  void _scrollToCurrentStep() {
    if (_scrollController.hasClients) {
      final provider = Provider.of<ConverterProvider>(context, listen: false);
      final position = provider.currentStepIndex * 200.0;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion Steps'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final provider = Provider.of<ConverterProvider>(context, listen: false);
              provider.setCurrentStepIndex(0);
            },
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset to Start',
          ),
        ],
      ),
      body: Consumer<ConverterProvider>(
        builder: (context, provider, child) {
          if (provider.steps.isEmpty) {
            return _buildEmptyState();
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildResultCard(provider),
                    _buildControlBar(provider),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final isActive = index == provider.currentStepIndex;
                      final isPast = index < provider.currentStepIndex;

                      return AdvancedStepCard(
                        step: provider.steps[index],
                        stepNumber: index + 1,
                        isActive: isActive,
                        isPast: isPast,
                      )
                          .animate(delay: (index * 50).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                    childCount: provider.steps.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultCard(ConverterProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Result',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              provider.result,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                '${provider.steps.length} steps completed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    )
        .animate(controller: _resultAnimationController)
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0)
        .then()
        .shimmer(duration: 1000.ms);
  }

  Widget _buildControlBar(ConverterProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: provider.isAnimating ? _stopAutoPlay : _startAutoPlay,
            icon: Icon(provider.isAnimating ? Icons.pause : Icons.play_arrow),
            tooltip: provider.isAnimating ? 'Pause' : 'Auto Play',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Slider(
              value: provider.currentStepIndex.toDouble(),
              min: 0,
              max: (provider.steps.length - 1).toDouble(),
              divisions: provider.steps.length - 1,
              label: 'Step ${provider.currentStepIndex + 1}',
              onChanged: (value) {
                provider.setCurrentStepIndex(value.toInt());
                _scrollToCurrentStep();
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${provider.currentStepIndex + 1}/${provider.steps.length}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversion data available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}