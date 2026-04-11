import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/client_detail_viewmodel.dart';
import '../../models/debt_model.dart';
import '../../models/project_model.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import '../widgets/info_row.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class ClientDetailView extends StatefulWidget {
  final String clientId;
  const ClientDetailView({super.key, required this.clientId});

  @override
  State<ClientDetailView> createState() => _ClientDetailViewState();
}

class _ClientDetailViewState extends State<ClientDetailView> {
  late final ClientDetailViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<ClientDetailViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.load(widget.clientId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Client Details'),
        actions: [
          Consumer<ClientDetailViewModel>(
            builder: (_, vm, __) => vm.client == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/clients/form', arguments: vm.client);
                          if (context.mounted) vm.refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        color: AppColors.error,
                        onPressed: () async {
                          final confirmed = await showConfirmDialog(
                            context,
                            title: 'Delete Client',
                            message: 'Delete "${vm.client!.fullName}"?',
                          );
                          if (confirmed && context.mounted) {
                            await vm.deleteClient();
                            if (context.mounted) Navigator.pop(context, true);
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: Consumer<ClientDetailViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (vm.client == null) return const Center(child: Text('Client not found'));
          return _buildContent(context, vm);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ClientDetailViewModel vm) {
    final client = vm.client!;
    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView(
        padding: AppSpacing.screenPaddingAll,
        children: [
          // Header Card
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryContainer,
                  radius: 32,
                  child: Text(
                    client.fullName.isNotEmpty ? client.fullName[0].toUpperCase() : '?',
                    style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.fullName, style: AppTextStyles.h2),
                      if (client.companyName != null)
                        Text(client.companyName!, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.xs),
                      StatusBadge.fromClientStatus(client.status, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Contact Info
          AppCard(
            child: Column(
              children: [
                InfoRow(label: 'Email', value: client.email),
                InfoRow(label: 'Phone', value: client.phone),
                InfoRow(label: 'Created', value: AppDateUtils.formatDate(client.createdAt), showDivider: false),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (client.notes != null) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes', style: AppTextStyles.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(client.notes!, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Debts section
          SectionHeader(
            title: 'Debts (${vm.debts.length})',
            actionLabel: 'Add',
            onAction: () async {
              await Navigator.pushNamed(context, '/debts/form', arguments: {'clientId': client.id});
              if (context.mounted) vm.refresh();
            },
          ),
          ...vm.debts.take(5).map((d) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _DebtItem(debt: d),
              )),
          const SizedBox(height: AppSpacing.md),

          // Projects section
          SectionHeader(
            title: 'Projects (${vm.projects.length})',
            actionLabel: 'Add',
            onAction: () async {
              await Navigator.pushNamed(context, '/projects/form', arguments: {'clientId': client.id});
              if (context.mounted) vm.refresh();
            },
          ),
          ...vm.projects.take(5).map((p) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ProjectItem(project: p),
              )),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _DebtItem extends StatelessWidget {
  final DebtModel debt;
  const _DebtItem({required this.debt});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, '/debts/detail', arguments: debt.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title, style: AppTextStyles.labelLarge),
                Text(AppDateUtils.formatDate(debt.dueDate), style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyUtils.format(debt.amount, debt.currency),
                style: AppTextStyles.amountSmall,
              ),
              StatusBadge.fromDebtStatus(debt.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  final ProjectModel project;
  const _ProjectItem({required this.project});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, '/projects/detail', arguments: project.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: AppTextStyles.labelLarge),
                Text(
                  '${AppDateUtils.formatDate(project.startDate)} – ${AppDateUtils.formatDate(project.endDate)}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          StatusBadge.fromProjectStatus(project.status),
        ],
      ),
    );
  }
}
