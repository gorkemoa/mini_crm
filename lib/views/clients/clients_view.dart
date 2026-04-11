import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/clients_viewmodel.dart';
import '../../models/client_model.dart';
import '../../models/enums.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientsViewModel>().load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.pushNamed(context, '/clients/form');
              if (context.mounted) context.read<ClientsViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<ClientsViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                Padding(
                  padding: AppSpacing.screenPaddingAll,
                  child: Column(
                    children: [
                      SearchField(
                        controller: _searchController,
                        hint: 'Search clients...',
                        onChanged: vm.setSearch,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildFilterChips(context, vm),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.isEmpty
                          ? EmptyState(
                              icon: Icons.people_outline_rounded,
                              title: 'No clients yet',
                              description: 'Add your first client to get started',
                              actionLabel: 'Add Client',
                              onAction: () async {
                                await Navigator.pushNamed(context, '/clients/form');
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : vm.isFilteredEmpty
                              ? const Center(child: Text('No results found'))
                              : _buildList(context, vm),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/clients/form');
          if (context.mounted) context.read<ClientsViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ClientsViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            selected: vm.statusFilter == null,
            onSelected: () => vm.setStatusFilter(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Active',
            selected: vm.statusFilter == ClientStatus.active,
            onSelected: () => vm.setStatusFilter(ClientStatus.active),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Inactive',
            selected: vm.statusFilter == ClientStatus.inactive,
            onSelected: () => vm.setStatusFilter(ClientStatus.inactive),
          ),
          const SizedBox(width: AppSpacing.xs),
          _FilterChip(
            label: 'Archived',
            selected: vm.statusFilter == ClientStatus.archived,
            onSelected: () => vm.setStatusFilter(ClientStatus.archived),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ClientsViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      itemCount: vm.clients.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _ClientTile(
        client: vm.clients[i],
        onTap: () async {
          await Navigator.pushNamed(context, '/clients/detail', arguments: vm.clients[i].id);
          if (context.mounted) vm.refresh();
        },
        onDelete: () async {
          final confirmed = await showConfirmDialog(
            context,
            title: 'Delete Client',
            message: 'Delete "${vm.clients[i].fullName}"? This will also delete related debts.',
          );
          if (confirmed && context.mounted) {
            vm.delete(vm.clients[i].id);
          }
        },
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClientTile({required this.client, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: AppSpacing.cardPaddingAll,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                radius: 22,
                child: Text(
                  client.fullName.isNotEmpty ? client.fullName[0].toUpperCase() : '?',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.fullName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (client.companyName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        client.companyName!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                    if (client.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        client.email!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              StatusBadge.fromClientStatus(client.status, context),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.error,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected ? Colors.white : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
