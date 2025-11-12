import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Domain Layer

/// Result wrapper for async operations
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Failure(this.message, [this.exception]);
}

/// Locale configuration entity
final class LocaleOption {
  final Locale locale;
  final String name;
  final String nativeName;
  final String flag;
  final bool isRTL;

  const LocaleOption({
    required this.locale,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.isRTL = false,
  });

  String get languageCode => locale.languageCode;
  String? get countryCode => locale.countryCode;

  String get displayName => name == nativeName ? name : '$nativeName ($name)';

  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocaleOption &&
              other.locale == locale;

  @override
  int get hashCode => locale.hashCode;

  LocaleOption copyWith({
    Locale? locale,
    String? name,
    String? nativeName,
    String? flag,
    bool? isRTL,
  }) {
    return LocaleOption(
      locale: locale ?? this.locale,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      flag: flag ?? this.flag,
      isRTL: isRTL ?? this.isRTL,
    );
  }

  @override
  String toString() => 'LocaleOption($languageCode, $name)';
}

// Data Layer

/// Abstract repository interface for dependency injection
abstract interface class ILocaleRepository {
  Future<Result<Locale>> loadLocale();
  Future<Result<void>> saveLocale(Locale locale);
  Future<Result<void>> clearLocale();
  Locale getSystemLocale();
}

/// Concrete implementation using SharedPreferences
final class LocaleRepository implements ILocaleRepository {
  static const String _languageKey = 'app_language_code';
  static const String _countryKey = 'app_country_code';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<Result<Locale>> loadLocale() async {
    try {
      final prefs = await _preferences;
      final languageCode = prefs.getString(_languageKey);

      if (languageCode == null) {
        return Success(getSystemLocale());
      }

      final countryCode = prefs.getString(_countryKey);
      return Success(Locale(languageCode, countryCode));
    } on Exception catch (e) {
      return Failure('Failed to load locale preferences', e);
    }
  }

  @override
  Future<Result<void>> saveLocale(Locale locale) async {
    try {
      final prefs = await _preferences;

      await prefs.setString(_languageKey, locale.languageCode);

      if (locale.countryCode != null) {
        await prefs.setString(_countryKey, locale.countryCode!);
      } else {
        await prefs.remove(_countryKey);
      }

      return const Success(null);
    } on Exception catch (e) {
      return Failure('Failed to save locale preferences', e);
    }
  }

  @override
  Future<Result<void>> clearLocale() async {
    try {
      final prefs = await _preferences;
      await Future.wait([
        prefs.remove(_languageKey),
        prefs.remove(_countryKey),
      ]);
      return const Success(null);
    } on Exception catch (e) {
      return Failure('Failed to clear locale preferences', e);
    }
  }

  @override
  Locale getSystemLocale() {
    return WidgetsBinding.instance.platformDispatcher.locale;
  }

  /// Clear cache for testing purposes
  void clearCache() {
    _prefs = null;
  }
}

// Presentation Layer

/// Immutable state for LocaleProvider
final class LocaleState {
  final Locale locale;
  final LocaleOption? config;
  final bool isLoading;
  final String? error;

  const LocaleState({
    required this.locale,
    this.config,
    this.isLoading = false,
    this.error,
  });

  const LocaleState.initial()
      : locale = const Locale('en'),
        config = null,
        isLoading = true,
        error = null;

