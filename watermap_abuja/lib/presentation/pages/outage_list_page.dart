import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/district.dart';
import '../blocs/water_bloc.dart';
import '../widgets/section_header.dart';
import '../widgets/status_badge.dart';
import 'district_detail_page.dart';

class OutageListPage extends StatelessWidget {
  const OutageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<WaterBloc, WaterState>(
        builder: (context, state) {
          if (state is! WaterLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final districts = state.districts;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.background,
                title: Text('Water Map', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary)),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Gap(4),
                    _SummaryBanner(districtsInOutage: state.districtsInOutage, total: districts.length),
                    const Gap(24),
                    const SectionHeader(title: 'Districts'),
                    const Gap(12),
                    ...districts.map((d) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DistrictTile(district: d, noticeCount: state.noticesFor(d.id).length),
                        )),
                    const Gap(24),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final int districtsInOutage;
  final int total;
  const _SummaryBanner({required this.districtsInOutage, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$districtsInOutage of $total districts', style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                Text('currently without tap water', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.85))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistrictTile extends StatelessWidget {
  final District district;
  final int noticeCount;
  const _DistrictTile({required this.district, required this.noticeCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DistrictDetailPage(districtId: district.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(district.name, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
                  const Gap(4),
                  Text(district.area, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                  const Gap(8),
                  Row(children: [
                    StatusBadge(status: district.status),
                    if (district.daysWithoutWater > 0) ...[
                      const Gap(8),
                      Text('${district.daysWithoutWater}d dry', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary)),
                    ],
                  ]),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Formatters.relativeTime(district.lastUpdated), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textTertiary)),
                const Gap(6),
                if (noticeCount > 0)
                  Text('$noticeCount notice${noticeCount == 1 ? '' : 's'}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
