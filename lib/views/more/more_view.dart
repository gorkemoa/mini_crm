import 'package:flutter/material.dart';
import '../../core/constants/route_names.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH,
                AppSpacing.screenPaddingV,
                AppSpacing.screenPaddingH,
                AppSpacing.md,
              ),
              child: Text('Daha Fazla', style: AppTextStyles.largeTitle),
            ),

            _SectionLabel('İŞ TAKİBİ'),
            _MenuGroup(items: [
              _MenuItem(
                icon: Icons.person_search_outlined,
                iconColor: AppColors.purple,
                title: 'Adaylar',
                subtitle: 'Potansiyel müşterileri takip et',
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.leads),
              ),
              _MenuItem(
                icon: Icons.attach_money,
                iconColor: AppColors.success,
                title: 'Gelirler',
                subtitle: 'Ödeme ve gelir kayıtları',
                divider: false,
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.income),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _SectionLabel('HATIRLATICILAR'),
            _MenuGroup(items: [
              _MenuItem(
                icon: Icons.notifications_none_outlined,
                iconColor: AppColors.info,
                title: 'Hatırlatıcılar',
                subtitle: 'Görev ve takvim hatırlatmaları',
                divider: false,
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.reminders),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _SectionLabel('UYGULAMA'),
            _MenuGroup(items: [
              _MenuItem(
                icon: Icons.settings_outlined,
                iconColor: AppColors.textSecondary,
                title: 'Ayarlar',
                subtitle: 'Veri yönetimi ve uygulama bilgisi',
                divider: false,
                onTap: () =>
                    Navigator.pushNamed(context, RouteNames.settings),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

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

class _MenuGroup extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        children: items
            .expand((item) => [
                  item,
                  if (item.divider)
                    const Divider(
                        height: 1, thickness: 0.5, indent: 52),
                ])
            .toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool divider;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.divider = true,
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption1
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
