import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/booking.dart';
import '../../domain/models/tanker.dart';
import '../blocs/booking_bloc.dart';
import '../blocs/tanker_bloc.dart';
import '../widgets/status_badge.dart' show PillChip;
import 'booking_sheet.dart';

class TankerListPage extends StatelessWidget {
  final String districtId;
  final String districtName;
  const TankerListPage(
      {super.key, required this.districtId, required this.districtName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Tankers · $districtName')),
      body: BlocBuilder<TankerBloc, TankerState>(
        builder: (context, state) {
          if (state.loading)
            return const Center(child: CircularProgressIndicator());
          final tankers = state.forDistrict(districtId);
          if (tankers.isEmpty) {
            return Center(
              child: Text('No tankers registered near $districtName yet',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: tankers.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, i) => _TankerCard(tanker: tankers[i]),
          );
        },
      ),
    );
  }
}

class _TankerCard extends StatelessWidget {
  final Tanker tanker;
  const _TankerCard({required this.tanker});

  double get commission => tanker.pricePerTrip * kDefaultCommissionRate;
  double get totalPrice => tanker.pricePerTrip + commission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tanker.vendorName,
                        style: AppTextStyles.headlineSmall
                            .copyWith(color: AppColors.textPrimary)),
                    const Gap(4),
                    Row(children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.warning, size: 15),
                      const Gap(2),
                      Text(tanker.rating.toStringAsFixed(1),
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textSecondary)),
                      const Gap(8),
                      Text('${tanker.completedDeliveries} deliveries',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textSecondary)),
                    ]),
                  ],
                ),
              ),
              if (!tanker.available)
                const PillChip(
                    label: 'Unavailable', color: AppColors.textSecondary),
            ],
          ),
          const Gap(12),
          Row(children: [
            const Icon(Icons.local_shipping_outlined,
                size: 15, color: AppColors.textTertiary),
            const Gap(6),
            Text(tanker.capacityLabel,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary)),
          ]),
          const Gap(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Formatters.currency(totalPrice),
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: AppColors.primary)),
                  Text('incl. service fee',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.textTertiary)),
                ],
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
                onPressed: tanker.available
                    ? () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: AppColors.surface,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (_) => BlocProvider.value(
                            value: context.read<BookingBloc>(),
                            child: BookingSheet(tanker: tanker),
                          ),
                        )
                    : null,
                child: const Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
