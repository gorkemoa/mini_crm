import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../models/client_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/clients_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/badges.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ─── Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    children: [
                      Text('Müşteriler', style: AppTextStyles.largeTitle),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.primary,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.clientForm,
                          );
                          if (context.mounted) vm.refresh();
                        },
                      ),
                    ],
                  ),
                ),

                // ─── Search & Filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      SearchField(onChanged: vm.search),
                      const SizedBox(height: AppSpacing.sm),
                      _StatusFilterRow(
                        selected: vm.statusFilter,
                        onSelected: vm.filterByStatus,
                      ),
                    ],
                  ),
                ),

                // ─── List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.people_outline,
                              title: 'Henüz müşteri yok',
                              subtitle: 'İlk müşterini ekleyerek başla.',
                              actionLabel: 'Müşteri Ekle',
                              onAction: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteNames.clientForm,
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
                                itemBuilder: (context, i) {
                                  return _ClientTile(
                                    client: vm.items[i],
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        RouteNames.clientDetail,
                                        arguments: vm.items[i],
                                      );
                                      if (context.mounted) vm.refresh();
                                    },
                                    onDelete: () => _confirmDelete(
                                      context,
                                      vm,
                                      vm.items[i],
                                    ),
                                  );
                                },
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

  void _confirmDelete(
    BuildContext context,
    ClientsViewModel vm,
    ClientModel client,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Müşteriyi Sil'),
        content: Text(
          '${client.fullName} adlı müşteriyi silmek istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteClient(client.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterRow extends StatelessWidget {
  final ClientStatus? selected;
  final ValueChanged<ClientStatus?> onSelected;

  const _StatusFilterRow({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Tümü',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          ...ClientStatus.values.map((s) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: _FilterChip(
                  label: s.label,
                  isSelected: selected == s,
                  onTap: () => onSelected(s),
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption1.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ClientTile({
    required this.client,
    required this.onTap,
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                InitialsAvatar(initials: client.initials),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.fullName,
                        style: AppTextStyles.subheadline.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (client.companyName != null &&
                          client.companyName!.isNotEmpty)
                        Text(
                          client.companyName!,
                          style: AppTextStyles.caption1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ClientStatusBadge(status: client.status),
                const SizedBox(width: AppSpacing.xs),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Düzenle'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Sil',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                    if (v == 'edit') {
                      Navigator.pushNamed(
                        context,
                        RouteNames.clientForm,
                        arguments: client,
                      );
                    }
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
