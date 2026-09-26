import '../models/booking.dart';

/// Pure logic for splitting a tanker delivery's total cost across flats in a
/// shared building. Kept free of Flutter/Bloc so it is trivial to unit test.
class CostSplitter {
  const CostSplitter._();

  /// Splits [totalPrice] evenly across [flatLabels].
  ///
  /// Naira amounts must add back up to exactly [totalPrice] (to the kobo),
  /// so any remainder from integer division of kobo is distributed one kobo
  /// at a time to the first flats in the list.
  static List<FlatShare> splitEvenly({
    required double totalPrice,
    required List<String> flatLabels,
  }) {
    if (flatLabels.isEmpty) {
      throw ArgumentError('At least one flat is required to split a booking.');
    }

    final totalKobo = (totalPrice * 100).round();
    final baseShareKobo = totalKobo ~/ flatLabels.length;
    final remainderKobo = totalKobo - (baseShareKobo * flatLabels.length);

    return List.generate(flatLabels.length, (index) {
      final extra = index < remainderKobo ? 1 : 0;
      final shareKobo = baseShareKobo + extra;
      return FlatShare(flatLabel: flatLabels[index], shareAmount: shareKobo / 100);
    });
  }

  /// Splits [totalPrice] by explicit weights (e.g. number of occupants or
  /// flat size) instead of evenly. [weights] must be the same length as
  /// [flatLabels] and contain only positive values.
  static List<FlatShare> splitByWeight({
    required double totalPrice,
    required List<String> flatLabels,
    required List<double> weights,
  }) {
    if (flatLabels.isEmpty || flatLabels.length != weights.length) {
      throw ArgumentError('flatLabels and weights must be non-empty and equal length.');
    }
    if (weights.any((w) => w <= 0)) {
      throw ArgumentError('Weights must be positive.');
    }

    final totalWeight = weights.reduce((a, b) => a + b);
    final totalKobo = (totalPrice * 100).round();

    final rawShares = weights.map((w) => totalKobo * (w / totalWeight)).toList();
    final flooredShares = rawShares.map((s) => s.floor()).toList();
    var allocatedKobo = flooredShares.fold<int>(0, (sum, v) => sum + v);
    var remainderKobo = totalKobo - allocatedKobo;

    // Distribute leftover kobo to the shares with the largest fractional part.
    final fractionalOrder = List<int>.generate(flatLabels.length, (i) => i)
      ..sort((a, b) => (rawShares[b] - flooredShares[b]).compareTo(rawShares[a] - flooredShares[a]));

    final shareKobo = List<int>.from(flooredShares);
    for (var i = 0; i < remainderKobo; i++) {
      shareKobo[fractionalOrder[i % fractionalOrder.length]] += 1;
    }

    return List.generate(flatLabels.length, (index) {
      return FlatShare(flatLabel: flatLabels[index], shareAmount: shareKobo[index] / 100);
    });
  }

  /// Verifies a list of shares sums (to the kobo) back to [totalPrice].
  static bool sharesReconcile(List<FlatShare> shares, double totalPrice) {
    final sumKobo = shares.fold<int>(0, (sum, s) => sum + (s.shareAmount * 100).round());
    return sumKobo == (totalPrice * 100).round();
  }
}