  LocaleState copyWith({
    Locale? locale,
    LocaleOption? config,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get hasError => error != null;
  bool get isRTL => config?.isRTL ?? false;
  TextDirection get textDirection => config?.textDirection ?? TextDirection.ltr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocaleState &&
              other.locale == locale &&
              other.config == config &&
              other.isLoading == isLoading &&
              other.error == error;

  @override
  int get hashCode => Object.hash(locale, config, isLoading, error);

  @override
  String toString() =>
      'LocaleState(locale: $locale, loading: $isLoading, error: $error)';
}

/// Modern LocaleProvider with Clean Architecture principles
class LocaleProvider extends ChangeNotifier {
  final ILocaleRepository _repository;
  LocaleState _state;

  LocaleProvider({
    ILocaleRepository? repository,
    LocaleState? initialState,
  })  : _repository = repository ?? LocaleRepository(),
        _state = initialState ?? const LocaleState.initial() {
    _initialize();
  }

  // Getters

  LocaleState get state => _state;
  Locale get locale => _state.locale;
  LocaleOption? get currentConfig => _state.config;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  bool get hasError => _state.hasError;
  bool get isRTL => _state.isRTL;
  TextDirection get textDirection => _state.textDirection;

  // Public Methods

  /// Change to a new locale
  Future<void> setLocale(Locale newLocale) async {
    if (_state.locale == newLocale) return;

    final config = _findOption(newLocale);

    // Optimistic update
    _updateState(_state.copyWith(
      locale: newLocale,
      config: config,
      clearError: true,
    ));

    final result = await _repository.saveLocale(newLocale);

    if (result is Failure) {
      _updateState(_state.copyWith(error: result.message));
    }
  }

  /// Change locale by language code
  Future<void> setLocaleByCode(String languageCode) async {
    final option = supportedLocales.firstWhere(
          (opt) => opt.languageCode == languageCode,
      orElse: () => supportedLocales.first,
    );
    await setLocale(option.locale);
  }

  /// Reset to system default locale
  Future<void> resetToSystemLocale() async {
    final result = await _repository.clearLocale();

    final systemLocale = _repository.getSystemLocale();
    final config = _findOption(systemLocale);

    _updateState(_state.copyWith(
      locale: systemLocale,
      config: config,
      error: result is Failure ? result.message : null,
      clearError: result is Success,
    ));
  }

  /// Check if a locale is currently selected
  bool isLocaleSelected(Locale locale) {
    return _state.locale == locale;
  }

  /// Clear error message
  void clearError() {
    if (_state.hasError) {
      _updateState(_state.copyWith(clearError: true));
    }
  }

  // Private Methods

  Future<void> _initialize() async {
    final result = await _repository.loadLocale();

    switch (result) {
      case Success<Locale>(:final data):
        final config = _findOption(data);
        _updateState(LocaleState(
          locale: data,
          config: config,
          isLoading: false,
        ));

      case Failure<Locale>(:final message):
        final systemLocale = _repository.getSystemLocale();
        final config = _findOption(systemLocale);
        _updateState(LocaleState(
          locale: systemLocale,
          config: config,
          isLoading: false,
          error: message,
        ));
    }
  }

  void _updateState(LocaleState newState) {
    if (_state == newState) return;
    _state = newState;
    notifyListeners();
  }

  LocaleOption? _findOption(Locale locale) {
    try {
      return supportedLocales.firstWhere(
            (opt) => opt.languageCode == locale.languageCode,
      );
    } catch (_) {
      return null;
    }
  }

  // Static Configuration

  static const List<LocaleOption> supportedLocales = [
    LocaleOption(
      locale: Locale('en'),
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
      isRTL: false,
    ),
    LocaleOption(
      locale: Locale('fa'),
      name: 'Persian',
      nativeName: 'فارسی',
      flag: '🇮🇷',
      isRTL: true,
    ),
    LocaleOption(
      locale: Locale('zh'),
      name: 'Chinese',
      nativeName: '中文',
      flag: '🇨🇳',
      isRTL: false,
    ),
    LocaleOption(
      locale: Locale('es'),
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
      isRTL: false,
    ),
  ];

  static List<Locale> get supportedAppLocales =>
      supportedLocales.map((opt) => opt.locale).toList();

  static List<String> get supportedLanguageCodes =>
      supportedLocales.map((opt) => opt.languageCode).toList();

  static LocaleOption? findOptionByCode(String code) {
    try {
      return supportedLocales.firstWhere((opt) => opt.languageCode == code);
    } catch (_) {
      return null;
    }
  }
}

// Extensions

extension LocaleX on Locale {
  LocaleOption? get option => LocaleProvider.findOptionByCode(languageCode);
  bool get isRTL => option?.isRTL ?? false;
  TextDirection get textDirection => option?.textDirection ?? TextDirection.ltr;
  String get displayName => option?.displayName ?? languageCode;
}