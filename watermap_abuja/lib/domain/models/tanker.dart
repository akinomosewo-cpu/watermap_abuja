/// A tanker vendor that can be booked to deliver water.
class Tanker {
  final String id;
  final String vendorName;
  final String districtId;
  final int capacityLitres;
  final double pricePerTrip;
  final double rating;
  final int completedDeliveries;
  final bool available;
  final String phone;

  const Tanker({
    required this.id,
    required this.vendorName,
    required this.districtId,
    required this.capacityLitres,
    required this.pricePerTrip,
    required this.rating,
    required this.completedDeliveries,
    required this.phone,
    this.available = true,
  });

  String get capacityLabel {
    if (capacityLitres >= 1000) {
      final kilo = capacityLitres / 1000;
      final formatted = kilo == kilo.roundToDouble()
          ? kilo.toStringAsFixed(0)
          : kilo.toStringAsFixed(1);
      return '${formatted}k litres';
    }
    return '$capacityLitres litres';
  }
}
