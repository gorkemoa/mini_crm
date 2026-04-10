import 'package:flutter/material.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../models/project_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../widgets/badges.dart';
import '../widgets/info_row.dart';
import '../widgets/primary_button.dart';

// ─── ViewModel for project detail (inline, reuses pattern from client_detail)
// We need ProjectDetailViewModel — but it wasn't in the original list.
// We'll use a simple FutureBuilder approach pulling from existing VM instead,
// or pass the project model directly as argument.

class ProjectDetailView extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailView({super.key, required this.project});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  late ProjectModel _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }


  @override
  Widget build(BuildContext context) {
    final p = _project;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(p.title, style: AppTextStyles.navTitle),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.primary,
            onPressed: () async {
              final changed = await Navigator.pushNamed(
                context,
                RouteNames.projectForm,
                arguments: {'project': p},
              );
              if (changed == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
          children: [
            // Status banner
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingH,
                vertical: AppSpacing.cardPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title, style: AppTextStyles.title1),
                        if (p.clientName != null) ...[
                          const SizedBox(height: 4),
                          Text(p.clientName!,
                              style: AppTextStyles.subheadline.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                  ProjectStatusBadge(status: p.status),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Details
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingH),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  if (p.budget != null)
                    InfoRow(
                      label: 'Bütçe',
                      value: CurrencyUtils.format(p.budget!, p.currency),
                    ),
                  if (p.startDate != null)
                    InfoRow(
                      label: 'Başlangıç',
                      value: AppDateUtils.toDisplay(p.startDate!),
                    ),
                  if (p.endDate != null)
                    InfoRow(
                      label: 'Bitiş',
                      value: AppDateUtils.toDisplay(p.endDate!),
                    ),
                  if (p.description != null && p.description!.isNotEmpty)
                    InfoRow(
                      label: 'Açıklama',
                      value: p.description!,
                      isLast: true,
                    ),
                ],
              ),
            ),

            if (p.description == null && p.budget == null)
              const SizedBox(height: AppSpacing.md),

            const SizedBox(height: AppSpacing.lg),

            // Quick action
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingH),
              child: PrimaryButton(
                label: 'Düzenle',
                onPressed: () async {
                  final changed = await Navigator.pushNamed(
                    context,
                    RouteNames.projectForm,
                    arguments: {'project': p},
                  );
                  if (changed == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// suppress unused import warning
