import 'package:uuid/uuid.dart';

import '../models/booking.dart';
import '../models/tanker.dart';
import 'cost_splitter.dart';

const _uuid = Uuid();

/// Pure logic for turning a tanker + optional flat list into a [Booking].
class BookingService {
  const BookingService._();

  static Booking createBooking({
    required Tanker tanker,
    List<String> flatLabels = const [],
    List<double>? weights,
    double commissionRate = kDefaultCommissionRate,
    DateTime? createdAt,
    String? id,
  }) {
    final booking = Booking(
      id: id ?? _uuid.v4(),
      tankerId: tanker.id,
      vendorName: tanker.vendorName,
      districtId: tanker.districtId,
      basePrice: tanker.pricePerTrip,
      commissionRate: commissionRate,
      createdAt: createdAt ?? DateTime.now(),
    );

    if (flatLabels.isEmpty) {
      return booking;
    }

    final shares = weights != null
        ? CostSplitter.splitByWeight(totalPrice: booking.totalPrice, flatLabels: flatLabels, weights: weights)
        : CostSplitter.splitEvenly(totalPrice: booking.totalPrice, flatLabels: flatLabels);

    return Booking(
      id: booking.id,
      tankerId: booking.tankerId,
      vendorName: booking.vendorName,
      districtId: booking.districtId,
      basePrice: booking.basePrice,
      commissionRate: booking.commissionRate,
      createdAt: booking.createdAt,
      status: booking.status,
      flatShares: shares,
    );
  }
}
