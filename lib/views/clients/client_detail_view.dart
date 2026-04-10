import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/client_model.dart';
import '../../models/debt_model.dart';
import '../../models/project_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/client_detail_viewmodel.dart';
import '../widgets/badges.dart';
import '../widgets/info_row.dart';
import '../widgets/section_header.dart';

class ClientDetailView extends StatefulWidget {
  final ClientModel client;

  const ClientDetailView({super.key, required this.client});

  @override
  State<ClientDetailView> createState() => _ClientDetailViewState();
}

class _ClientDetailViewState extends State<ClientDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientDetailViewModel>().load(widget.client.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientDetailViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        final client = vm.client ?? widget.client;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(client.fullName),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    RouteNames.clientForm,
                    arguments: client,
                  );
                  if (context.mounted) vm.refresh(client.id);
                },
              ),
            ],
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => vm.refresh(client.id),
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPaddingH,
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      // ─── Avatar + Name
                      _ProfileHeader(client: client),
                      const SizedBox(height: AppSpacing.lg),

                      // ─── Contact Info Card
                      _ContactCard(client: client),

                      // ─── Debts
                      SectionHeader(
                        title: l10n.debtsSection,
                        action: l10n.add,
                        onAction: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.debtForm,
                            arguments: {'clientId': client.id},
                          );
                          if (context.mounted) vm.refresh(client.id);
                        },
                      ),
                      if (vm.debts.isEmpty)
                        _EmptyInline(l10n.noDebtsInline)
                      else
                        _DebtList(debts: vm.debts),

                      // ─── Projects
                      SectionHeader(
                        title: l10n.projectsSection,
                        action: l10n.add,
                        onAction: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.projectForm,
                            arguments: {'clientId': client.id},
                          );
                          if (context.mounted) vm.refresh(client.id);
                        },
                      ),
                      if (vm.projects.isEmpty)
                        _EmptyInline(l10n.noProjectsInline)
                      else
                        _ProjectList(projects: vm.projects),

                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final ClientModel client;
  const _ProfileHeader({required this.client});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InitialsAvatar(initials: client.initials, size: 56),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(client.fullName, style: AppTextStyles.title3),
              if (client.companyName != null)
                Text(client.companyName!, style: AppTextStyles.footnote),
            ],
          ),
        ),
        ClientStatusBadge(status: client.status),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final ClientModel client;
  const _ContactCard({required this.client});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <Widget>[];
    if (client.email != null) {
      rows.add(InfoRow(label: l10n.email, value: client.email!));
    }
    if (client.phone != null) {
      rows.add(InfoRow(label: l10n.phone, value: client.phone!));
    }
    if (client.notes != null) {
      rows.add(InfoRow(label: l10n.notes, value: client.notes!, isLast: true));
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    // mark last
    if (rows.isNotEmpty) {
      rows[rows.length - 1] = InfoRow(
        label: rows.last is InfoRow ? (rows.last as InfoRow).label : '',
        value: rows.last is InfoRow ? (rows.last as InfoRow).value : '',
        isLast: true,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding),
        child: Column(
          children: [
            if (client.email != null)
              InfoRow(
                label: l10n.email,
                value: client.email!,
                isLast: client.phone == null && client.notes == null,
              ),
            if (client.phone != null)
              InfoRow(
                label: l10n.phone,
                value: client.phone!,
                isLast: client.notes == null,
              ),
            if (client.notes != null)
              InfoRow(label: l10n.notes, value: client.notes!, isLast: true),
          ],
        ),
      ),
    );
  }
}

class _EmptyInline extends StatelessWidget {
  final String text;
  const _EmptyInline(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.footnote),
    );
  }
}

class _DebtList extends StatelessWidget {
  final List<DebtModel> debts;
  const _DebtList({required this.debts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: debts.asMap().entries.map((e) {
          final debt = e.value;
          final isLast = e.key == debts.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            debt.title,
                            style: AppTextStyles.subheadline.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (debt.dueDate != null)
                            Text(
                              AppDateUtils.toDisplay(debt.dueDate!),
                              style: AppTextStyles.caption1,
                            ),
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
                        DebtStatusBadge(status: debt.status),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: AppSpacing.cardPadding,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  final List<ProjectModel> projects;
  const _ProjectList({required this.projects});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: projects.asMap().entries.map((e) {
          final project = e.value;
          final isLast = e.key == projects.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: AppTextStyles.subheadline.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (project.startDate != null)
                            Text(
                              AppDateUtils.toDisplay(project.startDate!),
                              style: AppTextStyles.caption1,
                            ),
                        ],
                      ),
                    ),
                    ProjectStatusBadge(status: project.status),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: AppSpacing.cardPadding,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
