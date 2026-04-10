import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
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
        return Scaffold(
          backgroundColor: AppColors.background,
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
                      Text('Ayarlar', style: AppTextStyles.largeTitle),
                ),

                // Data section
                _SectionLabel('VERİ'),
                _SettingsGroup(children: [
                  _SettingsTile(
                    icon: Icons.upload_file_outlined,
                    iconColor: AppColors.primary,
                    title: 'Veriyi Dışa Aktar',
                    subtitle: 'Tüm veriyi JSON olarak paylaş',
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
                    title: 'Veriyi İçe Aktar',
                    subtitle: 'JSON dosyasından yükle',
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
                _SectionLabel('UYGULAMA'),
                _SettingsGroup(children: [
                  _SettingsTile(
                    icon: Icons.info_outline,
                    iconColor: AppColors.textSecondary,
                    title: 'Sürüm',
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
                      vm.errorMessage!,
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
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Veriyi Dışa Aktar'),
        content: const Text(
          'Tüm müşteri, borç, proje ve gelir verileri JSON formatında dışa aktarılacak ve paylaşım menüsü açılacak.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aktar'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmImport(BuildContext context, dynamic bundle) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Veriyi İçe Aktar'),
        content: const Text(
          'Bu işlem mevcut verilerin üzerine yazmaz; seçilen dosyadaki kayıtlar eklenir. Devam etmek istiyor musun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('İçe Aktar'),
          ),
        ],
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
