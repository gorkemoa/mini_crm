import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../models/enums.dart';
import '../../core/constants/app_constants.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: Consumer<SettingsViewModel>(
        builder: (context, vm, _) {
          return ListView(
            padding: AppSpacing.screenPaddingAll,
            children: [
              _SectionHeader(title: context.l10n.settingsAppearance),
              _SettingsCard(
                children: [
                  _ThemeTile(vm: vm),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(title: context.l10n.settingsLanguage),
              _SettingsCard(
                children: [
                  _LanguageTile(vm: vm),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(title: context.l10n.settingsData),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.upload_rounded, color: AppColors.primary),
                    title: Text(context.l10n.settingsExport),
                    subtitle: Text(context.l10n.settingsExportDesc),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(context, '/settings/export'),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.download_rounded, color: AppColors.info),
                    title: Text(context.l10n.settingsImport),
                    subtitle: Text(context.l10n.settingsImportDesc),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pushNamed(context, '/settings/import'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionHeader(title: context.l10n.settingsAbout),
              _SettingsCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.textSecondaryLight),
                    title: Text(context.l10n.settingsVersion),
                    trailing: Text(
                      AppConstants.appVersion,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.apps_rounded, color: AppColors.textSecondaryLight),
                    title: const Text('App Name'),
                    trailing: Text(
                      AppConstants.appName,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondaryLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final SettingsViewModel vm;
  const _ThemeTile({required this.vm});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        vm.themeMode == AppThemeMode.dark
            ? Icons.dark_mode_rounded
            : vm.themeMode == AppThemeMode.light
                ? Icons.light_mode_rounded
                : Icons.brightness_auto_rounded,
        color: AppColors.primary,
      ),
      title: Text(context.l10n.settingsTheme),
      trailing: DropdownButton<AppThemeMode>(
        value: vm.themeMode,
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(value: AppThemeMode.system, child: Text(context.l10n.themeSystem)),
          DropdownMenuItem(value: AppThemeMode.light, child: Text(context.l10n.themeLight)),
          DropdownMenuItem(value: AppThemeMode.dark, child: Text(context.l10n.themeDark)),
        ],
        onChanged: (m) {
          if (m != null) vm.setThemeMode(m);
        },
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final SettingsViewModel vm;
  const _LanguageTile({required this.vm});

  static const _languages = {
    'en': 'English',
    'tr': 'Türkçe',
    'zh': '中文',
    'es': 'Español',
    'ar': 'العربية',
    'hi': 'हिंदी',
    'pt': 'Português',
    'fr': 'Français',
    'id': 'Indonesia',
    'ja': '日本語',
    'de': 'Deutsch',
    'ru': 'Русский',
    'ko': '한국어',
    'bn': 'বাংলা',
    'ur': 'اردو',
    'vi': 'Tiếng Việt',
    'it': 'Italiano',
    'fa': 'فارسی',
    'pl': 'Polski',
    'th': 'ภาษาไทย',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language_rounded, color: AppColors.primary),
      title: Text(context.l10n.settingsLanguage),
      trailing: DropdownButton<String>(
        value: vm.locale?.languageCode ?? 'en',
        underline: const SizedBox(),
        items: _languages.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: (l) {
          if (l != null) vm.setLocale(l);
        },
      ),
    );
  }
}
