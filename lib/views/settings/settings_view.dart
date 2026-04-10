import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/l10n_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    AppSpacing.md,
                  ),
                  child:
                      Text(l10n.settingsTitle, style: AppTextStyles.largeTitle),
                ),

                // Language section
                _SectionLabel(l10n.sectionLanguage),
                _SettingsGroup(children: [
                  _SettingsTile(
                    icon: Icons.language,
                    iconColor: AppColors.primary,
                    title: l10n.language,
                    trailing: Text(
                      SettingsViewModel.supportedLanguages.firstWhere(
                        (l) => l['code'] == vm.locale.languageCode,
                        orElse: () => {'native': vm.locale.languageCode},
                      )['native']!,
                      style: AppTextStyles.callout.copyWith(
                          color: AppColors.textSecondary),
                    ),
                    onTap: () => _showLanguagePicker(context, vm),
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),

                // Data section
                _SectionLabel(l10n.sectionData),
                _SettingsGroup(children: [
                  _SettingsTile(
                    icon: Icons.upload_file_outlined,
                    iconColor: AppColors.primary,
                    title: l10n.exportData,
                    subtitle: l10n.exportDataSubtitle,
                    onTap: () async {
                      final ok = await _confirmExport(context);
                      if (ok == true && context.mounted) {
                        await vm.exportData();
                      }
                    },
                    isLoading: vm.isLoading,
                  ),
                  const Divider(height: 1, thickness: 0.5, indent: 52),
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    iconColor: AppColors.info,
                    title: l10n.importData,
                    subtitle: l10n.importDataSubtitle,
                    onTap: () async {
                      await vm.pickImportFile();
                      if (vm.pendingImport != null && context.mounted) {
                        final confirmed =
                            await _confirmImport(context, vm.pendingImport!);
                        if (confirmed == true && context.mounted) {
                          await vm.confirmImport();
                        } else {
                          vm.cancelImport();
                        }
                      }
                    },
                    isLoading: vm.isLoading,
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),

                // App info section
                _SectionLabel(l10n.sectionApp),
                _SettingsGroup(children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    iconColor: AppColors.textSecondary,
                    title: l10n.version,
                    trailing: Text(
                      AppConstants.appVersion,
                      style: AppTextStyles.callout.copyWith(
                          color: AppColors.textSecondary),
                    ),
                  ),
                  const Divider(height: 1, thickness: 0.5, indent: 52),
                  _SettingsTile(
                    icon: Icons.code,
                    iconColor: AppColors.textSecondary,
                    title: 'Mini CRM',
                    trailing: Text(
                      'Flutter + SQLite',
                      style: AppTextStyles.callout.copyWith(
                          color: AppColors.textSecondary),
                    ),
                  ),
                ]),

                if (vm.hasError) ...[
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPaddingH),
                    child: Text(
                      localizeKey(l10n, vm.errorMessage),
                      style: AppTextStyles.footnote
                          .copyWith(color: AppColors.danger),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmExport(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.exportDialogTitle),
        content: Text(l10n.exportDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.exportButton),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmImport(BuildContext context, dynamic bundle) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.importDialogTitle),
        content: Text(l10n.importDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.importButton),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsViewModel vm) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(
                    top: AppSpacing.md, bottom: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.separator,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child:
                  Text(l10n.selectLanguage, style: AppTextStyles.title3),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: SettingsViewModel.supportedLanguages.length,
                itemBuilder: (ctx, i) {
                  final lang = SettingsViewModel.supportedLanguages[i];
                  final isSelected =
                      vm.locale.languageCode == lang['code'];
                  return ListTile(
                    title: Text(lang['native']!,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                    subtitle: Text(lang['name']!,
                        style: AppTextStyles.caption1
                            .copyWith(color: AppColors.textSecondary)),
                    trailing: isSelected
                        ? const Icon(Icons.check,
                            color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      vm.setLocale(Locale(lang['code']!));
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

// ── helpers ──

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        0,
        AppSpacing.screenPaddingH,
        AppSpacing.xs,
      ),
      child: Text(
        text,
        style: AppTextStyles.caption1.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.card),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: AppSpacing.sm + 4,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: AppTextStyles.caption1.copyWith(
                              color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
