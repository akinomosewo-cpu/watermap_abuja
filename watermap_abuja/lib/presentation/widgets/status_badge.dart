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

class StatusBadge extends StatelessWidget {
  final OutageStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(status.label, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
