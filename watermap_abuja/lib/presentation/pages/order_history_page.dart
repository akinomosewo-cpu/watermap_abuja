import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/booking.dart';
import '../blocs/booking_bloc.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookings = state.sortedByRecent;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.background,
                title: Text('Orders', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary)),
              ),
              if (bookings.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: AppColors.textTertiary, size: 40),
                        const Gap(12),
                        Text('No bookings yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const Gap(4),
                      ...bookings.map((b) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _BookingCard(booking: b))),
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

class _BookingCard extends StatelessWidget {
  final Booking booking;
  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
      case BookingStatus.enRoute:
        return AppColors.primary;
      case BookingStatus.delivered:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(booking.vendorName, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: _statusColor.withOpacity(0.14), borderRadius: BorderRadius.circular(6)),
                child: Text(booking.status.label, style: AppTextStyles.labelSmall.copyWith(color: _statusColor, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const Gap(6),
          Text(Formatters.shortDate(booking.createdAt), style: AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary)),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total paid', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              Text(Formatters.currency(booking.totalPrice), style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
            ],
          ),
          if (booking.isSplit) ...[
            const Gap(10),
            const Divider(height: 1),
            const Gap(10),
            Text('Split ${booking.flatShares.length} ways', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
            const Gap(6),
            ...booking.flatShares.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.flatLabel, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary)),
                      Text(Formatters.currency(s.shareAmount), style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
