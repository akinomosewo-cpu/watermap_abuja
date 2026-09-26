import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Shows a short, non-blocking checkmark scale-in animation to confirm a
/// tanker booking was submitted, then auto-dismisses.
Future<void> showBookingConfirmedAnimation(
  BuildContext context, {
  required String vendorName,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Booking confirmed',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      Future.delayed(const Duration(milliseconds: 1300), () {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return _BookingConfirmedCard(vendorName: vendorName);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

class _BookingConfirmedCard extends StatefulWidget {
  final String vendorName;
  const _BookingConfirmedCard({required this.vendorName});

  @override
  State<_BookingConfirmedCard> createState() => _BookingConfirmedCardState();
}

class _BookingConfirmedCardState extends State<_BookingConfirmedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  )..forward();

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppColors.softShadow(opacity: 0.16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                    parent: _checkController, curve: Curves.elasticOut),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 18),
              Text('Booking confirmed',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text('${widget.vendorName} has been notified',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
