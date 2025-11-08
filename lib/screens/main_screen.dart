import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import 'home_screen.dart';
import 'examples_screen.dart';
import 'tutorial_screen.dart';
import 'settings_screen.dart';

/// MainScreen - Primary Navigation Hub
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  // Key for HomeScreen to call its methods
  final GlobalKey<HomeScreenState> _homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handle example selection from ExamplesScreen
  void _handleExampleSelection(String expression, String conversionType) {
    // Navigate to HomeScreen (index 0)
    setState(() {
      _selectedIndex = 0;
    });

    // Pass data to HomeScreen
    Future.delayed(const Duration(milliseconds: 100), () {
      _homeScreenKey.currentState?.loadExample(expression, conversionType);
    });
  }

  /// Build screens list
  Widget _getScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen(key: _homeScreenKey);
      case 1:
        return ExamplesScreen(
          onExampleSelected: _handleExampleSelection,
        );
      case 2:
        return const TutorialScreen();
      case 3:
        return const SettingsScreen();
      default:
        return HomeScreen(key: _homeScreenKey);
    }
  }

  final List<String> _screenTitles = const [
    'Expression Converter',
    'Practice Examples',
    'Tutorial & Guide',
    'Settings',
  ];

  final List<IconData> _screenIcons = const [
    Icons.calculate,
    Icons.lightbulb,
    Icons.school,
    Icons.settings,
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _animationController.reset();
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _screenIcons[_selectedIndex],
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _screenTitles[_selectedIndex],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(themeProvider.isDarkMode),
              ),
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey(_selectedIndex),
          child: _getScreen(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        animationDuration: const Duration(milliseconds: 400),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 75,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: _buildSelectedIcon(Icons.calculate, Colors.blue),
            label: 'Converter',
          ),
          NavigationDestination(
            icon: const Icon(Icons.lightbulb_outlined),
            selectedIcon: _buildSelectedIcon(Icons.lightbulb, Colors.amber),
            label: 'Examples',
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: _buildSelectedIcon(Icons.school, Colors.green),
            label: 'Tutorial',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: _buildSelectedIcon(Icons.settings, Colors.purple),
            label: 'Settings',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSelectedIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color),
    );
  }
}