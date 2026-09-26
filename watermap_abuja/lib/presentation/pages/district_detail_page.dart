import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/repair_notice.dart';
import '../blocs/tanker_bloc.dart';
import '../blocs/water_bloc.dart';
import '../widgets/section_header.dart';
import '../widgets/status_badge.dart' show StatusBadge, PillChip;
import 'tanker_list_page.dart';

class DistrictDetailPage extends StatelessWidget {
  final String districtId;
  const DistrictDetailPage({super.key, required this.districtId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('District')),
      body: BlocBuilder<WaterBloc, WaterState>(
        builder: (context, state) {
          if (state is! WaterLoaded) return const SizedBox.shrink();
          final district =
              state.districts.firstWhere((d) => d.id == districtId);
          final notices = state.noticesFor(districtId);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(district.name,
                          style: AppTextStyles.displayMedium
                              .copyWith(color: AppColors.textPrimary)),
                      Text(district.area,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  StatusBadge(status: district.status),
                ],
              ),
              const Gap(8),
              Text('Updated ${Formatters.relativeTime(district.lastUpdated)}',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textTertiary)),
              if (district.daysWithoutWater > 0) ...[
                const Gap(20),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(children: [
                    const Icon(Icons.hourglass_bottom_rounded,
                        color: AppColors.danger),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        '${district.daysWithoutWater} days without piped water',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ]),
                ),
              ],
              const Gap(28),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<TankerBloc>(),
                      child: TankerListPage(
                          districtId: districtId, districtName: district.name),
                    ),
                  ),
                ),
                icon: const Icon(Icons.local_shipping_rounded),
                label: const Text('Book a tanker for this district'),
              ),
              const Gap(28),
              SectionHeader(
                  title: 'Repair notices', trailing: '${notices.length}'),
              const Gap(12),
              if (notices.isEmpty)
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.softShadow(),
                  ),
                  child: Center(
                    child: Text('No repair notices for this district',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...notices.map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NoticeCard(notice: n))),
            ],
          );
        },
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final RepairNotice notice;
  const _NoticeCard({required this.notice});

  Color get _statusColor {
    switch (notice.status) {
      case NoticeStatus.scheduled:
        return AppColors.warning;
      case NoticeStatus.inProgress:
        return AppColors.primary;
      case NoticeStatus.resolved:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.softShadow()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(notice.title,
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.textPrimary))),
              const Gap(8),
              PillChip(label: notice.status.label, color: _statusColor),
            ],
          ),
          const Gap(8),
          Text(notice.description,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const Gap(10),
          Row(children: [
            Text('Issued ${Formatters.shortDate(notice.issuedAt)}',
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.textTertiary)),
            if (notice.expectedResolution != null) ...[
              const Gap(10),
              Text('· ETA ${Formatters.shortDate(notice.expectedResolution!)}',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textTertiary)),
            ],
          ]),
        ],
      ),
    );
  }
}
