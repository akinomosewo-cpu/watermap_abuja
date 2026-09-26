import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimary)),
        if (trailing != null) Text(trailing!, style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
