import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/converter_provider.dart';
import 'conversion_result_screen.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'Infix to Postfix';
  late AnimationController _resultAnimationController;

  final List<Map<String, dynamic>> _conversionTypes = [
    {'value': 'Infix to Postfix', 'icon': Icons.arrow_forward, 'color': Colors.blue},
    {'value': 'Infix to Prefix', 'icon': Icons.arrow_upward, 'color': Colors.green},
    {'value': 'Postfix to Infix', 'icon': Icons.arrow_back, 'color': Colors.orange},
    {'value': 'Prefix to Infix', 'icon': Icons.arrow_downward, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _convert() {
    final provider = Provider.of<ConverterProvider>(context, listen: false);
    final expression = _controller.text.trim();

    if (expression.isEmpty) {
      _showSnackBar('Please enter an expression', Colors.red);
      return;
    }

    provider.clearResults();
    _resultAnimationController.reset();

    try {
      switch (_selectedConversion) {
        case 'Infix to Postfix':
          provider.infixToPostfix(expression);
          break;
        case 'Infix to Prefix':
          provider.infixToPrefix(expression);
          break;
        case 'Postfix to Infix':
          provider.postfixToInfix(expression);
          break;
        case 'Prefix to Infix':
          provider.prefixToInfix(expression);
          break;
      }
      _resultAnimationController.forward();
      _showSnackBar('Conversion completed successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Error: Invalid expression', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToResultScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ConversionResultScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputSection(),
            const SizedBox(height: 20),
            Consumer<ConverterProvider>(
              builder: (context, provider, child) {
                if (provider.steps.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildResultPreview(provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConversionTypeSelector(),
            const SizedBox(height: 16),
            _buildInputField(),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildConversionTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedConversion,
        decoration: InputDecoration(
          labelText: 'Conversion Type',
          prefixIcon: Icon(
            _conversionTypes.firstWhere((e) => e['value'] == _selectedConversion)['icon'],
            color: _conversionTypes.firstWhere((e) => e['value'] == _selectedConversion)['color'],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: _conversionTypes.map((type) {
          return DropdownMenuItem<String>(
            value: type['value'],
            child: Row(
              children: [
                Icon(type['icon'], color: type['color'], size: 20),
                const SizedBox(width: 12),
                Text(
                  type['value'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedConversion = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: 'Enter Expression',
        hintText: _getHintText(),
        prefixIcon: const Icon(Icons.edit_note),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _controller.clear();
            });
          },
        )
            : null,
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  String _getHintText() {
    switch (_selectedConversion) {
      case 'Infix to Postfix':
      case 'Infix to Prefix':
        return 'e.g., A+B*C or (A+B)*(C-D)';
      case 'Postfix to Infix':
        return 'e.g., ABC*+ or AB+CD-*';
      case 'Prefix to Infix':
        return 'e.g., +A*BC or *+AB-CD';
      default:
        return 'Enter your expression';
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _controller.text.isNotEmpty ? _convert : null,
            icon: const Icon(Icons.play_arrow, size: 24),
            label: const Text(
              'Convert',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(18),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _controller.clear();
            });
            Provider.of<ConverterProvider>(context, listen: false).clearResults();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calculate_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms)
              .then()
              .shake(duration: 500.ms),
          const SizedBox(height: 24),
          Text(
            'Ready to Convert!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter an expression above and click Convert\nto see step-by-step conversion',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(),
    );
  }

  Widget _buildResultPreview(ConverterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _navigateToResultScreen,
                icon: const Icon(Icons.visibility),
                label: const Text('View Detailed Steps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        )
            .animate(controller: _resultAnimationController)
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.2, end: 0)
            .then()
            .shimmer(duration: 1000.ms),
      ],
    );
  }
}