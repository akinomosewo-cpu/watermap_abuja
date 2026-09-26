enum BookingStatus { pending, confirmed, enRoute, delivered, cancelled }

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.enRoute:
        return 'En route';
      case BookingStatus.delivered:
        return 'Delivered';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// One flat's share within a shared/split booking.
class FlatShare {
  final String flatLabel;
  final double shareAmount;

  const FlatShare({required this.flatLabel, required this.shareAmount});
}

/// Default commission rate the platform charges the tanker vendor per delivery.
const double kDefaultCommissionRate = 0.08;

class Booking {
  final String id;
  final String tankerId;
  final String vendorName;
  final String districtId;
  final double basePrice;
  final double commissionRate;
  final DateTime createdAt;
  final BookingStatus status;
  final List<FlatShare> flatShares;

  const Booking({
    required this.id,
    required this.tankerId,
    required this.vendorName,
    required this.districtId,
    required this.basePrice,
    required this.createdAt,
    this.commissionRate = kDefaultCommissionRate,
    this.status = BookingStatus.pending,
    this.flatShares = const [],
  });

  /// Commission the platform earns on this delivery.
  double get commissionAmount => double.parse((basePrice * commissionRate).toStringAsFixed(2));

  /// Total the customer(s) pay, including platform commission.
  double get totalPrice => double.parse((basePrice + commissionAmount).toStringAsFixed(2));

  bool get isSplit => flatShares.length > 1;

  Booking copyWith({BookingStatus? status}) {
    return Booking(
      id: id,
      tankerId: tankerId,
      vendorName: vendorName,
      districtId: districtId,
      basePrice: basePrice,
      commissionRate: commissionRate,
      createdAt: createdAt,
      status: status ?? this.status,
      flatShares: flatShares,
    );
  }
}
