import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/booking.dart';
import '../../domain/models/tanker.dart';
import '../../domain/services/cost_splitter.dart';
import '../blocs/booking_bloc.dart';
import '../widgets/booking_confirmed_overlay.dart';

/// Bottom sheet for booking a tanker, with an optional cost-split calculator
/// for shared buildings (multiple flats splitting one delivery).
class BookingSheet extends StatefulWidget {
  final Tanker tanker;
  const BookingSheet({super.key, required this.tanker});

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  bool _splitCost = false;
  final List<TextEditingController> _flatControllers = [
    TextEditingController(text: 'Flat 1'),
    TextEditingController(text: 'Flat 2'),
  ];

  double get _basePrice => widget.tanker.pricePerTrip;
  double get _commission =>
      double.parse((_basePrice * kDefaultCommissionRate).toStringAsFixed(2));
  double get _totalPrice => _basePrice + _commission;

  List<String> get _flatLabels => _flatControllers
      .map((c) => c.text.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  void _addFlat() => setState(() => _flatControllers
      .add(TextEditingController(text: 'Flat ${_flatControllers.length + 1}')));

  void _removeFlat(int index) =>
      setState(() => _flatControllers.removeAt(index));

  @override
  void dispose() {
    for (final c in _flatControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels =
        _splitCost && _flatLabels.length >= 2 ? _flatLabels : const <String>[];
    final shares = labels.isNotEmpty
        ? CostSplitter.splitEvenly(totalPrice: _totalPrice, flatLabels: labels)
        : const <FlatShare>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book ${widget.tanker.vendorName}',
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.textPrimary)),
            const Gap(4),
            Text(widget.tanker.capacityLabel,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
            const Gap(20),
            _PriceRow(
                label: 'Tanker price', value: Formatters.currency(_basePrice)),
            const Gap(8),
            _PriceRow(
                label: 'Platform service fee',
                value: Formatters.currency(_commission)),
            const Divider(height: 24),
            _PriceRow(
              label: 'Total',
              value: Formatters.currency(_totalPrice),
              emphasize: true,
            ),
            const Gap(20),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _splitCost,
              onChanged: (v) => setState(() => _splitCost = v),
              activeColor: AppColors.primary,
              title: Text('Split cost across flats',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary)),
              subtitle: Text(
                  'Share this delivery with neighbours in your building',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textSecondary)),
            ),
            if (_splitCost) ...[
              const Gap(8),
              ..._flatControllers.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          controller: e.value,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.textPrimary),
                          decoration:
                              const InputDecoration(hintText: 'Flat label'),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      if (_flatControllers.length > 2)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded,
                              color: AppColors.danger),
                          onPressed: () => _removeFlat(e.key),
                        ),
                    ]),
                  )),
              TextButton.icon(
                onPressed: _addFlat,
                icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                label: Text('Add another flat',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary)),
              ),
              if (shares.isNotEmpty) ...[
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    children: shares
                        .map((s) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(s.flatLabel,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textPrimary)),
                                  Text(Formatters.currency(s.shareAmount),
                                      style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ] else if (_splitCost && _flatLabels.length < 2)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Add at least 2 flats to split the cost',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.warning)),
                ),
            ],
            const Gap(24),
            ElevatedButton(
              onPressed: () {
                context
                    .read<BookingBloc>()
                    .add(TankerBooked(widget.tanker, flatLabels: labels));
                final vendorName = widget.tanker.vendorName;
                final navigator = Navigator.of(context);
                navigator.pop();
                showBookingConfirmedAnimation(navigator.context,
                    vendorName: vendorName);
              },
              child: const Text('Confirm booking'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  const _PriceRow(
      {required this.label, required this.value, this.emphasize = false});

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)
        : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: emphasize
                ? AppTextStyles.headlineSmall
                    .copyWith(color: AppColors.textPrimary)
                : style),
        Text(value, style: style),
      ],
    );
  }
}
