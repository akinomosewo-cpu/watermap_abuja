import 'package:flutter_test/flutter_test.dart';
import 'package:watermap_abuja/domain/models/booking.dart';
import 'package:watermap_abuja/domain/models/tanker.dart';
import 'package:watermap_abuja/domain/services/booking_service.dart';

Tanker _tanker({double price = 25000}) => Tanker(
      id: 't1',
      vendorName: 'AquaFlow Tankers',
      districtId: 'gwarinpa',
      capacityLitres: 10000,
      pricePerTrip: price,
      rating: 4.8,
      completedDeliveries: 10,
      phone: '+2348000000000',
    );

void main() {
  group('BookingService.createBooking', () {
    test('applies the default commission on top of the base price', () {
      final booking = BookingService.createBooking(tanker: _tanker(price: 25000));
      expect(booking.basePrice, 25000);
      expect(booking.commissionAmount, 2000); // 8% of 25000
      expect(booking.totalPrice, 27000);
      expect(booking.status, BookingStatus.pending);
      expect(booking.flatShares, isEmpty);
    });

    test('respects a custom commission rate', () {
      final booking = BookingService.createBooking(tanker: _tanker(price: 20000), commissionRate: 0.10);
      expect(booking.commissionAmount, 2000);
      expect(booking.totalPrice, 22000);
    });

    test('splits the total price evenly across flats when provided', () {
      final booking = BookingService.createBooking(
        tanker: _tanker(price: 30000),
        flatLabels: ['Flat A', 'Flat B', 'Flat C'],
      );
      expect(booking.isSplit, isTrue);
      expect(booking.flatShares.length, 3);
      final sum = booking.flatShares.fold<double>(0, (s, f) => s + f.shareAmount);
      expect(sum, closeTo(booking.totalPrice, 0.01));
    });

    test('splits by weight when weights are provided', () {
      final booking = BookingService.createBooking(
        tanker: _tanker(price: 30000),
        flatLabels: ['1BR', '3BR'],
        weights: [1, 2],
      );
      // total = 32400, weight split 1:2 -> 10800 / 21600
      expect(booking.flatShares[0].shareAmount, closeTo(10800, 0.01));
      expect(booking.flatShares[1].shareAmount, closeTo(21600, 0.01));
    });

    test('a single flat label does not count as split', () {
      final booking = BookingService.createBooking(tanker: _tanker(), flatLabels: ['Flat A']);
      expect(booking.isSplit, isFalse);
      expect(booking.flatShares.single.shareAmount, booking.totalPrice);
    });
  });

  group('Booking.copyWith', () {
    test('updates status while preserving other fields', () {
      final booking = BookingService.createBooking(tanker: _tanker());
      final updated = booking.copyWith(status: BookingStatus.delivered);
      expect(updated.status, BookingStatus.delivered);
      expect(updated.id, booking.id);
      expect(updated.totalPrice, booking.totalPrice);
    });
  });
}
