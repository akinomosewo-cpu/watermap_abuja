import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/district.dart';

Color statusColor(OutageStatus status) {
  switch (status) {
    case OutageStatus.supplied:
      return AppColors.success;
    case OutageStatus.intermittent:
      return AppColors.warning;
    case OutageStatus.outage:
      return AppColors.danger;
  }
}

/// A small colorful pill for a label + accent color, used for repair-notice
/// status, booking status, and other secondary badges across the app.
class PillChip extends StatelessWidget {
  final String label;
  final Color color;
  const PillChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: AppTextStyles.labelSmall
              .copyWith(color: color, fontWeight: FontWeight.w800)),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final OutageStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 7),
        Text(status.label,
            style: AppTextStyles.labelSmall
                .copyWith(color: color, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
