import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/income_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../../models/income_model.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncomeViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gelirler', style: AppTextStyles.largeTitle),
                          if (!vm.isLoading)
                            Text(
                              'Bu ay: ${CurrencyUtils.format(vm.thisMonthTotal, 'TRY')}',
                              style: AppTextStyles.footnote
                                  .copyWith(color: AppColors.success),
                            ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.primary,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.incomeForm,
                          );
                          if (context.mounted) vm.refresh();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Platform summary
                if (!vm.isLoading && vm.byPlatform.isNotEmpty) ...[
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPaddingH),
                      itemCount: vm.byPlatform.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        final e = vm.byPlatform.entries.elementAt(i);
                        return _PlatformCard(
                          platform: e.key,
                          total: e.value,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.attach_money,
                              title: 'Henüz gelir yok',
                              subtitle:
                                  'Aldığın ödemeleri buraya ekle.',
                              actionLabel: 'Gelir Ekle',
                              onAction: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteNames.incomeForm,
                                );
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : RefreshIndicator(
                              onRefresh: vm.refresh,
                              color: AppColors.primary,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.screenPaddingH,
                                  right: AppSpacing.screenPaddingH,
                                  bottom: AppSpacing.xxxl,
                                ),
                                itemCount: vm.items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.xs),
                                itemBuilder: (context, i) => _IncomeTile(
                                  income: vm.items[i],
                                  onEdit: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.incomeForm,
                                      arguments: vm.items[i],
                                    );
                                    if (context.mounted) vm.refresh();
                                  },
                                  onDelete: () =>
                                      vm.delete(vm.items[i].id),
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final String platform;
  final double total;
  const _PlatformCard({required this.platform, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(platform, style: AppTextStyles.caption1),
          Text(
            CurrencyUtils.formatCompact(total, 'TRY'),
            style: AppTextStyles.amountSmall.copyWith(
              color: AppColors.success,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeTile extends StatelessWidget {
  final IncomeModel income;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _IncomeTile({
    required this.income,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.attach_money,
                      color: AppColors.success, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        income.sourcePlatform ?? 'Gelir',
                        style: AppTextStyles.subheadline
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      if (income.clientName != null)
                        Text(income.clientName!,
                            style: AppTextStyles.caption1),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyUtils.format(income.amount, income.currency),
                      style: AppTextStyles.amountSmall
                          .copyWith(color: AppColors.success),
                    ),
                    Text(
                      AppDateUtils.toDisplayShort(income.date),
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz,
                      color: AppColors.textTertiary, size: 20),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit', child: Text('Düzenle')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Sil',
                          style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
