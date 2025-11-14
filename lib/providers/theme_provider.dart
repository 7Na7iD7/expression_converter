import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  AppTheme _selectedTheme = AppTheme.system;
  Color _primaryColor = Colors.blue;
  bool _useMaterialYou = true;
  static const String _themeKey = 'app_theme';
  static const String _primaryColorKey = 'primary_color';
  static const String _materialYouKey = 'material_you';

  AppTheme get selectedTheme => _selectedTheme;
  Color get primaryColor => _primaryColor;
  bool get useMaterialYou => _useMaterialYou;

  ThemeMode get themeMode {
    switch (_selectedTheme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode => _selectedTheme == AppTheme.dark;
  bool get isLightMode => _selectedTheme == AppTheme.light;
  bool get isSystemMode => _selectedTheme == AppTheme.system;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final themeIndex = prefs.getInt(_themeKey) ?? AppTheme.system.index;
      _selectedTheme = AppTheme.values[themeIndex];

      final colorValue = prefs.getInt(_primaryColorKey);
      if (colorValue != null) {
        _primaryColor = Color(colorValue);
      }

      _useMaterialYou = prefs.getBool(_materialYouKey) ?? true;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _selectedTheme.index);
      await prefs.setInt(_primaryColorKey, _primaryColor.value);
      await prefs.setBool(_materialYouKey, _useMaterialYou);
    } catch (e) {
      debugPrint('Error saving theme preferences: $e');
    }
  }

  void toggleTheme() {
    switch (_selectedTheme) {
      case AppTheme.light:
        _selectedTheme = AppTheme.dark;
        break;
      case AppTheme.dark:
        _selectedTheme = AppTheme.system;
        break;
      case AppTheme.system:
        _selectedTheme = AppTheme.light;
        break;
    }
    notifyListeners();
    _savePreferences();
  }

  void setTheme(AppTheme theme) {
    if (_selectedTheme != theme) {
      _selectedTheme = theme;
      notifyListeners();
      _savePreferences();
    }
  }

  void setLightMode() => setTheme(AppTheme.light);
  void setDarkMode() => setTheme(AppTheme.dark);
  void setSystemMode() => setTheme(AppTheme.system);

  void setPrimaryColor(Color color) {
    if (_primaryColor != color) {
      _primaryColor = color;
      notifyListeners();
      _savePreferences();
    }
  }

  void toggleMaterialYou() {
    _useMaterialYou = !_useMaterialYou;
    notifyListeners();
    _savePreferences();
  }

  void setMaterialYou(bool value) {
    if (_useMaterialYou != value) {
      _useMaterialYou = value;
      notifyListeners();
      _savePreferences();
    }
  }

  void resetToDefaults() {
    _selectedTheme = AppTheme.system;
    _primaryColor = Colors.blue;
    _useMaterialYou = true;
    notifyListeners();
    _savePreferences();
  }

  // Predefined color schemes
  static const List<ColorSchemeOption> predefinedColors = [
    ColorSchemeOption(name: 'Blue', color: Colors.blue, icon: Icons.water_drop),
    ColorSchemeOption(name: 'Purple', color: Colors.purple, icon: Icons.auto_awesome),
    ColorSchemeOption(name: 'Green', color: Colors.green, icon: Icons.eco),
    ColorSchemeOption(name: 'Orange', color: Colors.orange, icon: Icons.wb_sunny),
    ColorSchemeOption(name: 'Pink', color: Colors.pink, icon: Icons.favorite),
    ColorSchemeOption(name: 'Teal', color: Colors.teal, icon: Icons.waves),
    ColorSchemeOption(name: 'Red', color: Colors.red, icon: Icons.local_fire_department),
    ColorSchemeOption(name: 'Indigo', color: Colors.indigo, icon: Icons.nights_stay),
  ];

  ColorSchemeOption? get currentColorScheme {
    return predefinedColors.firstWhere(
          (scheme) => scheme.color == _primaryColor,
      orElse: () => ColorSchemeOption(
        name: 'Custom',
        color: _primaryColor,
        icon: Icons.palette,
      ),
    );
  }

  // Light theme , Google Fonts
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _useMaterialYou
          ? ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      )
          : ColorScheme.light(
        primary: _primaryColor,
        secondary: _primaryColor.withOpacity(0.8),
      ),

      // add Google Fonts
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Dark theme , Google Fonts
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _useMaterialYou
          ? ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      )
          : ColorScheme.dark(
        primary: _primaryColor,
        secondary: _primaryColor.withOpacity(0.8),
      ),

      // add Google Fonts
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade900,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class ColorSchemeOption {
  final String name;
  final Color color;
  final IconData icon;

  const ColorSchemeOption({
    required this.name,
    required this.color,
    required this.icon,
  });
}

extension AppThemeExtension on AppTheme {
  String get displayName {
    switch (this) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case AppTheme.light:
        return Icons.light_mode;
      case AppTheme.dark:
        return Icons.dark_mode;
      case AppTheme.system:
        return Icons.brightness_auto;
    }
  }

  String get description {
    switch (this) {
      case AppTheme.light:
        return 'Always use light theme';
      case AppTheme.dark:
        return 'Always use dark theme';
      case AppTheme.system:
        return 'Follow system settings';
    }
  }
}