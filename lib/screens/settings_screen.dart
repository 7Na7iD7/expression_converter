import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/theme_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAppInfoCard(context, l10n),
        const SizedBox(height: 20),
        _buildLanguageSection(context, l10n),
        const SizedBox(height: 20),
        _buildThemeSection(context, l10n),
        const SizedBox(height: 20),
        _buildColorSection(context, l10n),
        const SizedBox(height: 20),
        _buildMaterialYouSection(context, l10n),
        const SizedBox(height: 20),
        _buildAboutSection(context, l10n),
        const SizedBox(height: 20),
        _buildResourcesSection(context, l10n),
        const SizedBox(height: 20),
        _buildResetSection(context, l10n),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildAppInfoCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: ThemeStyles.floatingElement(context),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ThemeStyles.glassMorphism(context),
            child: Icon(
              Icons.functions,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: ThemeStyles.l),
          Text(
            l10n.translate('app_title'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ThemeStyles.s),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeStyles.l,
              vertical: ThemeStyles.s,
            ),
            decoration: ThemeStyles.modernChip(context, selected: true),
            child: Text(
              l10n.translate('version'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).scale();
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.glassCard(context),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeStyles.modernIcon(context),
                    child: const Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Expanded(
                    child: Text(
                      'Language / زبان / 语言 / Idioma',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              Text(
                'Choose your preferred language',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ThemeStyles.xl),
              Consumer<LocaleProvider>(
                builder: (context, localeProvider, child) {
                  return Column(
                    children: LocaleProvider.supportedLocales.map((localeOption) {
                      // isLocaleSelected
                      final isSelected = localeProvider.isLocaleSelected(localeOption.locale);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: ThemeStyles.m),
                        child: _buildLanguageOption(
                          context,
                          localeOption,
                          isSelected,
                              () => localeProvider.setLocale(localeOption.locale),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 50.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildLanguageOption(
      BuildContext context,
      LocaleOption localeOption,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeStyles.radiusL),
      child: AnimatedContainer(
        duration: ThemeStyles.normalDuration,
        curve: ThemeStyles.springCurve,
        padding: const EdgeInsets.all(ThemeStyles.l),
        decoration: isSelected
            ? ThemeStyles.activeCard(context)
            : ThemeStyles.neumorphism(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeStyles.s),
              decoration: ThemeStyles.circleIcon(
                context,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Text(
                localeOption.flag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: ThemeStyles.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localeOption.nativeName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localeOption.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: ThemeStyles.neonGlow(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 14,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                duration: 1000.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.glassCard(context),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeStyles.modernIcon(context),
                    child: const Icon(
                      Icons.palette,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Text(
                    l10n.translate('theme_mode'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              Text(
                l10n.translate('theme_description'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ThemeStyles.xl),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Column(
                    children: [
                      _buildThemeOption(
                        context,
                        l10n,
                        AppTheme.light,
                        themeProvider.selectedTheme == AppTheme.light,
                            () => themeProvider.setTheme(AppTheme.light),
                      ),
                      const SizedBox(height: ThemeStyles.m),
                      _buildThemeOption(
                        context,
                        l10n,
                        AppTheme.dark,
                        themeProvider.selectedTheme == AppTheme.dark,
                            () => themeProvider.setTheme(AppTheme.dark),
                      ),
                      const SizedBox(height: ThemeStyles.m),
                      _buildThemeOption(
                        context,
                        l10n,
                        AppTheme.system,
                        themeProvider.selectedTheme == AppTheme.system,
                            () => themeProvider.setTheme(AppTheme.system),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildThemeOption(
      BuildContext context,
      AppLocalizations l10n,
      AppTheme theme,
      bool isSelected,
      VoidCallback onTap,
      ) {
    String themeKey;
    String themeDescKey;

    switch (theme) {
      case AppTheme.light:
        themeKey = 'light';
        themeDescKey = 'light_desc';
        break;
      case AppTheme.dark:
        themeKey = 'dark';
        themeDescKey = 'dark_desc';
        break;
      case AppTheme.system:
        themeKey = 'system';
        themeDescKey = 'system_desc';
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeStyles.radiusL),
      child: AnimatedContainer(
        duration: ThemeStyles.normalDuration,
        curve: ThemeStyles.springCurve,
        padding: const EdgeInsets.all(ThemeStyles.l),
        decoration: isSelected
            ? ThemeStyles.activeCard(context)
            : ThemeStyles.neumorphism(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeStyles.s),
              decoration: ThemeStyles.circleIcon(
                context,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Icon(
                theme.icon,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: ThemeStyles.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate(themeKey),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.translate(themeDescKey),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: ThemeStyles.neonGlow(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 14,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                duration: 1000.ms,
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.bentoCard(context),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeStyles.modernIcon(
                      context,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Icon(
                      Icons.color_lens,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Text(
                    l10n.translate('primary_color'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              Text(
                l10n.translate('color_description'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ThemeStyles.xl),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Wrap(
                    spacing: ThemeStyles.m,
                    runSpacing: ThemeStyles.m,
                    children: ThemeProvider.predefinedColors.map((colorOption) {
                      final isSelected = themeProvider.primaryColor == colorOption.color;
                      return GestureDetector(
                        onTap: () => themeProvider.setPrimaryColor(colorOption.color),
                        child: AnimatedContainer(
                          duration: ThemeStyles.normalDuration,
                          curve: ThemeStyles.springCurve,
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorOption.color,
                                      colorOption.color.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(ThemeStyles.radiusL),
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: isSelected
                                      ? ThemeStyles.neonGlow(colorOption.color, intensity: 0.8)
                                      : ThemeStyles.softShadow(context),
                                ),
                                child: Icon(
                                  isSelected ? Icons.check_circle : colorOption.icon,
                                  color: Colors.white,
                                  size: isSelected ? 32 : 28,
                                ),
                              )
                                  .animate(target: isSelected ? 1 : 0)
                                  .scale(
                                duration: 300.ms,
                                begin: const Offset(1.0, 1.0),
                                end: const Offset(1.15, 1.15),
                              ),
                              const SizedBox(height: ThemeStyles.s),
                              Text(
                                colorOption.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildMaterialYouSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.layeredCard(context, layer: 2),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: themeProvider.useMaterialYou
                            ? BoxDecoration(
                          gradient: ThemeStyles.vibrantGradient(context),
                          borderRadius: BorderRadius.circular(ThemeStyles.radiusM),
                          boxShadow: ThemeStyles.neonGlow(
                            Theme.of(context).colorScheme.primary,
                            intensity: 0.5,
                          ),
                        )
                            : ThemeStyles.neumorphism(
                          context,
                          radius: ThemeStyles.radiusM,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: themeProvider.useMaterialYou
                              ? Colors.white
                              : Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: ThemeStyles.l),
                      Expanded(
                        child: Text(
                          l10n.translate('material_you'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: themeProvider.useMaterialYou,
                        onChanged: (value) => themeProvider.setMaterialYou(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeStyles.m),
                  Container(
                    padding: const EdgeInsets.all(ThemeStyles.m),
                    decoration: ThemeStyles.bentoBox(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: ThemeStyles.s),
                        Expanded(
                          child: Text(
                            l10n.translate('material_you_desc'),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.glassCard(context),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeStyles.modernIcon(
                      context,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Text(
                    l10n.translate('about'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              Text(
                l10n.translate('about_description'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
              const SizedBox(height: ThemeStyles.l),
              Wrap(
                spacing: ThemeStyles.s,
                runSpacing: ThemeStyles.s,
                children: [
                  _buildFeatureChip(context, l10n, 'stack_visualization_feature', Icons.layers),
                  _buildFeatureChip(context, l10n, 'step_by_step_feature', Icons.format_list_numbered),
                  _buildFeatureChip(context, l10n, 'auto_play_feature', Icons.play_circle),
                  _buildFeatureChip(context, l10n, 'examples_feature', Icons.lightbulb),
                  _buildFeatureChip(context, l10n, 'dark_mode_feature', Icons.dark_mode),
                  _buildFeatureChip(context, l10n, 'material_you_feature', Icons.auto_awesome),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildFeatureChip(BuildContext context, AppLocalizations l10n, String key, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeStyles.m,
        vertical: ThemeStyles.s,
      ),
      decoration: ThemeStyles.modernChip(context, selected: true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: ThemeStyles.xs + 2),
          Text(
            l10n.translate(key),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Container(
        decoration: ThemeStyles.bentoCard(context),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: ThemeStyles.modernIcon(
                      context,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: const Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Text(
                    l10n.translate('resources'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              _buildResourceTile(
                context,
                l10n,
                'tutorial',
                'tutorial_desc',
                Icons.school,
                    () {},
              ),
              const SizedBox(height: ThemeStyles.m),
              _buildResourceTile(
                context,
                l10n,
                'documentation',
                'documentation_desc',
                Icons.description,
                    () {},
              ),
              const SizedBox(height: ThemeStyles.m),
              _buildResourceTile(
                context,
                l10n,
                'source_code',
                'source_code_desc',
                Icons.code,
                    () {},
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildResourceTile(
      BuildContext context,
      AppLocalizations l10n,
      String titleKey,
      String subtitleKey,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeStyles.radiusM),
      child: Container(
        padding: const EdgeInsets.all(ThemeStyles.l),
        decoration: ThemeStyles.neumorphism(context, radius: ThemeStyles.radiusM),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeStyles.s),
              decoration: ThemeStyles.circleIcon(context),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: ThemeStyles.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate(titleKey),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    l10n.translate(subtitleKey),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        side: BorderSide(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.05),
              Colors.red.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeStyles.radiusXXL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ThemeStyles.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ThemeStyles.radiusM),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.restore,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: ThemeStyles.l),
                  Text(
                    l10n.translate('reset_settings'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeStyles.l),
              Text(
                l10n.translate('reset_description'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: ThemeStyles.l),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ThemeStyles.radiusXL),
                            ),
                            title: Text(l10n.translate('reset_dialog_title')),
                            content: Text(l10n.translate('reset_dialog_content')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.translate('cancel')),
                              ),
                              FilledButton(
                                onPressed: () {
                                  themeProvider.resetToDefaults();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.translate('settings_reset')),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ThemeStyles.radiusM),
                                      ),
                                    ),
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(l10n.translate('reset')),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.restore, color: Colors.red),
                      label: Text(l10n.translate('reset_to_defaults')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: ThemeStyles.l),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeStyles.radiusL),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideX(begin: 0.2, end: 0);
  }
}